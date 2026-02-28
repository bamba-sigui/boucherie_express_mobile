from flask import Blueprint, request
from app.core.auth import require_admin
from app.core.errors import success, created, no_content
from . import service

bp = Blueprint("products", __name__, url_prefix="/api/v1/products")


@bp.get("")
def list_products():
    category_id = request.args.get("category")
    query = request.args.get("q")
    page = int(request.args.get("page", 1))
    data = service.list_products(category_id=category_id, query=query, page=page)
    return success(data)


@bp.get("/<product_id>")
def get_product(product_id: str):
    data = service.get_product(product_id)
    return success(data)


@bp.post("")
@require_admin
def create_product():
    data = request.get_json(force=True)
    product = service.create_product(data)
    return created(product, "Produit créé")


@bp.put("/<product_id>")
@require_admin
def update_product(product_id: str):
    data = request.get_json(force=True)
    product = service.update_product(product_id, data)
    return success(product, "Produit mis à jour")


@bp.delete("/<product_id>")
@require_admin
def delete_product(product_id: str):
    service.delete_product(product_id)
    return no_content()


@bp.put("/<product_id>/stock")
@require_admin
def update_stock(product_id: str):
    body = request.get_json(force=True)
    stock = body.get("stock")
    if stock is None:
        from app.core.errors import BadRequestError
        raise BadRequestError("Champ 'stock' requis")
    product = service.update_stock(product_id, int(stock))
    return success(product, "Stock mis à jour")
