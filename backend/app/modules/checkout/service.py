from datetime import datetime, timezone
from flask import current_app
from google.cloud import firestore as gcloud_firestore

from app.core.firebase import get_db
from app.core.errors import BadRequestError, NotFoundError, UnprocessableError
from app.modules.tracking.repository import create_initial as create_tracking


DELIVERY_FEE_DEFAULT = 2000.0
FREE_DELIVERY_THRESHOLD_DEFAULT = 20000.0


def process_checkout(uid: str, payload: dict) -> dict:
    """
    Endpoint central : transaction atomique Firestore.

    1. Valider le payload
    2. Transaction : vérifier stock + dénormaliser + calculer total
    3. Créer order + tracking
    4. Initialiser paiement si non cash
    5. Décrémenter stock (dans la transaction)
    """
    _validate_payload(payload)

    db = get_db()
    cart_items = payload["cart_items"]
    payment_method = payload["payment_method"]
    address = _resolve_address(uid, payload.get("address_id"))
    note = payload.get("note", "")

    delivery_fee = float(
        current_app.config.get("DELIVERY_FEE", DELIVERY_FEE_DEFAULT)
    )
    free_threshold = float(
        current_app.config.get("FREE_DELIVERY_THRESHOLD", FREE_DELIVERY_THRESHOLD_DEFAULT)
    )

    # ── Transaction Firestore ──────────────────────────────────────────────
    @firestore.transactional
    def _run_transaction(transaction, product_refs, cart_items):
        # 1. Lire tous les produits dans la transaction
        products_snap = [ref.get(transaction=transaction) for ref in product_refs]

        # 2. Vérifier stock et construire les items dénormalisés
        order_items = []
        subtotal = 0.0

        for snap, item in zip(products_snap, cart_items):
            if not snap.exists:
                raise NotFoundError(f"Produit {item['product_id']} introuvable")

            product = snap.to_dict()

            if not product.get("is_active", True):
                raise UnprocessableError(f"Produit '{product['name']}' non disponible")

            qty = int(item["quantity"])
            if product["stock"] < qty:
                raise UnprocessableError(
                    f"Stock insuffisant pour '{product['name']}' "
                    f"(disponible: {product['stock']}, demandé: {qty})"
                )

            unit_price = float(product["price"])
            subtotal += unit_price * qty

            order_items.append({
                "product_id": snap.id,
                "product_name": product["name"],
                "unit_price": unit_price,
                "quantity": qty,
                "option": item.get("option", "Entier"),
                "image_url": product.get("images", [None])[0],
            })

            # 3. Décrémenter le stock dans la transaction
            transaction.update(snap.reference, {"stock": product["stock"] - qty})

        return order_items, subtotal

    # Préparer les références produits
    product_refs = [
        db.collection("products").document(item["product_id"])
        for item in cart_items
    ]

    transaction = db.transaction()
    from google.cloud.firestore_v1 import transactional as firestore_transactional

    # Exécuter la transaction
    order_items, subtotal = _execute_transaction(
        transaction, db, product_refs, cart_items
    )

    # ── Calcul livraison ──────────────────────────────────────────────────
    actual_delivery_fee = 0.0 if subtotal >= free_threshold else delivery_fee
    total = subtotal + actual_delivery_fee

    # ── Récupérer infos utilisateur ───────────────────────────────────────
    user_doc = db.collection("users").document(uid).get()
    user_data = user_doc.to_dict() if user_doc.exists else {}

    # ── Créer la commande ─────────────────────────────────────────────────
    now = datetime.now(timezone.utc)
    order_ref = db.collection("orders").document()
    order_data = {
        "user_id": uid,
        "user_name": user_data.get("name", ""),
        "user_phone": user_data.get("phone", ""),
        "items": order_items,
        "subtotal": subtotal,
        "delivery_fee": actual_delivery_fee,
        "total": total,
        "delivery_address": address,
        "status": "pending",
        "payment_method": payment_method,
        "payment_status": "pending",
        "payment_reference": None,
        "note": note,
        "created_at": now.isoformat(),
        "updated_at": now.isoformat(),
    }
    order_ref.set(order_data)
    order_id = order_ref.id

    # ── Créer le tracking initial ─────────────────────────────────────────
    create_tracking(order_id)

    # ── Initialiser paiement si mobile money ─────────────────────────────
    payment_reference = None
    payment_url = None

    if payment_method != "cash":
        from app.services.payment_service import initialize_payment
        payment_result = initialize_payment(
            order_id=order_id,
            amount=total,
            method=payment_method,
            customer={"name": user_data.get("name", ""), "email": user_data.get("email", "")},
        )
        payment_reference = payment_result.get("reference")
        payment_url = payment_result.get("payment_url")

        # Mettre à jour la commande avec la référence paiement
        db.collection("orders").document(order_id).update(
            {"payment_reference": payment_reference}
        )

    # ── Notification FCM commande reçue ───────────────────────────────────
    fcm_token = user_data.get("fcm_token", "")
    if fcm_token:
        try:
            from app.core.firebase import send_fcm
            send_fcm(
                token=fcm_token,
                title="Commande confirmée ✓",
                body=f"Votre commande de {total:,.0f} FCFA a bien été reçue",
                data={"order_id": order_id, "status": "pending"},
            )
        except Exception:
            pass

    return {
        "order_id": order_id,
        "payment_reference": payment_reference,
        "payment_url": payment_url,
        "subtotal": subtotal,
        "delivery_fee": actual_delivery_fee,
        "total": total,
        "status": "pending",
        "payment_status": "pending",
    }


