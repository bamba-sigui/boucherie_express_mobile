import os


class Config:
    SECRET_KEY = os.getenv("FLASK_SECRET_KEY", "dev-secret-key")
    FIREBASE_SERVICE_ACCOUNT_PATH = os.getenv(
        "FIREBASE_SERVICE_ACCOUNT_PATH", "./serviceAccountKey.json"
    )
    FIREBASE_PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID", "boucherie-express")
    ALLOWED_ORIGINS = os.getenv(
        "ALLOWED_ORIGINS", "http://localhost:3000,http://localhost:5173"
    ).split(",")

    # Livraison
    DELIVERY_FEE = float(os.getenv("DELIVERY_FEE", 2000))
    FREE_DELIVERY_THRESHOLD = float(os.getenv("FREE_DELIVERY_THRESHOLD", 20000))

    # Paiement
    PAYMENT_GATEWAY = os.getenv("PAYMENT_GATEWAY", "cinetpay")
    CINETPAY_API_KEY = os.getenv("CINETPAY_API_KEY", "")
    CINETPAY_SITE_ID = os.getenv("CINETPAY_SITE_ID", "")
    CINETPAY_WEBHOOK_SECRET = os.getenv("CINETPAY_WEBHOOK_SECRET", "")
    CINETPAY_BASE_URL = os.getenv(
        "CINETPAY_BASE_URL", "https://api-checkout.cinetpay.com/v2"
    )


class DevelopmentConfig(Config):
    DEBUG = True


class ProductionConfig(Config):
    DEBUG = False


config_map = {
    "development": DevelopmentConfig,
    "production": ProductionConfig,
}


def get_config():
    env = os.getenv("FLASK_ENV", "development")
    return config_map.get(env, DevelopmentConfig)
