"""
Service de gestion de stock.
Fournit des utilitaires pour les vérifications et mises à jour de stock.
"""
from google.cloud import firestore as gcloud_firestore
from app.core.firebase import get_db
from app.core.errors import UnprocessableError, NotFoundError


def check_and_reserve(cart_items: list[dict], transaction=None) -> list[dict]:
    """
    Vérifie la disponibilité du stock pour chaque item du panier.
    Utilisé avant la transaction finale dans checkout/service.py.

    Returns: liste des items enrichis avec les données produit
    """
    db = get_db()
    enriched = []

    for item in cart_items:
        product_id = item.get("product_id")
        qty = int(item.get("quantity", 0))

        if not product_id or qty <= 0:
            raise UnprocessableError("Item invalide dans le panier")

        doc = db.collection("products").document(product_id).get()
        if not doc.exists:
            raise NotFoundError(f"Produit introuvable : {product_id}")

        product = doc.to_dict()

        if not product.get("is_active", True):
            raise UnprocessableError(f"Produit '{product['name']}' non disponible")

        if product.get("stock", 0) < qty:
            raise UnprocessableError(
                f"Stock insuffisant pour '{product['name']}' "
                f"(disponible: {product.get('stock', 0)}, demandé: {qty})"
            )

        enriched.append({
            **item,
            "product_name": product["name"],
            "unit_price": float(product["price"]),
            "image_url": (product.get("images") or [None])[0],
            "_stock": product["stock"],
        })

    return enriched


def decrement_stock(product_id: str, quantity: int, transaction=None):
    """Décrémente le stock d'un produit (avec ou sans transaction)."""
    db = get_db()
    ref = db.collection("products").document(product_id)

    if transaction:
        transaction.update(ref, {
            "stock": gcloud_firestore.Increment(-quantity)
        })
    else:
        ref.update({"stock": gcloud_firestore.Increment(-quantity)})


def restore_stock(product_id: str, quantity: int):
    """Restaure le stock en cas d'annulation de commande."""
    db = get_db()
    db.collection("products").document(product_id).update({
        "stock": gcloud_firestore.Increment(quantity)
    })


def restore_order_stock(order_id: str):
    """
    Restaure le stock de tous les items d'une commande annulée.
    Appelé depuis orders/service.py lors d'une annulation.
    """
    db = get_db()
    order_doc = db.collection("orders").document(order_id).get()
    if not order_doc.exists:
        return

    items = order_doc.to_dict().get("items", [])
    for item in items:
        restore_stock(item["product_id"], item["quantity"])
