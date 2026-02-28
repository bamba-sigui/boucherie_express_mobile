from flask import Blueprint, request, g
from app.core.auth import require_auth
from app.core.errors import success, created, no_content
from . import service

bp = Blueprint("addresses", __name__, url_prefix="/api/v1/addresses")


@bp.get("")
@require_auth
def list_addresses():
    return success(service.list_addresses(g.uid))


@bp.post("")
@require_auth
def add_address():
    data = request.get_json(force=True)
    return created(service.add_address(g.uid, data), "Adresse ajoutée")


@bp.put("/<address_id>")
@require_auth
def update_address(address_id: str):
    data = request.get_json(force=True)
    return success(service.update_address(g.uid, address_id, data), "Adresse mise à jour")


@bp.delete("/<address_id>")
@require_auth
def delete_address(address_id: str):
    service.delete_address(g.uid, address_id)
    return no_content()


@bp.put("/<address_id>/default")
@require_auth
def set_default(address_id: str):
    addresses = service.set_default(g.uid, address_id)
    return success(addresses, "Adresse par défaut mise à jour")
