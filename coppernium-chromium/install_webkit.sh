#!/bin/bash

# Script de instalación para Coppernium Browser WebKit
# Instala las dependencias necesarias para el navegador

echo "🌐 Coppernium Browser - Instalador de dependencias WebKit"
echo "=========================================================="
echo ""

# Función para detectar la distribución
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

DISTRO=$(detect_distro)

echo "📋 Distribución detectada: $DISTRO"
echo ""

install_dependencies() {
    case $DISTRO in
        ubuntu|debian|pop|linuxmint)
            echo "📦 Instalando dependencias para Ubuntu/Debian..."
            sudo apt update
            sudo apt install -y \
                python3 \
                python3-pip \
                python3-gi \
                gir1.2-gtk-3.0 \
                gir1.2-webkit2-4.0 \
                libwebkit2gtk-4.0-dev \
                libgirepository1.0-dev
            ;;
        
        fedora|centos|rhel)
            echo "📦 Instalando dependencias para Fedora/CentOS/RHEL..."
            sudo dnf install -y \
                python3 \
                python3-pip \
                python3-gobject \
                gtk3-devel \
                webkit2gtk3-devel \
                gobject-introspection-devel
            ;;
        
        arch|manjaro)
            echo "📦 Instalando dependencias para Arch Linux..."
            sudo pacman -S --noconfirm \
                python \
                python-pip \
                python-gobject \
                gtk3 \
                webkit2gtk \
                gobject-introspection
            ;;
        
        opensuse*)
            echo "📦 Instalando dependencias para openSUSE..."
            sudo zypper install -y \
                python3 \
                python3-pip \
                python3-gobject \
                gtk3-devel \
                webkit2gtk3-devel \
                gobject-introspection-devel
            ;;
        
        *)
            echo "❌ Distribución no soportada automáticamente: $DISTRO"
            echo "Por favor, instala manualmente las siguientes dependencias:"
            echo "- Python 3"
            echo "- PyGObject (python3-gi o python3-gobject)"
            echo "- GTK 3 development libraries"
            echo "- WebKit2GTK development libraries"
            echo "- GObject Introspection"
            return 1
            ;;
    esac
}

echo "🚀 Iniciando instalación..."
echo ""

if install_dependencies; then
    echo ""
    echo "✅ Dependencias instaladas correctamente!"
    echo ""
    echo "📝 Para ejecutar el navegador:"
    echo "   python3 browser_simple.py"
    echo ""
    echo "📄 O haz el archivo ejecutable:"
    echo "   chmod +x browser_simple.py"
    echo "   ./browser_simple.py"
    echo ""
    
    # Hacer el navegador ejecutable
    if [ -f "browser_simple.py" ]; then
        chmod +x browser_simple.py
        echo "✓ browser_simple.py es ahora ejecutable"
    fi
    
    echo "🎉 ¡Instalación completada!"
    echo ""
    echo "Características del navegador:"
    echo "• Navegación web completa (basada en WebKit/Blink)"
    echo "• Barra de direcciones inteligente"
    echo "• Marcadores persistentes"
    echo "• Historial de navegación"
    echo "• Botones de navegación (atrás, adelante, recargar)"
    echo "• Búsqueda integrada con Google"
    echo "• Compatible con JavaScript, WebGL, y tecnologías modernas"
    echo "• Interfaz nativa de GTK"
    
else
    echo ""
    echo "❌ Error durante la instalación"
    echo "Verifica tu conexión a internet y permisos de administrador"
    exit 1
fi
