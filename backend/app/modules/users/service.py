from . import repository


def get_profile(uid: str) -> dict:
    return repository.get_by_id(uid)


def update_profile(uid: str, data: dict) -> dict:
    return repository.update(uid, data)


def list_users(limit: int = 50) -> list[dict]:
    return repository.get_all(limit=limit)


def get_user(uid: str) -> dict:
    return repository.get_by_id(uid)


def update_fcm_token(uid: str, fcm_token: str):
    repository.update_fcm_token(uid, fcm_token)
