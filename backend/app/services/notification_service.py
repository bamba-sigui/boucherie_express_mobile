"""
Service de notifications push via Firebase Cloud Messaging.
"""
from app.core.firebase import get_db, send_fcm, send_fcm_multicast


def notify_user(uid: str, title: str, body: str, data: dict = None):
    """Envoie une notification push à un utilisateur par son uid."""
    db = get_db()
    user_doc = db.collection("users").document(uid).get()
    if not user_doc.exists:
        return

    fcm_token = user_doc.to_dict().get("fcm_token", "")
    if not fcm_token:
        return

    try:
        send_fcm(token=fcm_token, title=title, body=body, data=data or {})
    except Exception as e:
        # Log mais ne pas lever d'exception — les notifications sont non-bloquantes
        print(f"[FCM] Erreur envoi notification à {uid}: {e}")


def notify_order_status(order_id: str, uid: str, status: str):
    """Notification automatique lors d'un changement de statut de commande."""
    messages = {
        "paid":      ("Paiement confirmé ✓", "Votre paiement a bien été reçu"),
        "preparing": ("En préparation 🔪", "On prépare votre commande avec soin"),
        "shipping":  ("En livraison 🛵", "Votre commande est en route !"),
        "delivered": ("Commande livrée ! 🥩", "Bonne dégustation"),
        "cancelled": ("Commande annulée", "Votre commande a été annulée"),
    }

    if status not in messages:
        return

    title, body = messages[status]
    notify_user(uid, title, body, data={"order_id": order_id, "status": status})


def notify_all_admins(title: str, body: str, data: dict = None):
    """Envoie une notification à tous les administrateurs."""
    db = get_db()
    admin_docs = (
        db.collection("users")
        .where("role", "==", "admin")
        .stream()
    )

    tokens = []
    for doc in admin_docs:
        token = doc.to_dict().get("fcm_token", "")
        if token:
            tokens.append(token)

    if not tokens:
        return

    try:
        send_fcm_multicast(tokens=tokens, title=title, body=body, data=data or {})
    except Exception as e:
        print(f"[FCM] Erreur multicast admins: {e}")
