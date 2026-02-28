from flask import Blueprint, request, g
from app.core.auth import require_auth, require_admin
from app.core.errors import success
from . import service

bp = Blueprint("orders", __name__, url_prefix="/api/v1")


# ── Utilisateur ───────────────────────────────────────────────────────────────

@bp.get("/orders")
@require_auth
def get_user_orders():
    return success(service.get_user_orders(g.uid))


@bp.get("/orders/<order_id>")
@require_auth
def get_order(order_id: str):
    is_admin = getattr(g, "role", "user") == "admin"
    return success(service.get_order(g.uid, order_id, is_admin=is_admin))


# ── Admin ─────────────────────────────────────────────────────────────────────

@bp.get("/admin/orders")
@require_admin
def list_all_orders():
    status = request.args.get("status")
    limit = int(request.args.get("limit", 50))
    return success(service.list_all_orders(status=status, limit=limit))


@bp.put("/orders/<order_id>/status")
@require_admin
def update_order_status(order_id: str):
    body = request.get_json(force=True)
    new_status = body.get("status")
    if not new_status:
        from app.core.errors import BadRequestError
        raise BadRequestError("Champ 'status' requis")
    updated = service.update_status(order_id, new_status)
    return success(updated, f"Statut mis à jour : {new_status}")
