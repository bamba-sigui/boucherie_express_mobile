from functools import wraps
from flask import request, g, current_app
from firebase_admin import auth as firebase_auth

from .firebase import get_db, verify_id_token
from .errors import UnauthorizedError, ForbiddenError


def _extract_token() -> str:
    """Extrait le Bearer token du header Authorization."""
    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        raise UnauthorizedError("Token manquant ou format invalide")
    return auth_header.split("Bearer ", 1)[1].strip()


def _load_user_context(uid: str, decoded: dict):
    """Charge uid, email et role depuis Firestore dans g.
    Crée le document Firestore si c'est la première connexion."""
    g.uid = uid

    db = get_db()
    ref = db.collection("users").document(uid)
    user_doc = ref.get()

    if user_doc.exists:
        data = user_doc.to_dict()
        g.email = data.get("email", "")
        g.role = data.get("role", "user")
        g.fcm_token = data.get("fcm_token", "")
    else:
        # Première connexion : crée le document avec les infos Firebase
        from google.cloud.firestore_v1 import SERVER_TIMESTAMP
        new_user = {
            "uid": uid,
            "email": decoded.get("email", ""),
            "phone": decoded.get("phone_number", ""),
            "name": decoded.get("name", ""),
            "role": "user",
            "fcm_token": "",
            "created_at": SERVER_TIMESTAMP,
            "updated_at": SERVER_TIMESTAMP,
        }
        ref.set(new_user)
        g.email = new_user["email"]
        g.role = "user"
        g.fcm_token = ""


def require_auth(f):
    """Décorateur : vérifie le Firebase ID Token et injecte g.uid, g.email, g.role."""
    @wraps(f)
    def decorated(*args, **kwargs):
        try:
            token = _extract_token()
            decoded = verify_id_token(token)
            _load_user_context(decoded["uid"], decoded)
        except UnauthorizedError:
            raise
        except firebase_auth.ExpiredIdTokenError:
            raise UnauthorizedError("Token expiré")
        except firebase_auth.InvalidIdTokenError:
            raise UnauthorizedError("Token invalide")
        except Exception as e:
            raise UnauthorizedError(f"Erreur d'authentification : {str(e)}")
        return f(*args, **kwargs)
    return decorated


def require_admin(f):
    """Décorateur : requiert auth + rôle admin."""
    @wraps(f)
    @require_auth
    def decorated(*args, **kwargs):
        if getattr(g, "role", "user") != "admin":
            raise ForbiddenError("Accès réservé aux administrateurs")
        return f(*args, **kwargs)
    return decorated
