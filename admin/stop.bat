@echo off
title Boucherie Express - Arret Dashboard

echo Arret du dashboard (port 5173)...

:: Trouver le PID qui écoute sur le port 5173
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5173 "') do (
    set PID=%%a
)

if not defined PID (
    echo Aucun processus trouve sur le port 5173.
) else (
    taskkill /PID %PID% /F >nul 2>&1
    echo Processus %PID% arrete.
)

echo Dashboard arrete.
timeout /t 2 >nul
