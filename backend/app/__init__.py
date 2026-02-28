from flask import Flask
from flask_cors import CORS

from .config import get_config
from .core.firebase import init_firebase
from .core.errors import register_error_handlers


def create_app():
    app = Flask(__name__)
    cfg = get_config()
    app.config.from_object(cfg)

    # CORS
    CORS(app, resources={r"/api/*": {"origins": cfg.ALLOWED_ORIGINS}})

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
