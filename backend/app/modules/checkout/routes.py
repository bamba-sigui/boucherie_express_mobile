from flask import Blueprint, request, g
from app.core.auth import require_auth
from app.core.errors import created
from . import service

bp = Blueprint("checkout", __name__, url_prefix="/api/v1")


@bp.post("/checkout")
@require_auth
def checkout():
    """
    Endpoint central de commande.

    Body:
    {
        "cart_items": [{"product_id": "...", "quantity": 2, "option": "Entier"}],
        "payment_method": "orange_money" | "mtn_momo" | "wave" | "cash",
        "address_id": "addr_xxx",   (optionnel → adresse par défaut)
        "note": "..."               (optionnel)
    }

    Retour:
    {
        "order_id", "payment_reference", "payment_url",
        "subtotal", "delivery_fee", "total", "status", "payment_status"
    }
    """
    payload = request.get_json(force=True)
    result = service.process_checkout(g.uid, payload)
    return created(result, "Commande créée avec succès")
