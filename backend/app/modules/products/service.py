from app.core.errors import BadRequestError
from . import repository


def list_products(category_id: str = None, query: str = None, page: int = 1) -> list[dict]:
    return repository.get_all(category_id=category_id, query=query, page=page)


def get_product(product_id: str) -> dict:
    return repository.get_by_id(product_id)


def create_product(data: dict) -> dict:
    _validate(data)
    return repository.create(data)


def update_product(product_id: str, data: dict) -> dict:
    return repository.update(product_id, data)


def delete_product(product_id: str):
    repository.delete(product_id)


def update_stock(product_id: str, stock: int) -> dict:
    if stock < 0:
        raise BadRequestError("Le stock ne peut pas être négatif")
    return repository.update_stock(product_id, stock)


def _validate(data: dict):
    required = ["name", "price", "category_id"]
    missing = [f for f in required if not data.get(f)]
    if missing:
        raise BadRequestError(f"Champs requis manquants : {', '.join(missing)}")
    if data.get("price", 0) <= 0:
        raise BadRequestError("Le prix doit être positif")
