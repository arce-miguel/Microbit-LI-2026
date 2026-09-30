#!/bin/bash

PUERTO="/dev/ttyACM0"
BAUD_RATE="115200"

stty -F $PUERTO $BAUD_RATE raw -echo
echo "Escuchando a la micro:bit en $PUERTO..."

cat $PUERTO | while read -r linea; do
    mensaje=$(echo "$linea" | tr -d '\r\n\0')

    if [ -z "$mensaje" ]; then
        continue
    fi

    case "$mensaje" in
        "ALERTA_MOVIMIENTO")
            notify-send "SEGURIDAD" "Movimiento detectado" -u critical
            paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga &
            ;;
            
        "ALERTA_LUZ")
            notify-send "SEGURIDAD" "Luz detectada, tomando fotografía..." -u normal
            NOMBRE_FOTO="evidencia_$(date +%Y-%m-%d_%H-%M-%S).jpg"
            fswebcam -r 1280x720 --jpeg 85 "$NOMBRE_FOTO" > /dev/null 2>&1
            
            # Llamada al script de Python para enviar correo
            python3 enviar_alerta.py "$NOMBRE_FOTO" &
            ;;
    esac
done
