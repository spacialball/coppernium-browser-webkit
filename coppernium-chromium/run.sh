#!/bin/bash

echo "🚀 Iniciando Coppernium Browser - Chromium Nativo"
echo "=============================================="

# Cambiar al directorio del navegador
cd "$(dirname "$0")"

# Verificar que Python3 esté instalado
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 no está instalado. Ejecuta ./install.sh primero"
    exit 1
fi

# Verificar que CEF esté instalado
python3 -c "import cefpython3" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ CEF Python no está instalado. Ejecuta ./install.sh primero"
    exit 1
fi

# Ejecutar el navegador
echo "✅ Iniciando navegador..."
python3 main.py
