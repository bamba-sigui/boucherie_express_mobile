"""
Script de seed pour peupler Firestore avec les données mock du frontend.

Usage:
    python seed.py            # Ajoute les données (écrase si même ID)
    python seed.py --clean    # Vide les collections avant de seeder
"""

import argparse
import firebase_admin
from firebase_admin import credentials, firestore, auth


def init_firebase():
    """Initialise Firebase Admin SDK."""
    if not firebase_admin._apps:
        cred = credentials.Certificate("./boucherie-express-firebase-adminsdk-fbsvc-6db385126f.json")
        firebase_admin.initialize_app(cred)
    return firestore.client()


def clean_collection(db, collection_name):
    """Supprime tous les documents d'une collection."""
    docs = db.collection(collection_name).stream()
    count = 0
    for doc in docs:
        doc.reference.delete()
        count += 1
    print(f"  Supprimé {count} documents de '{collection_name}'")


def seed_categories(db):
    """Crée les 4 catégories de viande."""
    categories = [
        {"name": "Poulet", "icon": "🐔", "order": 1},
        {"name": "Poisson", "icon": "🐟", "order": 2},
        {"name": "Bœuf", "icon": "🐄", "order": 3},
        {"name": "Mouton", "icon": "🐑", "order": 4},
    ]

    for cat in categories:
        doc_id = cat["name"].lower().replace("œ", "oe")
        db.collection("categories").document(doc_id).set(cat)
        print(f"  + Catégorie: {cat['name']} (id={doc_id})")

    return ["poulet", "poisson", "boeuf", "mouton"]


def seed_products(db):
    """Crée les 8 produits mock du frontend."""
    products = [
        {
            "name": "Poulet de Chair",
            "description": "Poulet fermier élevé en plein air, nourri aux grains naturels. Chair tendre et savoureuse.",
            "price": 3500,
            "category_id": "poulet",
            "images": [
                "https://images.unsplash.com/photo-1587593810167-a84920ea0781?w=400"
            ],
            "stock": 25,
            "is_active": True,
            "preparationOptions": ["Entier", "Découpé", "Désossé"],
            "farmName": "Ferme de Mbankomo",
            "unit": "kg",
            "isBio": True,
            "isFresh": True,
        },
        {
            "name": "Cuisses de Poulet",
            "description": "Cuisses de poulet fermier, idéales pour le braisé ou le grill.",
            "price": 2500,
            "category_id": "poulet",
            "images": [
                "https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400"
            ],
            "stock": 40,
            "is_active": True,
            "preparationOptions": ["Nature", "Marinées", "Épicées"],
            "farmName": "Ferme de Mbankomo",
            "unit": "kg",
            "isBio": False,
            "isFresh": True,
        },
        {
            "name": "Filet de Bœuf",
            "description": "Filet de bœuf tendre et juteux, parfait pour les grillades.",
            "price": 6500,
            "category_id": "boeuf",
            "images": [
                "https://images.unsplash.com/photo-1603048297172-c92544798d5a?w=400"
            ],
            "stock": 15,
            "is_active": True,
            "preparationOptions": ["Tranché", "Entier", "Haché"],
            "farmName": "Ranch du Noun",
            "unit": "kg",
            "isBio": False,
            "isFresh": True,
        },
        {
            "name": "Entrecôte",
            "description": "Entrecôte de bœuf persillée, idéale pour une cuisson au grill.",
            "price": 5500,
            "category_id": "boeuf",
            "images": [
                "https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=400"
            ],
            "stock": 20,
            "is_active": True,
            "preparationOptions": ["Nature", "Marinée", "Épicée"],
            "farmName": "Ranch du Noun",
            "unit": "kg",
            "isBio": True,
            "isFresh": True,
        },
        {
            "name": "Carpe",
            "description": "Carpe fraîche du fleuve Sanaga, pêche artisanale.",
            "price": 2000,
            "category_id": "poisson",
            "images": [
                "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400"
            ],
            "stock": 30,
            "is_active": True,
            "preparationOptions": ["Entier", "En filets", "Écaillé"],
            "farmName": "Pêcherie de Douala",
            "unit": "kg",
            "isBio": False,
            "isFresh": True,
        },
        {
            "name": "Tilapia",
            "description": "Tilapia d'élevage, chair blanche et délicate.",
            "price": 1800,
            "category_id": "poisson",
            "images": [
                "https://images.unsplash.com/photo-1510130113-85b5395b00d4?w=400"
            ],
            "stock": 35,
            "is_active": True,
            "preparationOptions": ["Entier", "En filets", "Fumé"],
            "farmName": "Pêcherie de Douala",
            "unit": "kg",
            "isBio": False,
            "isFresh": True,
        },
        {
            "name": "Gigot d'Agneau",
            "description": "Gigot d'agneau tendre, élevé dans les prairies de l'Ouest.",
            "price": 7000,
            "category_id": "mouton",
            "images": [
                "https://images.unsplash.com/photo-1603360946369-dc9bb6258143?w=400"
            ],
            "stock": 10,
            "is_active": True,
            "preparationOptions": ["Entier", "Tranché", "Désossé"],
            "farmName": "Élevage de Bafoussam",
            "unit": "kg",
            "isBio": True,
            "isFresh": True,
        },
        {
            "name": "Côtelettes de Mouton",
            "description": "Côtelettes de mouton, parfaites pour le braisé traditionnel.",
            "price": 4500,
            "category_id": "mouton",
            "images": [
                "https://images.unsplash.com/photo-1602473812169-a08f8e155d06?w=400"
            ],
            "stock": 18,
            "is_active": True,
            "preparationOptions": ["Nature", "Marinées", "Épicées"],
            "farmName": "Élevage de Bafoussam",
            "unit": "kg",
            "isBio": False,
            "isFresh": True,
        },
    ]

    for product in products:
        ref = db.collection("products").document()
        ref.set(product)
        print(f"  + Produit: {product['name']} (id={ref.id})")


