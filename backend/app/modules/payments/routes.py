import hashlib
import hmac
from flask import Blueprint, request, g, current_app
from app.core.auth import require_auth
from app.core.errors import success, BadRequestError
from . import service

bp = Blueprint("payments", __name__, url_prefix="/api/v1/payments")


@bp.post("/initialize")
@require_auth
def initialize():
    """Initier un paiement mobile money via l'agrégateur."""
    body = request.get_json(force=True)
    order_id = body.get("order_id")
    if not order_id:
        raise BadRequestError("order_id requis")

    result = service.initialize(g.uid, order_id)
    return success(result)


@bp.get("/<reference>/status")
@require_auth
def payment_status(reference: str):
    """Vérifier le statut d'un paiement."""
    result = service.check_status(reference)
    return success(result)


@bp.post("/webhook")
def webhook():
    """
    Callback de l'agrégateur de paiement — endpoint PUBLIC.
    Vérifie la signature HMAC avant tout traitement.
    """
    # Vérifier la signature
    secret = current_app.config.get("CINETPAY_WEBHOOK_SECRET", "")
    signature = request.headers.get("X-Cinetpay-Signature", "")
    raw_body = request.get_data()

    if secret and not _verify_signature(raw_body, signature, secret):
        return {"success": False, "error": "Signature invalide"}, 401

    payload = request.get_json(force=True)
    service.handle_webhook(payload)
    return {"success": True}, 200


def _verify_signature(body: bytes, signature: str, secret: str) -> bool:
    """Vérifie la signature HMAC-SHA256 de CinetPay."""
    expected = hmac.new(
        secret.encode(), body, hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(expected, signature)
