@echo off
title Boucherie Express - Backend

:: Créer le venv si absent
if not exist "venv\" (
    echo Creation de l'environnement virtuel...
    python -m venv venv
)

:: Activer le venv
call venv\Scripts\activate

:: Installer / mettre à jour les dépendances
echo Installation des dependances...
pip install -r requirements.txt --quiet

:: Vérifier que .env existe
if not exist ".env" (
    echo ERREUR : fichier .env introuvable.
    echo Copie .env.example en .env et remplis les valeurs.
    pause
    exit /b 1
)

:: Vérifier que serviceAccountKey.json existe
if not exist "serviceAccountKey.json" (
    echo ERREUR : serviceAccountKey.json introuvable.
    echo Telecharge-le depuis Firebase Console ^> Project Settings ^> Service Accounts.
    pause
    exit /b 1
)

echo.
echo  Backend en cours de demarrage...
echo  URL : http://localhost:5000
echo  Health : http://localhost:5000/health
echo.

python run.py
pause
