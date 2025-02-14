# Si obtienes un error como:
# No es posible instalar el módulo "account_peppol". Hay una dependencia externa sin resolver: External dependency phonenumbers not installed: No package metadata was found for phonenumbers
# Copia y pega los siguientes comandos, reinicia la web y repite la acción que te devolvió el error.

sudo -H python3 -m pip install --break-system-packages phonenumbers
sudo systemctl restart odoo
