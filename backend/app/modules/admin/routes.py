from datetime import datetime, timezone
from flask import Blueprint
from app.core.auth import require_admin
from app.core.errors import success
from app.core.firebase import get_db

bp = Blueprint("admin", __name__, url_prefix="/api/v1")


@bp.get("/admin/stats")
@require_admin
def get_stats():
    db = get_db()

    # Toutes les commandes
    all_orders = list(db.collection("orders").stream())
    total_orders = len(all_orders)

    # Commandes du jour
    today = datetime.now(timezone.utc).date()
    today_orders = 0
    total_revenue = 0.0
    recent_raw = []

    for doc in all_orders:
        o = doc.to_dict()
        o["id"] = doc.id

        # Chiffre d'affaires (commandes payées ou livrées)
        if o.get("status") in ("paid", "preparing", "shipping", "delivered"):
            total_revenue += float(o.get("total_amount", 0))

        # Commandes du jour
        created = o.get("created_at")
        if created:
            try:
                created_date = created.astimezone(timezone.utc).date()
                if created_date == today:
                    today_orders += 1
            except Exception:
                pass

        recent_raw.append(o)

    # 5 commandes récentes (tri par created_at desc)
    recent_raw.sort(key=lambda x: x.get("created_at") or datetime.min.replace(tzinfo=timezone.utc), reverse=True)
    recent_orders = [
        {
            "id": o["id"],
            "user_email": o.get("user_email", ""),
            "total_amount": o.get("total_amount", 0),
            "status": o.get("status", ""),
        }
        for o in recent_raw[:5]
    ]

    # Produits en rupture de stock
    out_of_stock = db.collection("products").where("stock", "<=", 0).where("is_active", "==", True).stream()
    out_of_stock_count = sum(1 for _ in out_of_stock)

    return success({
        "total_orders": total_orders,
        "today_orders": today_orders,
        "total_revenue": total_revenue,
        "out_of_stock": out_of_stock_count,
        "recent_orders": recent_orders,
    })


@bp.get("/admin/users")
@require_admin
def list_users():
    db = get_db()
    docs = db.collection("users").limit(100).stream()
    users = []
    for doc in docs:
        u = doc.to_dict()
        u["id"] = doc.id
        u.pop("fcm_token", None)
        users.append(u)
    return success(users)
