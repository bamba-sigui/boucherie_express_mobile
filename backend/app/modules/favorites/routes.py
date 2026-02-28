from flask import Blueprint, g
from app.core.auth import require_auth
from app.core.errors import success, created, no_content
from . import service

bp = Blueprint("favorites", __name__, url_prefix="/api/v1/favorites")


@bp.get("")
@require_auth
def get_favorites():
    return success(service.get_favorites(g.uid))


@bp.post("/<product_id>")
@require_auth
def add_favorite(product_id: str):
    service.add_favorite(g.uid, product_id)
    return created(None, "Ajouté aux favoris")


@bp.delete("/<product_id>")
@require_auth
def remove_favorite(product_id: str):
    service.remove_favorite(g.uid, product_id)
    return no_content()
