import smtplib
import sys
import os
from email.message import EmailMessage

ruta_foto = sys.argv[1] if len(sys.argv) > 1 else None

remitente = ""
destinatario = "l23211916@tectijuana.edu.mx"
password_app = ""

msg = EmailMessage()
msg['Subject'] = "ALERTA DE SEGURIDAD"
msg['From'] = remitente
msg['To'] = destinatario
msg.set_content("El sensor detectó actividad. Se adjunta fotografía.")

if ruta_foto and os.path.exists(ruta_foto):
    with open(ruta_foto, 'rb') as f:
        img_data = f.read()
    msg.add_attachment(img_data, maintype='image', subtype='jpeg', filename=os.path.basename(ruta_foto))

try:
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
        smtp.login(remitente, password_app)
        smtp.send_message(msg)
except Exception as e:
    print(f"Error SMTP: {e}")


