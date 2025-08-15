# 🌐 Coppernium Browser - WebKit Native

**Navegador web moderno basado en WebKit para Linux**

Versión simplificada del navegador Coppernium que utiliza WebKitGTK (el mismo motor de renderizado que Safari y otros navegadores modernos) en lugar de Electron. Esto proporciona una experiencia nativa de Linux con mejor rendimiento y menor uso de recursos.

![Coppernium Browser](https://img.shields.io/badge/Coppernium-Browser-blue)
![WebKit](https://img.shields.io/badge/Engine-WebKit-green)
![Python](https://img.shields.io/badge/Python-3.6%2B-blue)
![GTK](https://img.shields.io/badge/GUI-GTK3-red)

## ✨ Características

### 🚀 Navegación Completa
- **Motor WebKit moderno**: Basado en el mismo motor que Safari y Chrome (Blink/WebKit)
- **JavaScript completo**: Soporte completo para aplicaciones web modernas
- **WebGL y Canvas**: Gráficos 3D y animaciones avanzadas
- **HTML5 Media**: Reproducción de video y audio
- **Local Storage**: Almacenamiento local para aplicaciones web

### 🎯 Interfaz Intuitiva
- **Barra de direcciones inteligente**: Autodetecta URLs y consultas de búsqueda
- **Navegación familiar**: Botones atrás, adelante, recargar, y home
- **Búsqueda integrada**: Búsqueda directa en Google desde la barra de direcciones
- **Interfaz nativa**: Utiliza GTK3 para una experiencia nativa de Linux

### 📚 Gestión de Contenido
- **Marcadores persistentes**: Guarda y organiza tus sitios favoritos
- **Historial de navegación**: Acceso rápido a páginas visitadas recientemente
- **Gestión de ventanas**: Interfaz limpia y organizada

### 🔧 Configuración Avanzada
- **User-Agent personalizado**: Se identifica como Coppernium Browser
- **Configuraciones de seguridad**: Control sobre JavaScript, almacenamiento, y más
- **Compatibilidad web**: Máxima compatibilidad con sitios web modernos

## 🛠️ Instalación Rápida

### Instalación Automática (Recomendada)

```bash
# Hacer el script ejecutable
chmod +x install_webkit.sh

# Ejecutar instalación
./install_webkit.sh
```

El script instalará automáticamente todas las dependencias necesarias según tu distribución de Linux.

### Instalación Manual

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y python3 python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0
```

#### Fedora
```bash
sudo dnf install -y python3 python3-gobject gtk3-devel webkit2gtk3-devel
```

#### Arch Linux
```bash
sudo pacman -S python python-gobject gtk3 webkit2gtk
```

## 🚀 Uso

### Ejecutar el navegador
```bash
# Opción 1: Directamente con Python
python3 browser_simple.py

# Opción 2: Como ejecutable (después de chmod +x)
./browser_simple.py
```

### Funciones principales

#### Navegación
- **Ingresa URLs**: Escribe cualquier URL en la barra de direcciones
- **Búsqueda directa**: Escribe términos de búsqueda para buscar en Google automáticamente
- **Navegación por teclado**: Presiona Enter en la barra de direcciones para navegar

#### Marcadores
- **Agregar marcador**: Haz clic en el botón ⭐ para marcar la página actual
- **Ver marcadores**: Menú → "⭐ Show Bookmarks"
- **Acceso rápido**: Doble clic en cualquier marcador para navegar

#### Historial
- **Ver historial**: Menú → "📜 Show History" 
- **Navegación histórica**: Doble clic en cualquier elemento del historial

## 🔧 Arquitectura Técnica

### Tecnologías Utilizadas
- **Python 3**: Lenguaje principal de desarrollo
- **PyGObject**: Binding de Python para GTK/GNOME
- **GTK 3**: Toolkit de interfaz gráfica nativa
- **WebKit2GTK**: Motor de renderizado web moderno
- **GObject Introspection**: Integración con librerías del sistema

### Ventajas sobre Electron
- **Menor uso de RAM**: No necesita una instancia completa de Chromium
- **Inicio más rápido**: Arranque inmediato sin overhead de Node.js
- **Integración nativa**: Perfecta integración con el escritorio Linux
- **Dependencias del sistema**: Utiliza las librerías ya instaladas en el sistema

### Motor de Renderizado
WebKitGTK proporciona:
- **Compatibilidad moderna**: Soporte completo para estándares web actuales
- **Rendimiento optimizado**: Aceleración de hardware cuando está disponible
- **Seguridad**: Sandboxing y políticas de seguridad robustas
- **Actualizaciones automáticas**: Se actualiza con el sistema operativo

## 📁 Estructura del Proyecto

```
coppernium-browser-webkit/
│
├── browser_simple.py      # Navegador principal
├── install_webkit.sh      # Script de instalación
├── README_webkit.md       # Esta documentación
└── bookmarks_simple.json  # Marcadores (se crea automáticamente)
```

## 🎯 Comparación con Versión Electron

| Característica | WebKit Native | Electron |
|---------------|---------------|-----------|
| **RAM utilizada** | ~50-100 MB | ~200-400 MB |
| **Tiempo de inicio** | <1 segundo | 3-5 segundos |
| **Dependencias** | Sistema | Bundle completo |
| **Actualización** | Sistema automático | Manual |
| **Integración Linux** | Perfecta | Emulada |
| **Configurabilidad** | Media | Alta |

## 🔍 Solución de Problemas

### Error: "No module named 'gi'"
```bash
# Ubuntu/Debian
sudo apt install python3-gi

# Fedora
sudo dnf install python3-gobject
```

### Error: "WebKit2 not found"
```bash
# Ubuntu/Debian
sudo apt install gir1.2-webkit2-4.0

# Fedora
sudo dnf install webkit2gtk3-devel
```

### El navegador no inicia
1. Verifica que todas las dependencias estén instaladas
2. Ejecuta `python3 browser_simple.py` para ver mensajes de error específicos
3. Asegúrate de estar usando Python 3.6 o superior

## 🌟 Características Futuras

### Próximas Mejoras
- [ ] **Pestañas múltiples**: Navegación con pestañas
- [ ] **Gestor de descargas**: Control completo de descargas
- [ ] **Configuraciones avanzadas**: Panel de preferencias detallado
- [ ] **Tema oscuro**: Soporte para temas del sistema
- [ ] **Extensiones simples**: Sistema básico de plugins
- [ ] **Sincronización**: Backup de marcadores y configuración

### Optimizaciones Planificadas
- [ ] **Cache inteligente**: Mejor gestión de caché web
- [ ] **Precarga de DNS**: Resolución anticipada de dominios
- [ ] **Compresión de datos**: Reducción del uso de ancho de banda
- [ ] **Modo offline**: Funcionalidad básica sin conexión

## 💡 Contribuir

Este navegador está diseñado para ser simple y funcional. Si quieres contribuir:

1. **Reporta bugs**: Abre un issue describiendo el problema
2. **Sugiere características**: Propón nuevas funcionalidades útiles
3. **Mejora el código**: Fork, mejora, y envía pull requests
4. **Documenta**: Ayuda a mejorar esta documentación

## 📜 Licencia

MIT License - Libre para usar, modificar y distribuir.

## 🏆 Créditos

Desarrollado por **Sebastian** como parte del proyecto Coppernium Browser.

**Motor WebKit** - Cortesía del proyecto WebKit y la comunidad GNOME.

---

### 🎉 ¡Disfruta navegando con Coppernium Browser!

Un navegador simple, rápido y nativo para Linux que pone el control en tus manos.
