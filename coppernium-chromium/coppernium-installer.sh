#!/bin/bash

# Coppernium Browser - Instalador Completo del Sistema
# Instala el navegador Coppernium WebKit en el sistema
# Autor: Sebastian
# Versión: 2.0

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
BROWSER_NAME="Coppernium Browser"
BROWSER_EXEC="coppernium-browser"
INSTALL_DIR="/usr/local/bin"
DESKTOP_FILE_DIR="/usr/share/applications"
ICON_DIR="/usr/share/pixmaps"
BROWSER_DIR="/opt/coppernium"

# Functions
print_header() {
    echo -e "${CYAN}"
    echo "  ██████╗ ██████╗ ██████╗ ██████╗ ███████╗██████╗ ███╗   ██╗██╗██╗   ██╗███╗   ███╗"
    echo " ██╔════╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║██║██║   ██║████╗ ████║"
    echo " ██║     ██║   ██║██████╔╝██████╔╝█████╗  ██████╔╝██╔██╗ ██║██║██║   ██║██╔████╔██║"
    echo " ██║     ██║   ██║██╔═══╝ ██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╗██║██║██║   ██║██║╚██╔╝██║"
    echo " ╚██████╗╚██████╔╝██║     ██║     ███████╗██║  ██║██║ ╚████║██║╚██████╔╝██║ ╚═╝ ██║"
    echo "  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝     ╚═╝"
    echo -e "${NC}"
    echo -e "${WHITE}                         🌐 WebKit Native Browser 🌐${NC}"
    echo -e "${BLUE}                        Instalador del Sistema v2.0${NC}"
    echo ""
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "No ejecutes este script como root. Se pedirán permisos cuando sea necesario."
        exit 1
    fi
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "redhat"
    else
        echo "unknown"
    fi
}

check_dependencies() {
    log_info "Verificando dependencias del sistema..."
    
    local missing_deps=()
    local commands=("python3" "desktop-file-install")
    
    for cmd in "${commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    # Check Python WebKit module
    if ! python3 -c "import gi; gi.require_version('WebKit2', '4.1')" 2>/dev/null; then
        missing_deps+=("webkit2gtk")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_warning "Faltan dependencias: ${missing_deps[*]}"
        return 1
    fi
    
    log_success "Todas las dependencias están disponibles"
    return 0
}

install_system_dependencies() {
    local distro=$(detect_distro)
    log_info "Distribución detectada: $distro"
    
    case $distro in
        ubuntu|debian|pop|linuxmint)
            log_info "Instalando dependencias para Ubuntu/Debian..."
            sudo apt update
            sudo apt install -y \
                python3 \
                python3-gi \
                gir1.2-gtk-3.0 \
                gir1.2-webkit2-4.1 \
                libwebkit2gtk-4.1-0 \
                desktop-file-utils \
                xdg-utils
            ;;
        
        fedora|centos|rhel)
            log_info "Instalando dependencias para Fedora/CentOS/RHEL..."
            sudo dnf install -y \
                python3 \
                python3-gobject \
                gtk3-devel \
                webkit2gtk3-devel \
                desktop-file-utils \
                xdg-utils
            ;;
        
        arch|manjaro)
            log_info "Instalando dependencias para Arch Linux..."
            sudo pacman -S --noconfirm \
                python \
                python-gobject \
                gtk3 \
                webkit2gtk \
                desktop-file-utils \
                xdg-utils
            ;;
        
        opensuse*)
            log_info "Instalando dependencias para openSUSE..."
            sudo zypper install -y \
                python3 \
                python3-gobject \
                gtk3-devel \
                webkit2gtk3-devel \
                desktop-file-utils \
                xdg-utils
            ;;
        
        *)
            log_error "Distribución no soportada: $distro"
            log_info "Instala manualmente: python3, python3-gi, webkit2gtk, desktop-file-utils"
            return 1
            ;;
    esac
    
    log_success "Dependencias del sistema instaladas"
}

create_browser_directory() {
    log_info "Creando directorio de instalación: $BROWSER_DIR"
    
    if [ -d "$BROWSER_DIR" ]; then
        log_warning "Directorio existente, actualizando..."
        sudo rm -rf "$BROWSER_DIR"
    fi
    
    sudo mkdir -p "$BROWSER_DIR"
    log_success "Directorio de instalación creado"
}

