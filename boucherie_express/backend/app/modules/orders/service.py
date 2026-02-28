from app.core.errors import ForbiddenError
from . import repository

# FCM messages par statut
FCM_MESSAGES = {
    "paid":      ("Paiement confirmé ✓", "Votre paiement a bien été reçu"),
    "preparing": ("En préparation 🔪", "On prépare votre commande avec soin"),
    "shipping":  ("En livraison 🛵", "Votre commande est en route !"),
    "delivered": ("Commande livrée !", "Bonne dégustation 🥩"),
    "cancelled": ("Commande annulée", "Votre commande a été annulée"),
}


def get_user_orders(uid: str) -> list[dict]:
    return repository.get_user_orders(uid)


def get_order(uid: str, order_id: str, is_admin: bool = False) -> dict:
    order = repository.get_by_id(order_id)
    if not is_admin and order["user_id"] != uid:
        raise ForbiddenError("Accès non autorisé à cette commande")
    return order


def list_all_orders(status: str = None, limit: int = 50) -> list[dict]:
    return repository.get_all(status=status, limit=limit)


def update_status(order_id: str, new_status: str) -> dict:
    updated = repository.update_status(order_id, new_status)

    # Notification FCM automatique
    _send_status_notification(updated, new_status)

    return updated


def _send_status_notification(order: dict, status: str):
    if status not in FCM_MESSAGES:
        return
    title, body = FCM_MESSAGES[status]

    # Récupérer le FCM token de l'utilisateur
    from app.core.firebase import get_db, send_fcm
    db = get_db()
    user_doc = db.collection("users").document(order["user_id"]).get()
    if not user_doc.exists:
        return

    fcm_token = user_doc.to_dict().get("fcm_token", "")
    if not fcm_token:
        return

    try:
        send_fcm(
            token=fcm_token,
            title=title,
            body=body,
            data={"order_id": order["id"], "status": status},
        )
    except Exception:
        pass  # Ne pas bloquer si la notification échoue
