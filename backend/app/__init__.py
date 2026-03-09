from flask import Flask, request as flask_request
from flask_cors import CORS

from .config import get_config
from .core.firebase import init_firebase
from .core.errors import register_error_handlers


def create_app():
    app = Flask(__name__)
    cfg = get_config()
    app.config.from_object(cfg)

    # CORS — couvre aussi les réponses d'erreur
    CORS(app, resources={r"/api/*": {"origins": cfg.ALLOWED_ORIGINS}})

    @app.after_request
    def add_cors_headers(response):
        origin = flask_request.headers.get("Origin", "")
        if origin in cfg.ALLOWED_ORIGINS:
            response.headers["Access-Control-Allow-Origin"] = origin
            response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
            response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS, PATCH"
        return response

    # Firebase Admin SDK
    init_firebase(app)

    # Error handlers
    register_error_handlers(app)

    # Blueprints
    from .api import register_blueprints
    register_blueprints(app)

    @app.get("/health")
    def health():
        return {"status": "ok", "service": "boucherie-express-api"}

    return app
