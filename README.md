# Script de Instalación Automatizada de Odoo para Ubuntu 24.04

Este repositorio contiene un script Bash que automatiza la instalación de **Odoo 18.0** en sistemas **Ubuntu 24.04**, siguiendo las mejores prácticas y configuraciones recomendadas.

---

## 📋 Requisitos Previos
- Sistema operativo Ubuntu 24.04 (compatible con versiones basadas en Debian).
- Acceso de administrador (`sudo` o usuario root).
- Conexión a Internet estable.
- Puerto **8069** abierto en el firewall (para acceso web).

---

## 🚀 Características del Script
- Instala todas las dependencias necesarias (Python, NodeJS, PostgreSQL, etc.).
- Configura un usuario dedicado para Odoo.
- Clona el repositorio oficial de Odoo 18.0.
- Genera automáticamente el archivo de configuración.
- Configura Odoo como un servicio del sistema.
- Instala **wkhtmltopdf** para generación de PDFs.
- Incluye manejo de errores comunes (p. ej., paquetes ya instalados).

---

## 🛠️ Cómo Usar

### 1. Clonar el repositorio
```bash
git clone https://github.com/devEthan6737/OdooInstaller.git
cd OdooInstaller
chmod +x ./installer.sh
sudo ./installer.sh
