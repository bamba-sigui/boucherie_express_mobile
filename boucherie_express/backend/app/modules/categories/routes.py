from flask import Blueprint, request
from app.core.auth import require_admin
from app.core.errors import success, created, no_content
from . import service

bp = Blueprint("categories", __name__, url_prefix="/api/v1/categories")


@bp.get("")
def list_categories():
    return success(service.list_categories())


@bp.get("/<category_id>")
def get_category(category_id: str):
    return success(service.get_category(category_id))


@bp.post("")
@require_admin
def create_category():
    data = request.get_json(force=True)
    return created(service.create_category(data), "Catégorie créée")


@bp.put("/<category_id>")
@require_admin
def update_category(category_id: str):
    data = request.get_json(force=True)
    return success(service.update_category(category_id, data), "Catégorie mise à jour")


@bp.delete("/<category_id>")
@require_admin
def delete_category(category_id: str):
    service.delete_category(category_id)
    return no_content()
