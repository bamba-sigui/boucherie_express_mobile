from app.core.errors import BadRequestError
from . import repository


def list_addresses(uid: str) -> list[dict]:
    return repository.get_all(uid)


def add_address(uid: str, data: dict) -> dict:
    required = ["title", "detail", "city"]
    missing = [f for f in required if not data.get(f)]
    if missing:
        raise BadRequestError(f"Champs requis : {', '.join(missing)}")
    return repository.add(uid, data)


def update_address(uid: str, address_id: str, data: dict) -> dict:
    return repository.update(uid, address_id, data)


def delete_address(uid: str, address_id: str):
    repository.delete(uid, address_id)


def set_default(uid: str, address_id: str) -> list[dict]:
    return repository.set_default(uid, address_id)
