@echo off
title Boucherie Express - Admin Dashboard

:: Installer les dépendances si absent
if not exist "node_modules\" (
    echo Installation des dependances npm...
    npm install
)

:: Vérifier que .env existe
if not exist ".env" (
    echo ERREUR : fichier .env introuvable.
    echo Copie .env.example en .env et remplis les cles Firebase.
    pause
    exit /b 1
)

echo.
echo  Dashboard en cours de demarrage...
echo  URL : http://localhost:5173
echo.

npm run dev
pause