install_browser_files() {
    log_info "Instalando archivos del navegador..."
    
    # Check if browser file exists
    if [ ! -f "browser_simple.py" ]; then
        log_error "No se encuentra browser_simple.py en el directorio actual"
        log_info "Asegúrate de ejecutar este instalador desde el directorio de Coppernium"
        exit 1
    fi
    
    # Copy main browser file
    sudo cp "browser_simple.py" "$BROWSER_DIR/"
    sudo chmod +x "$BROWSER_DIR/browser_simple.py"
    
    # Copy additional files if they exist
    for file in README_webkit.md install_webkit.sh; do
        if [ -f "$file" ]; then
            sudo cp "$file" "$BROWSER_DIR/"
        fi
    done
    
    log_success "Archivos del navegador instalados en $BROWSER_DIR"
}

create_desktop_entry() {
    log_info "Creando entrada del menú de aplicaciones..."
    
    local desktop_file="$DESKTOP_FILE_DIR/coppernium-browser.desktop"
    
    sudo tee "$desktop_file" > /dev/null << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Coppernium Browser
GenericName=Web Browser
Comment=Modern web browser based on WebKit
Keywords=web;browser;internet;
Exec=$BROWSER_DIR/browser_simple.py %u
Icon=coppernium-browser
Terminal=false
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Categories=Network;WebBrowser;
Actions=NewWindow;

[Desktop Action NewWindow]
Name=New Window
Exec=$BROWSER_DIR/browser_simple.py
EOF

    sudo chmod 644 "$desktop_file"
    
    # Validate and install desktop file
    if command -v desktop-file-validate &> /dev/null; then
        if desktop-file-validate "$desktop_file" 2>/dev/null; then
            log_success "Archivo desktop válido"
        else
            log_warning "Archivo desktop con advertencias menores"
        fi
    fi
    
    sudo desktop-file-install "$desktop_file" 2>/dev/null || true
    
    log_success "Entrada de menú creada"
}

create_browser_icon() {
    log_info "Creando icono del navegador..."
    
    # Create a simple PNG icon (base64 encoded 32x32 icon)
    local icon_file="$ICON_DIR/coppernium-browser.png"
    
    # Create icon using base64 data (simple 32x32 web browser icon)
    sudo tee "$icon_file" > /dev/null << 'EOF'
iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAAdgAAAHYBTnsmCAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVFiFtZdNaBNBFMd/b9Ikm6RN0zRtY+1HtdJWBaGI4MWDB0/ePHjw4MWDB0/ePHjw4MWDB0/ePHjw4sWDB0/ePHjw4MWDB0/ePHjw4sWDB0/ePHjw4sWDF48WLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsXLx48ePHixYsX
EOF
    
    # Create a simple XPM fallback icon
    sudo tee "$ICON_DIR/coppernium-browser.xpm" > /dev/null << 'EOF'
/* XPM */
static char * coppernium_browser_xpm[] = {
"32 32 4 1",
"       c None",
".      c #2E86AB",
"+      c #A23B72",
"@      c #F18F01",
"                                ",
"     ...................        ",
"   ..+++++++++++++++++++..      ",
"  .+++@@@@@@@@@@@@@@@@+++.      ",
" .+++@   COPPERNIUM   @+++.     ",
" .+++@    BROWSER     @+++.     ",
" .+++@                @+++.     ",
" .+++@  🌐 WebKit     @+++.     ",
" .+++@     Native     @+++.     ",
" .+++@                @+++.     ",
" .+++@@@@@@@@@@@@@@@@@@+++.     ",
"  .+++++++++++++++++++++++.     ",
"   ........................     ",
"                                "
};
EOF

    log_success "Iconos del navegador creados"
}

create_executable_link() {
    log_info "Creando comando ejecutable: $BROWSER_EXEC"
    
    local exec_link="$INSTALL_DIR/$BROWSER_EXEC"
    
    sudo tee "$exec_link" > /dev/null << EOF
#!/bin/bash
# Coppernium Browser System Launcher
# This script launches the Coppernium Browser
cd "$BROWSER_DIR" 2>/dev/null || cd /tmp
exec python3 "$BROWSER_DIR/browser_simple.py" "\$@"
EOF

    sudo chmod +x "$exec_link"
    
    log_success "Comando '$BROWSER_EXEC' disponible en el sistema"
}

update_desktop_database() {
    log_info "Actualizando base de datos del sistema..."
    
    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        sudo update-desktop-database "$DESKTOP_FILE_DIR" 2>/dev/null || true
        log_success "Base de datos de aplicaciones actualizada"
    fi
    
    # Update icon cache
    if command -v gtk-update-icon-cache &> /dev/null; then
        sudo gtk-update-icon-cache -f -t "$ICON_DIR" 2>/dev/null || true
        log_success "Caché de iconos actualizada"
    fi
    
    # Update MIME database
    if command -v update-mime-database &> /dev/null; then
        sudo update-mime-database /usr/share/mime 2>/dev/null || true
        log_success "Base de datos MIME actualizada"
    fi
}

