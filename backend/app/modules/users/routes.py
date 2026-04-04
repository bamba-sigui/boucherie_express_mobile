from flask import Blueprint, request, g
from app.core.auth import require_auth, require_admin
from app.core.errors import success
from . import service

bp = Blueprint("users", __name__, url_prefix="/api/v1")


@bp.get("/auth/check-phone")
def check_phone():
    """Vérifie si un numéro de téléphone est déjà enregistré (sans authentification)."""
    phone = request.args.get("phone", "").strip()
    if not phone:
        return success({"exists": False})
    return success({"exists": repository.exists_by_phone(phone)})


@bp.get("/profile")
@require_auth
def get_profile():
    return success(service.get_profile(g.uid))


@bp.put("/profile")
@require_auth
def update_profile():
    data = request.get_json(force=True)
    return success(service.update_profile(g.uid, data), "Profil mis à jour")


@bp.put("/profile/fcm-token")
@require_auth
def update_fcm_token():
    body = request.get_json(force=True)
    token = body.get("fcm_token", "")
    service.update_fcm_token(g.uid, token)
    return success(None, "Token FCM mis à jour")


# ── Admin ────────────────────────────────────────────────────────────────────

@bp.get("/users")
@require_admin
def list_users():
    limit = int(request.args.get("limit", 50))
    return success(service.list_users(limit=limit))


@bp.get("/users/<uid>")
@require_admin
def get_user(uid: str):
    return success(service.get_user(uid))
