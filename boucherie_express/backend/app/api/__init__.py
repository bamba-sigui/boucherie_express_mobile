from flask import Flask


def register_blueprints(app: Flask):
    from app.modules.products.routes import bp as products_bp
    from app.modules.categories.routes import bp as categories_bp
    from app.modules.favorites.routes import bp as favorites_bp
    from app.modules.users.routes import bp as users_bp
    from app.modules.addresses.routes import bp as addresses_bp
    from app.modules.orders.routes import bp as orders_bp
    from app.modules.tracking.routes import bp as tracking_bp
    from app.modules.checkout.routes import bp as checkout_bp
    from app.modules.payments.routes import bp as payments_bp

    app.register_blueprint(products_bp)
    app.register_blueprint(categories_bp)
    app.register_blueprint(favorites_bp)
    app.register_blueprint(users_bp)
    app.register_blueprint(addresses_bp)
    app.register_blueprint(orders_bp)
    app.register_blueprint(tracking_bp)
    app.register_blueprint(checkout_bp)
    app.register_blueprint(payments_bp)
