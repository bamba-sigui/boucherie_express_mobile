from app.core.firebase import get_db
from app.core.errors import NotFoundError

COLLECTION = "categories"


def get_all() -> list[dict]:
    db = get_db()
    docs = db.collection(COLLECTION).order_by("order").stream()
    categories = []
    for doc in docs:
        c = doc.to_dict()
        c["id"] = doc.id
        categories.append(c)
    return categories


def get_by_id(category_id: str) -> dict:
    db = get_db()
    doc = db.collection(COLLECTION).document(category_id).get()
    if not doc.exists:
        raise NotFoundError("Catégorie introuvable")
    c = doc.to_dict()
    c["id"] = doc.id
    return c


def create(data: dict) -> dict:
    db = get_db()
    from google.cloud.firestore_v1 import SERVER_TIMESTAMP
    data["created_at"] = SERVER_TIMESTAMP
    ref = db.collection(COLLECTION).document()
    ref.set(data)
    data["id"] = ref.id
    return data


def update(category_id: str, data: dict) -> dict:
    db = get_db()
    ref = db.collection(COLLECTION).document(category_id)
    if not ref.get().exists:
        raise NotFoundError("Catégorie introuvable")
    ref.update(data)
    updated = ref.get().to_dict()
    updated["id"] = category_id
    return updated


def delete(category_id: str):
    db = get_db()
    ref = db.collection(COLLECTION).document(category_id)
    if not ref.get().exists:
        raise NotFoundError("Catégorie introuvable")
    ref.delete()
