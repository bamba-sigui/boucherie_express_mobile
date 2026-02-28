@echo off
title Boucherie Express - Arret Backend

echo Arret du backend (port 5000)...

:: Trouver le PID qui écoute sur le port 5000
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5000 "') do (
    set PID=%%a
)

if not defined PID (
    echo Aucun processus trouve sur le port 5000.
) else (
    taskkill /PID %PID% /F >nul 2>&1
    echo Processus %PID% arrete.
)

echo Backend arrete.
timeout /t 2 >nul
