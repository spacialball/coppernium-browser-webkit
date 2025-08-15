# 🚀 Guía de Instalación - Coppernium Browser

Esta guía te ayudará a instalar **Coppernium Browser** en tu sistema Linux usando nuestro instalador automático.

## 📋 Requisitos del Sistema

### Distribuciones Soportadas
- **Ubuntu** / **Linux Mint** / **Elementary OS** / **Pop!_OS**
- **Debian** y derivados
- **Fedora** / **CentOS** / **RHEL**
- **Arch Linux** / **Manjaro**
- **openSUSE** / **SLED**

### Requisitos Mínimos
- **Python 3.6+**
- **GTK 3**
- **WebKit2GTK 4.1**
- **2 GB de RAM** (el navegador usa ~50-100 MB)
- **50 MB de espacio libre** en disco

## 🛠️ Instalación

### Opción 1: Instalación Completa del Sistema (Recomendada)

Esta opción instala Coppernium Browser como una aplicación del sistema, disponible en el menú de aplicaciones y desde la terminal.

```bash
# 1. Hacer ejecutable el instalador
chmod +x coppernium-installer.sh

# 2. Ejecutar instalación
./coppernium-installer.sh
```

**¿Qué incluye esta instalación?**
- ✅ Instalación automática de dependencias
- ✅ Comando `coppernium-browser` disponible globalmente
- ✅ Entrada en el menú de aplicaciones
- ✅ Icono del navegador
- ✅ Integración completa con el sistema
- ✅ Script de desinstalación incluido

### Opción 2: Instalación Solo de Dependencias

Si solo quieres instalar las dependencias necesarias para ejecutar el navegador localmente:

```bash
# Hacer ejecutable
chmod +x install_webkit.sh

# Instalar dependencias
./install_webkit.sh
```

Luego puedes ejecutar directamente:
```bash
python3 browser_simple.py
```

## 📱 Uso del Instalador

### Comandos Disponibles

```bash
# Mostrar ayuda
./coppernium-installer.sh --help

# Instalar (por defecto)
./coppernium-installer.sh

# Desinstalar
./coppernium-installer.sh --uninstall

# Probar instalación actual
./coppernium-installer.sh --test
```

### Proceso de Instalación

El instalador realiza los siguientes pasos automáticamente:

1. **🔍 Verificación del Sistema**
   - Detecta tu distribución de Linux
   - Verifica permisos y dependencias

2. **📦 Instalación de Dependencias**
   - Instala Python 3 y PyGObject
   - Instala WebKit2GTK y GTK 3
   - Instala herramientas del sistema

3. **📁 Instalación del Navegador**
   - Crea `/opt/coppernium/` para archivos del programa
   - Copia navegador y documentación
   - Configura permisos ejecutables

4. **🖥️ Integración del Sistema**
   - Crea comando `coppernium-browser` en `/usr/local/bin/`
   - Añade entrada al menú de aplicaciones
   - Instala icono del navegador
   - Actualiza bases de datos del sistema

5. **✅ Verificación**
   - Prueba que todos los componentes funcionan
   - Confirma instalación exitosa

## 🎯 Después de la Instalación

### Formas de Ejecutar Coppernium Browser

#### 1. Desde el Menú de Aplicaciones
Busca "**Coppernium Browser**" en tu menú de aplicaciones o lanzador.

#### 2. Desde la Terminal
```bash
coppernium-browser
```

#### 3. Directamente
```bash
/opt/coppernium/browser_simple.py
```

### Archivos Instalados

```
/opt/coppernium/                    # Directorio principal
├── browser_simple.py               # Ejecutable del navegador
├── README_webkit.md               # Documentación
├── install_webkit.sh              # Instalador de dependencias
└── uninstall.sh                   # Desinstalador

/usr/local/bin/coppernium-browser   # Comando del sistema
/usr/share/applications/coppernium-browser.desktop  # Menú
/usr/share/pixmaps/coppernium-browser.*  # Iconos
```

## 🗑️ Desinstalación

### Método 1: Con el Instalador
```bash
./coppernium-installer.sh --uninstall
```

### Método 2: Script de Desinstalación
```bash
/opt/coppernium/uninstall.sh
```

### Método 3: Manual
```bash
sudo rm -rf /opt/coppernium/
sudo rm -f /usr/local/bin/coppernium-browser
sudo rm -f /usr/share/applications/coppernium-browser.desktop
sudo rm -f /usr/share/pixmaps/coppernium-browser.*
sudo update-desktop-database /usr/share/applications/
```

## 🔧 Solución de Problemas

### Error: "No se encuentra browser_simple.py"
**Solución:** Asegúrate de ejecutar el instalador desde el directorio donde descargaste Coppernium Browser.

```bash
cd directorio-de-coppernium
./coppernium-installer.sh
```

### Error: "WebKit2 not found" 
**Solución:** Las dependencias no se instalaron correctamente.

```bash
# Ubuntu/Debian
sudo apt install gir1.2-webkit2-4.1

# Fedora
sudo dnf install webkit2gtk3-devel

# Arch
sudo pacman -S webkit2gtk
```

### Error: "Permission denied"
**Solución:** Asegúrate de que el script sea ejecutable y no lo ejecutes como root.

```bash
chmod +x coppernium-installer.sh
./coppernium-installer.sh  # NO usar sudo
```

### El navegador no aparece en el menú
**Solución:** Actualiza la base de datos de aplicaciones.

```bash
sudo update-desktop-database /usr/share/applications/
```

### Problemas con iconos
**Solución:** Actualiza la caché de iconos.

```bash
sudo gtk-update-icon-cache -f -t /usr/share/pixmaps/
```

## 📊 Comparación de Métodos de Instalación

| Característica | Instalador Sistema | Solo Dependencias |
|---------------|-------------------|-------------------|
| **Facilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Integración** | ✅ Completa | ❌ Manual |
| **Menú Apps** | ✅ Automático | ❌ No |
| **Comando Global** | ✅ `coppernium-browser` | ❌ Solo local |
| **Desinstalación** | ✅ Automática | ❌ Manual |
| **Actualizaciones** | ✅ Fácil | ❌ Manual |

## 🎉 ¡Instalación Completada!

Una vez instalado, podrás disfrutar de:

- 🌐 **Navegación web completa** con motor WebKit
- ⭐ **Marcadores** para tus sitios favoritos
- 📜 **Historial** de navegación
- 🔍 **Búsqueda inteligente** integrada
- 🐧 **Integración perfecta** con Linux
- 💾 **Bajo consumo** de memoria (~50-100 MB)
- ⚡ **Inicio rápido** (<1 segundo)

## 📞 Soporte

Si encuentras problemas:

1. **Revisa** esta guía de solución de problemas
2. **Ejecuta** `./coppernium-installer.sh --test` para diagnosticar
3. **Verifica** que tu distribución esté soportada
4. **Asegúrate** de tener permisos de administrador (sudo)

---

**¡Disfruta navegando con Coppernium Browser!** 🎉

*Navegador desarrollado por Sebastian*
