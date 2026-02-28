from app.core.firebase import get_db
from app.core.errors import NotFoundError
from datetime import datetime, timezone

COLLECTION = "tracking"

DEFAULT_STEPS = [
    {"step": "Commande reçue",  "completed": False, "completed_at": None},
    {"step": "En préparation",  "completed": False, "completed_at": None},
    {"step": "En livraison",    "completed": False, "completed_at": None},
    {"step": "Livrée",          "completed": False, "completed_at": None},
]


def get(order_id: str) -> dict:
    db = get_db()
    doc = db.collection(COLLECTION).document(order_id).get()
    if not doc.exists:
        raise NotFoundError("Suivi de commande introuvable")
    t = doc.to_dict()
    t["order_id"] = order_id
    return t


def create_initial(order_id: str) -> dict:
    """Crée le document de tracking initial lors de la création de commande."""
    db = get_db()
    now = datetime.now(timezone.utc).isoformat()
    data = {
        "order_id": order_id,
        "steps": [
            {"step": "Commande reçue",  "completed": True, "completed_at": now},
            {"step": "En préparation",  "completed": False, "completed_at": None},
            {"step": "En livraison",    "completed": False, "completed_at": None},
            {"step": "Livrée",          "completed": False, "completed_at": None},
        ],
        "eta": None,
        "courier": None,
    }
    db.collection(COLLECTION).document(order_id).set(data)
    return data


def update(order_id: str, data: dict) -> dict:
    db = get_db()
    ref = db.collection(COLLECTION).document(order_id)
    if not ref.get().exists:
        raise NotFoundError("Suivi de commande introuvable")
    ref.update(data)
    updated = ref.get().to_dict()
    updated["order_id"] = order_id
    return updated
