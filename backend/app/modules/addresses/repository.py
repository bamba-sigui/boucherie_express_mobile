import uuid
from app.core.firebase import get_db
from app.core.errors import NotFoundError

COLLECTION = "users"


def _addresses_ref(uid: str):
    return get_db().collection(COLLECTION).document(uid)


def get_all(uid: str) -> list[dict]:
    doc = _addresses_ref(uid).get()
    if not doc.exists:
        return []
    return doc.to_dict().get("addresses", [])


def add(uid: str, data: dict) -> dict:
    data["id"] = str(uuid.uuid4())
    data.setdefault("is_default", False)

    db = get_db()
    ref = db.collection(COLLECTION).document(uid)
    user = ref.get().to_dict() or {}
    addresses = user.get("addresses", [])

    if not addresses:
        data["is_default"] = True

    addresses.append(data)
    ref.update({"addresses": addresses})
    return data


def update(uid: str, address_id: str, data: dict) -> dict:
    db = get_db()
    ref = db.collection(COLLECTION).document(uid)
    user = ref.get().to_dict() or {}
    addresses = user.get("addresses", [])

    idx = next((i for i, a in enumerate(addresses) if a["id"] == address_id), None)
    if idx is None:
        raise NotFoundError("Adresse introuvable")

    data["id"] = address_id
    addresses[idx] = data
    ref.update({"addresses": addresses})
    return data


def delete(uid: str, address_id: str):
    db = get_db()
    ref = db.collection(COLLECTION).document(uid)
    user = ref.get().to_dict() or {}
    addresses = user.get("addresses", [])

    new_addresses = [a for a in addresses if a["id"] != address_id]
    if len(new_addresses) == len(addresses):
        raise NotFoundError("Adresse introuvable")

    ref.update({"addresses": new_addresses})


def set_default(uid: str, address_id: str) -> list[dict]:
    db = get_db()
    ref = db.collection(COLLECTION).document(uid)
    user = ref.get().to_dict() or {}
    addresses = user.get("addresses", [])

    found = False
    for a in addresses:
        a["is_default"] = a["id"] == address_id
        if a["id"] == address_id:
            found = True

    if not found:
        raise NotFoundError("Adresse introuvable")

    ref.update({"addresses": addresses})
    return addresses
