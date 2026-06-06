@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

set "VENV_DIR=.venv"
set "VENV_PYTHON=%VENV_DIR%\Scripts\python.exe"
set "VENV_ACTIVATE=%VENV_DIR%\Scripts\activate.bat"
set "UI_DIR=helper_ui"
set "REQ_FILE=%SCRIPT_DIR%requirements.txt"

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

python --version

echo [INFO] Installiere Python-Pakete...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo [ERROR] pip konnte nicht aktualisiert werden.
    pause
    exit /b 1
)

if exist "%REQ_FILE%" (
    python -m pip install -r "%REQ_FILE%"
    if errorlevel 1 (
        echo [ERROR] Installation der Python-Abhängigkeiten aus requirements.txt fehlgeschlagen.
        pause
        exit /b 1
    )
) else (
    echo [WARN] Keine requirements.txt gefunden. Fahre mit Direktinstallation der Kernabhängigkeiten fort.
)

python -c "import sys, importlib.util; sys.exit(0 if importlib.util.find_spec('ultralytics') else 1)"
if errorlevel 1 (
    echo [INFO] Installiere YOLO (ultralytics)...
    python -m pip install ultralytics
    if errorlevel 1 (
        echo [ERROR] Installation von ultralytics fehlgeschlagen.
        pause
        exit /b 1
    )
)

echo [INFO] Installiere PyTorch (CUDA 12.8)...
python -c "import sys, importlib.util; sys.exit(0 if importlib.util.find_spec('torch') else 1)"
if errorlevel 1 (
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
    if errorlevel 1 (
        echo [WARN] CUDA 12.8 PyTorch-Installation fehlgeschlagen. Fallback auf Standard-PyTorch (ohne CUDA-Pin)...
        python -m pip install torch torchvision torchaudio
        if errorlevel 1 (
            echo [ERROR] PyTorch konnte nicht installiert werden.
            pause
            exit /b 1
        )
    )
) else (
    echo [INFO] PyTorch ist bereits installiert.
)

python -c "import sys, importlib.util; sys.exit(0 if importlib.util.find_spec('torch') else 1)"
if errorlevel 1 (
    echo [ERROR] torch ist nach dem Installversuch nicht verfügbar.
    pause
    exit /b 1
)

python -c "import torch; print('torch_cuda', torch.cuda.is_available())" >nul 2>&1
if errorlevel 1 (
    echo [WARN] torch konnte nicht ausgeführt werden oder CUDA-Unterstützung nicht geprüft werden.
) else (
    python -c "import torch; print('CUDA available:', torch.cuda.is_available())"
)

echo [INFO] Prüfe TensorRT (optional)...
python -c "import sys, importlib.util; sys.exit(0 if importlib.util.find_spec('tensorrt') else 1)"
if errorlevel 1 (
    python -m pip install tensorrt==10.13.0.35
    if errorlevel 1 (
        echo [WARN] TensorRT 10.13.0.35 konnte nicht installiert werden. Versuche kompatible Version...
        python -m pip install tensorrt
        if errorlevel 1 (
            echo [WARN] TensorRT konnte nicht installiert werden (optional, kann manuell nachgerüstet werden).
        )
    )
) else (
    echo [INFO] TensorRT ist bereits installiert.
)

where npm >nul 2>&1
if errorlevel 1 (
    echo [ERROR] npm wurde nicht gefunden. Bitte installiere Node.js (LTS), dann erneut starten.
    pause
    exit /b 1
)

echo [INFO] Installiere Helper-UI Dependencies...
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
echo [INFO] Enthalten: Python 3.12 (empfohlen), PyTorch, Ultralytics, TensorRT 10.13.0.35 (Fallback falls nötig), CUDA 12.8 (wenn unterstützt)
echo [INFO] Jetzt kannst du starten:
echo   - run_ai.bat
echo   - run_helper.bat
pause
exit /b 0
