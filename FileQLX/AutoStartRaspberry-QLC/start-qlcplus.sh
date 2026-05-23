#!/bin/bash

# Versione OK
# Questa è quella derfinitiva che uso
# Ho tolto la parte legata al tasto CTRL

export NO_AT_BRIDGE=1
export DISPLAY=:0
export XAUTHORITY=/home/maurizio/.Xauthority

USB_DIR="/media/maurizio"
TARGET_DIR="/home/maurizio/.qlcplus/Impianti"
UPDATE_FOLDER="QLCUpdate"
FILENAME="ImpiantoBaiaPasqua2025.qxw"
MAX_WAIT=15

zenity --info --timeout=1 --text="Avvio QLC+ - Attendo chiavetta USB..."

# Attendi il mount della chiavetta fino a MAX_WAIT secondi
elapsed=0
while [ $elapsed -lt $MAX_WAIT ]; do
  for mountpoint in "$USB_DIR"/*; do
    if [ -d "$mountpoint/$UPDATE_FOLDER" ]; then
      zenity --info --timeout=1 --text="Chiavetta trovata in:\n$mountpoint"
      cp "$mountpoint/$UPDATE_FOLDER/$FILENAME" "$TARGET_DIR/"
      zenity --info --timeout=1 --text="File aggiornato da chiavetta."
      break 2
    fi
  done
  sleep 1
  elapsed=$((elapsed + 1))
done

zenity --info --timeout=1 --text="Avvio QLC+ in modalità kiosk..."
/usr/bin/qlcplus -f -p -o "$TARGET_DIR/$FILENAME" 
