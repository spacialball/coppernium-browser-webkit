#!/bin/bash

echo "🌟 Instalando Coppernium Browser - Chromium Nativo 🌟"
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Paso 1: Actualizando sistema...${NC}"
sudo apt update

echo -e "${BLUE}Paso 2: Instalando dependencias de sistema...${NC}"
sudo apt install -y python3 python3-pip python3-tk

echo -e "${BLUE}Paso 3: Instalando CEF Python (Chromium Embedded Framework)...${NC}"
pip3 install --user cefpython3

echo -e "${BLUE}Paso 4: Instalando dependencias adicionales...${NC}"
sudo apt install -y libgtk-3-0 libglib2.0-0 libgconf-2-4 libnss3 libxss1 \
    libasound2 libxtst6 libxrandr2 libasound2 libpangocairo-1.0-0 \
    libatk1.0-0 libcairo1 libdrm2 libxss1 libgconf-2-4 libxcomposite1 \
    libxdamage1 libxrandr2 libgbm1 libxkbcommon0 libasound2

echo -e "${BLUE}Paso 5: Haciendo el navegador ejecutable...${NC}"
chmod +x main.py

echo -e "${BLUE}Paso 6: Creando launcher en el escritorio...${NC}"
cat > ~/Desktop/CopperniumBrowser.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Name=Coppernium Browser
Comment=Navegador web basado en Chromium nativo
Exec=python3 /home/sebastian/coppernium-chromium/main.py
Icon=web-browser
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupNotify=true
EOF

chmod +x ~/Desktop/CopperniumBrowser.desktop

echo -e "${GREEN}✅ ¡Instalación completada!${NC}"
echo ""
echo -e "${YELLOW}🚀 Para ejecutar el navegador:${NC}"
echo -e "${GREEN}   Opción 1: Doble click en el icono del escritorio${NC}"
echo -e "${GREEN}   Opción 2: cd /home/sebastian/coppernium-chromium && python3 main.py${NC}"
echo -e "${GREEN}   Opción 3: ./run.sh${NC}"
echo ""
echo -e "${BLUE}🌟 Características del Navegador Chromium Nativo:${NC}"
echo "   • Motor Chromium real (no Electron)"
echo "   • Máximo rendimiento y compatibilidad"
echo "   • Soporte completo para todas las páginas web"
echo "   • Developer Tools integrado"
echo "   • Marcadores y historial"
echo "   • Interfaz moderna"
echo ""
echo -e "${YELLOW}¿Quieres ejecutarlo ahora? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY]|[sS][iI])$ ]]; then
    echo -e "${GREEN}🚀 Iniciando Coppernium Browser...${NC}"
    cd /home/sebastian/coppernium-chromium
    python3 main.py
fi