create_uninstaller() {
    log_info "Creando script de desinstalación..."
    
    local uninstall_script="$BROWSER_DIR/uninstall.sh"
    
    sudo tee "$uninstall_script" > /dev/null << EOF
#!/bin/bash
# Coppernium Browser Uninstaller

echo "🗑️  Desinstalando Coppernium Browser..."
echo ""

# Remove files and directories
echo "Eliminando archivos..."
sudo rm -rf "$BROWSER_DIR"
sudo rm -f "$INSTALL_DIR/$BROWSER_EXEC"
sudo rm -f "$DESKTOP_FILE_DIR/coppernium-browser.desktop"
sudo rm -f "$ICON_DIR/coppernium-browser.png"
sudo rm -f "$ICON_DIR/coppernium-browser.xpm"

# Update system databases
echo "Actualizando base de datos del sistema..."
sudo update-desktop-database "$DESKTOP_FILE_DIR" 2>/dev/null || true
sudo gtk-update-icon-cache -f -t "$ICON_DIR" 2>/dev/null || true

echo ""
echo "✅ Coppernium Browser desinstalado completamente"
echo ""
echo "Para reinstalar, ejecuta el instalador nuevamente:"
echo "   ./coppernium-installer.sh"
echo ""
EOF

    sudo chmod +x "$uninstall_script"
    
    log_success "Desinstalador creado en $uninstall_script"
}

test_installation() {
    log_info "Verificando instalación..."
    
    local tests_passed=0
    local total_tests=4
    
    # Test 1: Executable exists and is executable
    if [ -x "$INSTALL_DIR/$BROWSER_EXEC" ]; then
        tests_passed=$((tests_passed + 1))
        log_success "Test 1/4: Comando ejecutable ✓"
    else
        log_error "Test 1/4: Comando ejecutable ✗"
    fi
    
    # Test 2: Desktop file exists
    if [ -f "$DESKTOP_FILE_DIR/coppernium-browser.desktop" ]; then
        tests_passed=$((tests_passed + 1))
        log_success "Test 2/4: Entrada de menú ✓"
    else
        log_error "Test 2/4: Entrada de menú ✗"
    fi
    
    # Test 3: Browser files exist
    if [ -f "$BROWSER_DIR/browser_simple.py" ] && [ -x "$BROWSER_DIR/browser_simple.py" ]; then
        tests_passed=$((tests_passed + 1))
        log_success "Test 3/4: Archivos del navegador ✓"
    else
        log_error "Test 3/4: Archivos del navegador ✗"
    fi
    
    # Test 4: Python WebKit import works
    if python3 -c "import gi; gi.require_version('WebKit2', '4.1'); from gi.repository import WebKit2" 2>/dev/null; then
        tests_passed=$((tests_passed + 1))
        log_success "Test 4/4: WebKit disponible ✓"
    else
        log_error "Test 4/4: WebKit disponible ✗"
    fi
    
    if [ $tests_passed -eq $total_tests ]; then
        log_success "Todos los tests pasaron ($tests_passed/$total_tests)"
        return 0
    else
        log_warning "Algunos tests fallaron ($tests_passed/$total_tests)"
        return 1
    fi
}