def _execute_transaction(transaction, db, product_refs, cart_items):
    """Exécute la vérification stock + décrémentation en transaction atomique."""
    order_items = []
    subtotal = 0.0

    snapshots = [ref.get() for ref in product_refs]

    @gcloud_firestore.transactional
    def _txn(transaction):
        nonlocal order_items, subtotal
        snaps = [ref.get(transaction=transaction) for ref in product_refs]

        for snap, item in zip(snaps, cart_items):
            if not snap.exists:
                raise NotFoundError(f"Produit introuvable : {item['product_id']}")

            product = snap.to_dict()
            qty = int(item["quantity"])

            if not product.get("is_active", True):
                raise UnprocessableError(f"Produit '{product['name']}' non disponible")

            if product.get("stock", 0) < qty:
                raise UnprocessableError(
                    f"Stock insuffisant pour '{product['name']}' "
                    f"(disponible: {product.get('stock', 0)}, demandé: {qty})"
                )

            unit_price = float(product["price"])
            subtotal += unit_price * qty
            order_items.append({
                "product_id": snap.id,
                "product_name": product["name"],
                "unit_price": unit_price,
                "quantity": qty,
                "option": item.get("option", "Entier"),
                "image_url": (product.get("images") or [None])[0],
            })

            transaction.update(snap.reference, {
                "stock": gcloud_firestore.Increment(-qty)
            })

    _txn(transaction)
    return order_items, subtotal


def _validate_payload(payload: dict):
    if not payload.get("cart_items"):
        raise BadRequestError("Le panier est vide")
    if not payload.get("payment_method"):
        raise BadRequestError("Méthode de paiement requise")

    valid_methods = ["orange_money", "mtn_momo", "wave", "cash"]
    if payload["payment_method"] not in valid_methods:
        raise BadRequestError(f"Méthode invalide. Valeurs: {', '.join(valid_methods)}")

    for item in payload["cart_items"]:
        if not item.get("product_id"):
            raise BadRequestError("product_id requis pour chaque item")
        if not item.get("quantity") or int(item["quantity"]) <= 0:
            raise BadRequestError("Quantité invalide")


def _resolve_address(uid: str, address_id: str = None) -> dict:
    """Résout l'adresse de livraison : par ID ou adresse par défaut."""
    db = get_db()
    user_doc = db.collection("users").document(uid).get()
    if not user_doc.exists:
        raise BadRequestError("Utilisateur introuvable")

    addresses = user_doc.to_dict().get("addresses", [])
    if not addresses:
        raise BadRequestError("Aucune adresse de livraison enregistrée")

    if address_id:
        addr = next((a for a in addresses if a["id"] == address_id), None)
        if not addr:
            raise NotFoundError("Adresse introuvable")
        return addr

    # Adresse par défaut
    default = next((a for a in addresses if a.get("is_default")), addresses[0])
    return default
