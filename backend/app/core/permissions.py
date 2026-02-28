from flask import g
from .errors import ForbiddenError


def is_admin() -> bool:
    return getattr(g, "role", "user") == "admin"


def is_owner(resource_uid: str) -> bool:
    """Vérifie que la ressource appartient à l'utilisateur connecté."""
    return getattr(g, "uid", None) == resource_uid


def require_owner_or_admin(resource_uid: str):
    """Lève ForbiddenError si l'utilisateur n'est pas propriétaire ni admin."""
    if not (is_owner(resource_uid) or is_admin()):
        raise ForbiddenError("Accès non autorisé à cette ressource")
