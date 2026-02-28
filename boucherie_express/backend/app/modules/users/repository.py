from app.core.firebase import get_db
from app.core.errors import NotFoundError

COLLECTION = "users"


def get_by_id(uid: str) -> dict:
    db = get_db()
    doc = db.collection(COLLECTION).document(uid).get()
    if not doc.exists:
        raise NotFoundError("Utilisateur introuvable")
    u = doc.to_dict()
    u["id"] = doc.id
    return u


def get_all(limit: int = 50) -> list[dict]:
    db = get_db()
    docs = db.collection(COLLECTION).limit(limit).stream()
    users = []
    for doc in docs:
        u = doc.to_dict()
        u["id"] = doc.id
        u.pop("fcm_token", None)  # Ne pas exposer le FCM token
        users.append(u)
    return users


def update(uid: str, data: dict) -> dict:
    db = get_db()
    ref = db.collection(COLLECTION).document(uid)
    if not ref.get().exists:
        raise NotFoundError("Utilisateur introuvable")
    # Champs non modifiables par l'utilisateur lui-même
    data.pop("role", None)
    data.pop("fcm_token", None)
    from google.cloud.firestore_v1 import SERVER_TIMESTAMP
    data["updated_at"] = SERVER_TIMESTAMP
    ref.update(data)
    updated = ref.get().to_dict()
    updated["id"] = uid
    return updated


def update_fcm_token(uid: str, fcm_token: str):
    db = get_db()
    db.collection(COLLECTION).document(uid).update({"fcm_token": fcm_token})
