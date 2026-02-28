from app.core.firebase import get_db
from app.core.errors import NotFoundError

COLLECTION = "orders"

VALID_STATUSES = ["pending", "paid", "preparing", "shipping", "delivered", "cancelled"]


def get_by_id(order_id: str) -> dict:
    db = get_db()
    doc = db.collection(COLLECTION).document(order_id).get()
    if not doc.exists:
        raise NotFoundError("Commande introuvable")
    o = doc.to_dict()
    o["id"] = doc.id
    return o


def get_user_orders(uid: str) -> list[dict]:
    db = get_db()
    docs = (
        db.collection(COLLECTION)
        .where("user_id", "==", uid)
        .order_by("created_at", direction="DESCENDING")
        .stream()
    )
    orders = []
    for doc in docs:
        o = doc.to_dict()
        o["id"] = doc.id
        orders.append(o)
    return orders


def get_all(status: str = None, limit: int = 50) -> list[dict]:
    db = get_db()
    ref = db.collection(COLLECTION).order_by("created_at", direction="DESCENDING")
    if status:
        ref = db.collection(COLLECTION).where("status", "==", status).order_by(
            "created_at", direction="DESCENDING"
        )
    docs = ref.limit(limit).stream()
    orders = []
    for doc in docs:
        o = doc.to_dict()
        o["id"] = doc.id
        orders.append(o)
    return orders


def update_status(order_id: str, status: str) -> dict:
    if status not in VALID_STATUSES:
        from app.core.errors import BadRequestError
        raise BadRequestError(f"Statut invalide. Valeurs: {', '.join(VALID_STATUSES)}")

    db = get_db()
    ref = db.collection(COLLECTION).document(order_id)
    if not ref.get().exists:
        raise NotFoundError("Commande introuvable")

    from google.cloud.firestore_v1 import SERVER_TIMESTAMP
    ref.update({"status": status, "updated_at": SERVER_TIMESTAMP})
    updated = ref.get().to_dict()
    updated["id"] = order_id
    return updated
