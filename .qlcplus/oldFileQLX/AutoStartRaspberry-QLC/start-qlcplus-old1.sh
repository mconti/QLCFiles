#!/bin/bash

# Una della tante bersioni di prova
# In teoria aspetta che al boot si prema CTRL 
# per decidere se partire in modalità kiosk o edit
#
# Ma non sembra sentire il tasto CTRL...
#

echo "aspetta che il sistema monti le USB"
( zenity --info --timeout=1 --text="Avvio script QLC+" ) &

# Timeout totale (secondi)
TIMEOUT=15
ELAPSED=0
INTERVAL=1
USB_MOUNT=""

# Cerca la chiavetta con cartella QLCUpdate
while [ $ELAPSED -lt $TIMEOUT ]; do
    USB_MOUNT=$(find /media/maurizio/* -type d -name "QLCUpdate" 2>/dev/null | head -n 1 | xargs)
    if [ ! -z "$USB_MOUNT" ]; then
        echo "Chiavetta trovata: $USB_MOUNT"
        ( zenity --info --timeout=1 --text="Chiavetta USB trovata!" ) &
        break
    fi
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

if [ ! -z "$USB_MOUNT" ]; then
    DEST="/home/maurizio/.qlcplus/Impianti"
    FILE="$USB_MOUNT/ImpiantoBaiaPasqua2025.qxw"
    mkdir -p "$DEST"
    if cp "$FILE" "$DEST"; then
        echo "File aggiornato con successo"
        ( zenity --info --timeout=1 --text="File aggiornato con successo" ) &
    else
        echo "Errore nella copia del file"
        ( zenity --error --timeout=1 --text="Errore copia file" ) &
    fi
else
    echo "Chiavetta NON trovata entro $TIMEOUT secondi"
    ( zenity --warning --timeout=1 --text="Chiavetta non trovata, proseguo" ) &
fi

echo "Si parte..."
export DISPLAY=:0

# Modalità kiosk/edit
( zenity --info --timeout=1 --text="Premi CTRL per modalità EDIT" ) &
KEY_PRESSED=$(timeout 3 showkey --scancodes 2>/dev/null | grep -i "1d")

if [ ! -z "$KEY_PRESSED" ]; then
    echo "CTRL premuto. Avvio in modalità EDIT"
    ( zenity --info --timeout=1 --text="Modalità EDIT" ) &
    /usr/bin/qlcplus -f -p -o /home/maurizio/.qlcplus/Impianti/ImpiantoBaiaPasqua2025.qxw
else
    echo "CTRL non premuto. Avvio in modalità KIOSK"
    ( zenity --info --timeout=1 --text="Modalità KIOSK" ) &
    /usr/bin/qlcplus -f -k -p -o /home/maurizio/.qlcplus/Impianti/ImpiantoBaiaPasqua2025.qxw
fi
