from app.core.errors import BadRequestError
from . import repository


def list_categories() -> list[dict]:
    return repository.get_all()


def get_category(category_id: str) -> dict:
    return repository.get_by_id(category_id)


def create_category(data: dict) -> dict:
    if not data.get("name"):
        raise BadRequestError("Le nom de la catégorie est requis")
    data.setdefault("order", 0)
    return repository.create(data)


def update_category(category_id: str, data: dict) -> dict:
    return repository.update(category_id, data)


def delete_category(category_id: str):
    repository.delete(category_id)
