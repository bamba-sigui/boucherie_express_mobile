from app.core.firebase import get_db
from app.core.errors import NotFoundError

COLLECTION = "products"


def get_all(category_id: str = None, query: str = None, page: int = 1, per_page: int = 20) -> list[dict]:
    db = get_db()
    ref = db.collection(COLLECTION).where("is_active", "==", True)

    if category_id:
        ref = ref.where("category_id", "==", category_id)

    docs = ref.stream()
    products = []
    for doc in docs:
        p = doc.to_dict()
        p["id"] = doc.id
        products.append(p)

    if query:
        q = query.lower()
        products = [
            p for p in products
            if q in p.get("name", "").lower() or q in p.get("description", "").lower()
        ]

    # Pagination simple
    start = (page - 1) * per_page
    return products[start: start + per_page]


def get_by_id(product_id: str) -> dict:
    db = get_db()
    doc = db.collection(COLLECTION).document(product_id).get()
    if not doc.exists:
        raise NotFoundError("Produit introuvable")
    p = doc.to_dict()
    p["id"] = doc.id
    return p


def create(data: dict) -> dict:
    db = get_db()
    from google.cloud.firestore_v1 import SERVER_TIMESTAMP
    data["created_at"] = SERVER_TIMESTAMP
    data["updated_at"] = SERVER_TIMESTAMP
    data.setdefault("is_active", True)
    data.setdefault("stock", 0)
    ref = db.collection(COLLECTION).document()
    ref.set(data)
    data["id"] = ref.id
    return data


def update(product_id: str, data: dict) -> dict:
    db = get_db()
    ref = db.collection(COLLECTION).document(product_id)
    if not ref.get().exists:
        raise NotFoundError("Produit introuvable")
    from google.cloud.firestore_v1 import SERVER_TIMESTAMP
    data["updated_at"] = SERVER_TIMESTAMP
    ref.update(data)
    updated = ref.get().to_dict()
    updated["id"] = product_id
    return updated


def delete(product_id: str):
    db = get_db()
    ref = db.collection(COLLECTION).document(product_id)
    if not ref.get().exists:
        raise NotFoundError("Produit introuvable")
    ref.delete()


def update_stock(product_id: str, new_stock: int) -> dict:
    db = get_db()
    ref = db.collection(COLLECTION).document(product_id)
    if not ref.get().exists:
        raise NotFoundError("Produit introuvable")
    from google.cloud.firestore_v1 import SERVER_TIMESTAMP
    ref.update({"stock": new_stock, "updated_at": SERVER_TIMESTAMP})
    updated = ref.get().to_dict()
    updated["id"] = product_id
    return updated