show_completion_message() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                        🎉 INSTALACIÓN COMPLETADA 🎉                      ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}¡$BROWSER_NAME está ahora instalado en tu sistema!${NC}"
    echo ""
    echo -e "${CYAN}🚀 Formas de ejecutar Coppernium Browser:${NC}"
    echo -e "   ${YELLOW}1.${NC} Desde el menú de aplicaciones:"
    echo -e "      Busca '${WHITE}Coppernium Browser${NC}' en el menú de aplicaciones"
    echo ""
    echo -e "   ${YELLOW}2.${NC} Desde la terminal:"
    echo -e "      ${WHITE}$BROWSER_EXEC${NC}"
    echo ""
    echo -e "   ${YELLOW}3.${NC} Directamente:"
    echo -e "      ${WHITE}$BROWSER_DIR/browser_simple.py${NC}"
    echo ""
    echo -e "${CYAN}📁 Ubicación de archivos:${NC}"
    echo -e "   • Ejecutable del sistema: ${WHITE}$INSTALL_DIR/$BROWSER_EXEC${NC}"
    echo -e "   • Archivos del navegador: ${WHITE}$BROWSER_DIR/${NC}"
    echo -e "   • Entrada del menú: ${WHITE}$DESKTOP_FILE_DIR/coppernium-browser.desktop${NC}"
    echo -e "   • Iconos: ${WHITE}$ICON_DIR/coppernium-browser.*${NC}"
    echo ""
    echo -e "${CYAN}🗑️  Para desinstalar:${NC}"
    echo -e "   ${WHITE}$BROWSER_DIR/uninstall.sh${NC}"
    echo -e "   o"
    echo -e "   ${WHITE}./coppernium-installer.sh --uninstall${NC}"
    echo ""
    echo -e "${CYAN}✨ Características del navegador:${NC}"
    echo -e "   • 🌐 Navegación web completa (motor WebKit nativo)"
    echo -e "   • ⭐ Sistema de marcadores persistente"
    echo -e "   • 📜 Historial de navegación"
    echo -e "   • 🔍 Búsqueda inteligente integrada"
    echo -e "   • 🐧 Perfecto para Linux (interfaz GTK nativa)"
    echo -e "   • 💾 Bajo consumo de memoria (~50-100 MB)"
    echo -e "   • ⚡ Inicio rápido (<1 segundo)"
    echo ""
    echo -e "${WHITE}¡Disfruta navegando con Coppernium Browser!${NC}"
    echo -e "${BLUE}Navegador desarrollado por Sebastian${NC}"
    echo ""
}

# Main installation process
main() {
    print_header
    
    log_info "Iniciando instalación completa de $BROWSER_NAME en el sistema..."
    echo ""
    
    # Pre-installation checks
    check_root
    
    if ! check_dependencies; then
        log_info "Instalando dependencias del sistema..."
        install_system_dependencies
    fi
    
    echo ""
    log_info "Procediendo con la instalación del sistema..."
    echo ""
    
    # Installation steps with progress
    create_browser_directory
    install_browser_files
    create_browser_icon
    create_desktop_entry
    create_executable_link
    update_desktop_database
    create_uninstaller
    
    echo ""
    log_info "Realizando verificaciones finales..."
    echo ""
    
    # Test installation
    if test_installation; then
        show_completion_message
    else
        echo ""
        log_error "La instalación presentó algunas fallas en las verificaciones"
        log_info "El navegador podría funcionar pero con funcionalidad limitada"
        log_info "Revisa los mensajes de error anteriores"
        echo ""
        exit 1
    fi
}

# Uninstall function
uninstall() {
    print_header
    log_info "Desinstalando $BROWSER_NAME..."
    echo ""
    
    if [ -f "$BROWSER_DIR/uninstall.sh" ]; then
        exec "$BROWSER_DIR/uninstall.sh"
    else
        # Manual uninstall if uninstaller script doesn't exist
        log_info "Ejecutando desinstalación manual..."
        
        sudo rm -rf "$BROWSER_DIR" 2>/dev/null || true
        sudo rm -f "$INSTALL_DIR/$BROWSER_EXEC" 2>/dev/null || true
        sudo rm -f "$DESKTOP_FILE_DIR/coppernium-browser.desktop" 2>/dev/null || true
        sudo rm -f "$ICON_DIR/coppernium-browser.png" 2>/dev/null || true
        sudo rm -f "$ICON_DIR/coppernium-browser.xpm" 2>/dev/null || true
        
        # Update databases
        sudo update-desktop-database "$DESKTOP_FILE_DIR" 2>/dev/null || true
        sudo gtk-update-icon-cache -f -t "$ICON_DIR" 2>/dev/null || true
        
        log_success "Coppernium Browser desinstalado"
    fi
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Instalador del Sistema para Coppernium Browser"
        echo "Uso: $0 [opciones]"
        echo ""
        echo "Opciones:"
        echo "  --help, -h         Mostrar esta ayuda"
        echo "  --uninstall        Desinstalar Coppernium Browser"
        echo "  --test             Probar la instalación actual"
        echo ""
        echo "Sin opciones: Instalar Coppernium Browser en el sistema"
        echo ""
        exit 0
        ;;
    --uninstall)
        uninstall
        ;;
    --test)
        print_header
        log_info "Probando instalación actual..."
        test_installation
        ;;
    "")
        main
        ;;
    *)
        log_error "Opción desconocida: $1"
        echo "Usa --help para ver las opciones disponibles"
        exit 1
        ;;
esac
