@echo off
title Boucherie Express - Backend
cd /d "%~dp0"

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

:: Vérifier que boucherie-express-firebase-adminsdk-fbsvc-6db385126f.json existe
if not exist "boucherie-express-firebase-adminsdk-fbsvc-6db385126f.json" (
    echo ERREUR : boucherie-express-firebase-adminsdk-fbsvc-6db385126f.json introuvable.
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
