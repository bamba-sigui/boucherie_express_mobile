"""
Service de paiement — Adaptateur CinetPay.

CinetPay unifie Orange Money CI, MTN MoMo CI et Wave CI.
Doc officielle : https://docs.cinetpay.com

Pour changer d'agrégateur (ex: FedaPay), remplacer uniquement ce fichier.
"""
import uuid
import requests
from flask import current_app
from app.core.errors import BadRequestError

# Mapping méthodes Flutter → canaux CinetPay
CHANNEL_MAP = {
    "orange_money": "ORANGE_MONEY_CI",
    "mtn_momo":     "MTN_MONEY_CI",
    "wave":         "WAVE_MONEY_CI",
    "cash":         None,  # Pas de paiement en ligne
}


def initialize_payment(order_id: str, amount: float, method: str, customer: dict) -> dict:
    """
    Initie un paiement via CinetPay.

    Retourne:
        { "reference": str, "payment_url": str, "status": str }
    """
    channel = CHANNEL_MAP.get(method)
    if channel is None:
        return {"reference": None, "payment_url": None, "status": "cash"}

    api_key = current_app.config.get("CINETPAY_API_KEY", "")
    site_id = current_app.config.get("CINETPAY_SITE_ID", "")
    base_url = current_app.config.get("CINETPAY_BASE_URL", "https://api-checkout.cinetpay.com/v2")

    if not api_key or not site_id:
        # Mode développement : simuler un paiement
        return _mock_payment(order_id, amount)

    transaction_id = f"BE-{order_id[:8]}-{uuid.uuid4().hex[:6]}".upper()

    payload = {
        "apikey": api_key,
        "site_id": site_id,
        "transaction_id": transaction_id,
        "amount": int(amount),
        "currency": "XOF",
        "description": f"Boucherie Express - Commande {order_id[:8]}",
        "customer_name": customer.get("name", ""),
        "customer_email": customer.get("email", ""),
        "channels": channel,
        "notify_url": f"{_get_backend_url()}/api/v1/payments/webhook",
    }

    try:
        resp = requests.post(f"{base_url}/payment", json=payload, timeout=15)
        resp.raise_for_status()
        data = resp.json()

        if data.get("code") == "201":
            return {
                "reference": transaction_id,
                "payment_url": data["data"].get("payment_url", ""),
                "status": "pending",
            }
        raise BadRequestError(f"CinetPay : {data.get('message', 'Erreur inconnue')}")

    except requests.RequestException as e:
        raise BadRequestError(f"Erreur de connexion au service de paiement : {str(e)}")


def check_payment_status(reference: str) -> dict:
    """Vérifie le statut d'un paiement via CinetPay."""
    api_key = current_app.config.get("CINETPAY_API_KEY", "")
    site_id = current_app.config.get("CINETPAY_SITE_ID", "")
    base_url = current_app.config.get("CINETPAY_BASE_URL", "https://api-checkout.cinetpay.com/v2")

    if not api_key or not site_id:
        return {"reference": reference, "status": "pending"}

    payload = {
        "apikey": api_key,
        "site_id": site_id,
        "transaction_id": reference,
    }

    try:
        resp = requests.post(f"{base_url}/payment/check", json=payload, timeout=15)
        resp.raise_for_status()
        data = resp.json()

        code = data.get("data", {}).get("status", "")
        return {
            "reference": reference,
            "status": "paid" if code == "ACCEPTED" else "pending",
            "raw_status": code,
        }
    except requests.RequestException:
        return {"reference": reference, "status": "unknown"}


def _mock_payment(order_id: str, amount: float) -> dict:
    """Simule un paiement en développement (sans clés API)."""
    return {
        "reference": f"MOCK-{order_id[:8]}".upper(),
        "payment_url": f"http://localhost:5000/mock-payment?order={order_id}",
        "status": "pending",
    }


def _get_backend_url() -> str:
    try:
        return current_app.config.get("BACKEND_URL", "http://localhost:5000")
    except RuntimeError:
        return "http://localhost:5000"
