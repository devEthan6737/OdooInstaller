#!/bin/bash

# Script de instalación automática de Odoo en Ubuntu 24.04

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse como root/sudo"
    exit 1
fi

# 1. Actualizar el sistema
echo "Actualizando el sistema..."
apt update && apt upgrade -y

# 2. Instalar dependencias
echo "Instalando dependencias..."
apt install -y python3-pip python3-dev build-essential libssl-dev libffi-dev \
libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev libjpeg-dev \
libpq-dev libjpeg8-dev liblcms2-dev libblas-dev libatlas-base-dev git npm

# 3. Instalar NodeJS y herramientas
echo "Configurando NodeJS..."
apt install -y nodejs
npm install -g less less-plugin-clean-css
apt install -y node-less

# 4. Instalar PostgreSQL
echo "Instalando PostgreSQL..."
apt install -y postgresql

# 5. Crear usuario de PostgreSQL
echo "Creando usuario de base de datos..."
su - postgres -c "createuser -s odoo"

# 6. Crear usuario y grupo del sistema
echo "Creando usuario del sistema..."
adduser --system --quiet --shell=/bin/bash --home=/opt/odoo --gecos 'odoo' --group odoo

# 7. Clonar repositorio de Odoo
echo "Descargando código fuente..."
git clone --depth 1 --branch 18.0 https://github.com/odoo/odoo /opt/odoo/odoo

# 8. Asignar permisos
echo "Ajustando permisos..."
chown -R odoo:odoo /opt/odoo

# 9. Instalar dependencias Python
echo "Instalando requirements.txt..."
pip3 install --break-system-packages -r /opt/odoo/odoo/requirements.txt

# Instalar phonenumbers explícitamente
echo "Instalando phonenumbers..."
pip3 install phonenumbers

# 10. Instalar wkhtmltopdf
echo "Configurando wkhtmltopdf..."
apt install -y fontconfig xfonts-base xfonts-75dpi
cd /tmp
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
dpkg -i wkhtmltox_0.12.6.1-2.jammy_amd64.deb
ln -s /usr/local/bin/wkhtmltopdf /usr/bin/
ln -s /usr/local/bin/wkhtmltoimage /usr/bin/

# 11. Configurar Odoo
echo "Generando configuración..."
su - odoo -c "/opt/odoo/odoo/odoo-bin --addons-path=/opt/odoo/odoo/addons -s --stop-after-init"

mkdir -p /etc/odoo

# Crear archivo de configuración automáticamente
cat << EOF > /etc/odoo/odoo.conf
[options]
admin_passwd = admin
db_host = False
db_port = False
db_user = odoo
db_password = False
addons_path = /opt/odoo/odoo/addons
logfile = /var/log/odoo/odoo-server.log
EOF

chown odoo:odoo /etc/odoo/odoo.conf
mkdir -p /var/log/odoo
chown odoo:odoo /var/log/odoo

# 12. Configurar servicio
echo "Configurando servicio..."
cp /opt/odoo/odoo/debian/init /etc/init.d/odoo
chmod +x /etc/init.d/odoo
ln -s /opt/odoo/odoo/odoo-bin /usr/bin/odoo
update-rc.d -f odoo start 20 2 3 4 5 .

# 13. Iniciar servicio
echo "Iniciando Odoo..."
service odoo start

# Mensaje final
echo "Instalación completada!"
echo "Accede a Odoo en: http://$(hostname -I | awk '{print $1}'):8069"
echo "Asegúrate de abrir el puerto 8069 en tu firewall!"
