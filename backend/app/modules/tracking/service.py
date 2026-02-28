from datetime import datetime, timezone
from . import repository


def get_tracking(order_id: str) -> dict:
    return repository.get(order_id)


def update_tracking(order_id: str, data: dict) -> dict:
    """
    Mise à jour par l'admin : on peut passer un step_index pour le compléter,
    ou mettre à jour l'ETA et le livreur.
    """
    payload = {}

    if "step_index" in data:
        tracking = repository.get(order_id)
        steps = tracking.get("steps", [])
        idx = int(data["step_index"])
        now = datetime.now(timezone.utc).isoformat()

        for i, step in enumerate(steps):
            if i <= idx:
                step["completed"] = True
                if not step.get("completed_at"):
                    step["completed_at"] = now
            # On ne réinitialise pas les étapes déjà complétées
        payload["steps"] = steps

    if "eta" in data:
        payload["eta"] = data["eta"]

    if "courier" in data:
        payload["courier"] = data["courier"]

    return repository.update(order_id, payload)
