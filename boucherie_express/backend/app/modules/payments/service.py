from app.core.firebase import get_db
from app.core.errors import NotFoundError, BadRequestError
from app.services.payment_service import initialize_payment, check_payment_status


def initialize(uid: str, order_id: str) -> dict:
    """Initier le paiement pour une commande existante."""
    db = get_db()
    order_doc = db.collection("orders").document(order_id).get()

    if not order_doc.exists:
        raise NotFoundError("Commande introuvable")

    order = order_doc.to_dict()
    if order["user_id"] != uid:
        from app.core.errors import ForbiddenError
        raise ForbiddenError("Accès non autorisé")

    if order["payment_status"] == "paid":
        raise BadRequestError("Cette commande est déjà payée")

    # Récupérer infos utilisateur
    user_doc = db.collection("users").document(uid).get()
    user_data = user_doc.to_dict() if user_doc.exists else {}

    result = initialize_payment(
        order_id=order_id,
        amount=order["total"],
        method=order["payment_method"],
        customer={"name": user_data.get("name", ""), "email": user_data.get("email", "")},
    )

    # Sauvegarder la référence
    if result.get("reference"):
        db.collection("orders").document(order_id).update(
            {"payment_reference": result["reference"]}
        )

    return result


def check_status(reference: str) -> dict:
    return check_payment_status(reference)


def handle_webhook(payload: dict):
    """
    Traite le callback de l'agrégateur et met à jour la commande.
    Structure CinetPay : { "cpm_trans_id": order_id, "cpm_result": "00", ... }
    """
    db = get_db()

    order_id = payload.get("cpm_trans_id") or payload.get("order_id")
    result_code = payload.get("cpm_result") or payload.get("result_code")

    if not order_id:
        return

    order_ref = db.collection("orders").document(order_id)
    order_doc = order_ref.get()

    if not order_doc.exists:
        return

    # CinetPay : "00" = succès
    is_paid = result_code == "00" or result_code == "success"

    if is_paid:
        order_ref.update({
            "payment_status": "paid",
            "status": "paid",
        })

        # Notification FCM paiement confirmé
        order = order_doc.to_dict()
        _notify_payment_confirmed(order)
    else:
        order_ref.update({"payment_status": "failed"})


def _notify_payment_confirmed(order: dict):
    db = get_db()
    user_doc = db.collection("users").document(order["user_id"]).get()
    if not user_doc.exists:
        return
    fcm_token = user_doc.to_dict().get("fcm_token", "")
    if not fcm_token:
        return
    try:
        from app.core.firebase import send_fcm
        send_fcm(
            token=fcm_token,
            title="Paiement confirmé ✓",
            body="Votre paiement a bien été reçu",
            data={"order_id": order.get("id", ""), "status": "paid"},
        )
    except Exception:
        pass
