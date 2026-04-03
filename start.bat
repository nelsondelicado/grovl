@echo off
:: VinylVault — servidor local (Windows)
:: Duplo-clique neste ficheiro para iniciar

set PORT=8082
set DIR=%~dp0

echo.
echo   🎵  VinylVault
echo   -----------------------------------------
echo   URL local:  http://localhost:%PORT%
echo   Pasta:      %DIR%
echo   Para parar: fecha esta janela
echo   -----------------------------------------
echo.

:: Abre o Chrome/Edge após 1 segundo
start "" /b cmd /c "timeout /t 1 >nul && start http://localhost:%PORT%"

:: Inicia o servidor Python
cd /d "%DIR%"
python -m http.server %PORT%

pause
