import firebase_admin
from firebase_admin import credentials, firestore, auth, messaging

_firebase_app = None
_db = None


def init_firebase(app=None):
    """Initialise Firebase Admin SDK à partir de la config Flask."""
    global _firebase_app, _db

    if _firebase_app is not None:
        return _firebase_app

    service_account_path = (
        app.config["FIREBASE_SERVICE_ACCOUNT_PATH"]
        if app
        else "./serviceAccountKey.json"
    )

    cred = credentials.Certificate(service_account_path)
    _firebase_app = firebase_admin.initialize_app(cred)
    _db = firestore.client()

    return _firebase_app


def get_db() -> firestore.Client:
    """Retourne le client Firestore."""
    global _db
    if _db is None:
        _db = firestore.client()
    return _db


def verify_id_token(token: str) -> dict:
    """Vérifie un Firebase ID Token et retourne les claims."""
    return auth.verify_id_token(token)


def send_fcm(token: str, title: str, body: str, data: dict = None):
    """Envoie une notification FCM à un appareil."""
    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body),
        data=data or {},
        token=token,
    )
    return messaging.send(message)


def send_fcm_multicast(tokens: list[str], title: str, body: str, data: dict = None):
    """Envoie une notification FCM à plusieurs appareils."""
    message = messaging.MulticastMessage(
        notification=messaging.Notification(title=title, body=body),
        data=data or {},
        tokens=tokens,
    )
    return messaging.send_each_for_multicast(message)