def seed_admin_user(db):
    """Crée un compte admin dans Firebase Auth + Firestore."""
    email = "admin@boucherie-express.ci"
    password = "admin123"

    # Créer (ou récupérer) l'utilisateur dans Firebase Auth
    try:
        user = auth.get_user_by_email(email)
        print(f"  Admin existe déjà dans Auth (uid={user.uid})")
    except auth.UserNotFoundError:
        user = auth.create_user(email=email, password=password)
        print(f"  + Admin créé dans Auth (uid={user.uid})")

    # Créer le document Firestore avec le rôle admin
    db.collection("users").document(user.uid).set({
        "email": email,
        "displayName": "Administrateur",
        "role": "admin",
    })
    print(f"  + Admin Firestore: {email} / {password}")


def seed_test_user(db):
    """Crée un utilisateur test avec des adresses."""
    user_id = "test_user_001"
    user_data = {
        "email": "test@boucherie-express.cm",
        "displayName": "Client Test",
        "phone": "+237 699 000 000",
        "role": "user",
        "fcmToken": None,
    }
    db.collection("users").document(user_id).set(user_data)
    print(f"  + Utilisateur: {user_data['displayName']} (id={user_id})")

    addresses = [
        {
            "label": "Maison",
            "street": "Rue de la Joie, Bastos",
            "city": "Yaoundé",
            "postalCode": "",
            "country": "Cameroun",
            "latitude": 3.8667,
            "longitude": 11.5167,
            "isDefault": True,
        },
        {
            "label": "Bureau",
            "street": "Boulevard du 20 Mai",
            "city": "Yaoundé",
            "postalCode": "",
            "country": "Cameroun",
            "latitude": 3.8480,
            "longitude": 11.5021,
            "isDefault": False,
        },
    ]

    for addr in addresses:
        ref = db.collection("users").document(user_id).collection("addresses").document()
        ref.set(addr)
        print(f"    + Adresse: {addr['label']}")


def main():
    parser = argparse.ArgumentParser(description="Seed Firestore pour Boucherie Express")
    parser.add_argument("--clean", action="store_true", help="Vider les collections avant le seed")
    args = parser.parse_args()

    print("Initialisation Firebase...")
    db = init_firebase()

    if args.clean:
        print("\nNettoyage des collections...")
        for col in ["categories", "products", "users"]:
            clean_collection(db, col)

    print("\nSeed des catégories...")
    seed_categories(db)

    print("\nSeed des produits...")
    seed_products(db)

    print("\nSeed de l'administrateur...")
    seed_admin_user(db)

    print("\nSeed de l'utilisateur test...")
    seed_test_user(db)

    print("\nSeed terminé avec succès !")


if __name__ == "__main__":
    main()
