from flask import Blueprint, request, g
from app.core.auth import require_auth, require_admin
from app.core.errors import success
from . import service

bp = Blueprint("tracking", __name__, url_prefix="/api/v1/orders")


@bp.get("/<order_id>/tracking")
@require_auth
def get_tracking(order_id: str):
    return success(service.get_tracking(order_id))


@bp.put("/<order_id>/tracking")
@require_admin
def update_tracking(order_id: str):
    data = request.get_json(force=True)
    return success(service.update_tracking(order_id, data), "Tracking mis à jour")
