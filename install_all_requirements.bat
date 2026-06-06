@echo off
setlocal
cd /d "%~dp0"

set "VENV_DIR=.venv"
set "VENV_PYTHON=%VENV_DIR%\Scripts\python.exe"
set "VENV_ACTIVATE=%VENV_DIR%\Scripts\activate.bat"
set "UI_DIR=helper_ui"

if not exist "%VENV_PYTHON%" (
    echo [INFO] Erstelle virtuelle Python-Umgebung...
    if exist "%SystemRoot%\py.exe" (
        py -3 -m venv "%VENV_DIR%"
    ) else (
        python -m venv "%VENV_DIR%"
    )
    if errorlevel 1 (
        echo [ERROR] Python-Virtualumgebung konnte nicht erstellt werden.
        echo Bitte installiere Python 3.12 und starte das Script neu.
        pause
        exit /b 1
    )
)

call "%VENV_ACTIVATE%"
if errorlevel 1 (
    echo [ERROR] Virtual Environment konnte nicht aktiviert werden.
    pause
    exit /b 1
)

echo [INFO] Installiere Python-Abhängigkeiten...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo [ERROR] pip konnte nicht aktualisiert werden.
    pause
    exit /b 1
)

python -m pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Installation der Python-Abhängigkeiten fehlgeschlagen.
    pause
    exit /b 1
)

where npm >nul 2>&1
if errorlevel 1 (
    echo [ERROR] npm wurde nicht gefunden. Bitte installiere Node.js (LTS), dann erneut starten.
    pause
    exit /b 1
)

echo [INFO] Installiere Helper-UI Dependencies ...
pushd "%UI_DIR%"
if errorlevel 1 (
    popd
    echo [ERROR] Ordner %UI_DIR% nicht gefunden.
    pause
    exit /b 1
)

call npm install
if errorlevel 1 (
    popd
    echo [ERROR] npm install ist fehlgeschlagen.
    pause
    exit /b 1
)

call npm run build
if errorlevel 1 (
    popd
    echo [ERROR] npm run build ist fehlgeschlagen.
    pause
    exit /b 1
)

popd
echo [INFO] Alle Requirements wurden erfolgreich installiert.
echo [INFO] Jetzt kannst du einfach starten:
echo   - run_ai.bat
echo   - run_helper.bat
pause
exit /b 0
