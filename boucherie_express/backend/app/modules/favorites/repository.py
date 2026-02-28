from app.core.firebase import get_db
from app.core.errors import NotFoundError, ConflictError

COLLECTION = "favorites"


def get_user_favorites(uid: str) -> list[dict]:
    """Retourne les produits favoris d'un utilisateur avec leurs données complètes."""
    db = get_db()
    items_ref = (
        db.collection(COLLECTION)
        .document(uid)
        .collection("items")
        .stream()
    )

    product_ids = [doc.id for doc in items_ref]
    if not product_ids:
        return []

    # Récupérer les données des produits
    products = []
    for pid in product_ids:
        doc = db.collection("products").document(pid).get()
        if doc.exists:
            p = doc.to_dict()
            p["id"] = doc.id
            products.append(p)

    return products


def add_favorite(uid: str, product_id: str):
    db = get_db()

    # Vérifier que le produit existe
    product_doc = db.collection("products").document(product_id).get()
    if not product_doc.exists:
        raise NotFoundError("Produit introuvable")

    from google.cloud.firestore_v1 import SERVER_TIMESTAMP
    db.collection(COLLECTION).document(uid).collection("items").document(
        product_id
    ).set({"product_id": product_id, "added_at": SERVER_TIMESTAMP})


def remove_favorite(uid: str, product_id: str):
    db = get_db()
    ref = (
        db.collection(COLLECTION)
        .document(uid)
        .collection("items")
        .document(product_id)
    )
    if not ref.get().exists:
        raise NotFoundError("Favori introuvable")
    ref.delete()
