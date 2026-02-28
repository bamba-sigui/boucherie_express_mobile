from flask import jsonify


# ── Exceptions métier ─────────────────────────────────────────────────────────

class AppError(Exception):
    status_code = 500
    def __init__(self, message="Erreur interne"):
        self.message = message
        super().__init__(message)


class BadRequestError(AppError):
    status_code = 400


class UnauthorizedError(AppError):
    status_code = 401


class ForbiddenError(AppError):
    status_code = 403


class NotFoundError(AppError):
    status_code = 404


class ConflictError(AppError):
    status_code = 409


class UnprocessableError(AppError):
    status_code = 422


# ── Réponses helpers ──────────────────────────────────────────────────────────

def success(data=None, message="Succès", status=200):
    return jsonify({"success": True, "message": message, "data": data}), status


def created(data=None, message="Créé avec succès"):
    return success(data, message, 201)


def no_content():
    return "", 204


# ── Enregistrement des handlers Flask ─────────────────────────────────────────

def register_error_handlers(app):

    @app.errorhandler(AppError)
    def handle_app_error(e):
        return jsonify({"success": False, "error": e.message}), e.status_code

    @app.errorhandler(400)
    def bad_request(e):
        return jsonify({"success": False, "error": "Requête invalide"}), 400

    @app.errorhandler(401)
    def unauthorized(e):
        return jsonify({"success": False, "error": "Non authentifié"}), 401

    @app.errorhandler(403)
    def forbidden(e):
        return jsonify({"success": False, "error": "Accès interdit"}), 403

    @app.errorhandler(404)
    def not_found(e):
        return jsonify({"success": False, "error": "Ressource introuvable"}), 404

    @app.errorhandler(405)
    def method_not_allowed(e):
        return jsonify({"success": False, "error": "Méthode non autorisée"}), 405

    @app.errorhandler(500)
    def internal_error(e):
        return jsonify({"success": False, "error": "Erreur interne du serveur"}), 500
