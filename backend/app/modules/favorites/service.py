from . import repository


def get_favorites(uid: str) -> list[dict]:
    return repository.get_user_favorites(uid)


def add_favorite(uid: str, product_id: str):
    repository.add_favorite(uid, product_id)


def remove_favorite(uid: str, product_id: str):
    repository.remove_favorite(uid, product_id)
