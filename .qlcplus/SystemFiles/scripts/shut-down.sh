#!/bin/bash

zenity --question --title="Sicuro?" --text="Vuoi davvero spegnere il sistema?"

if [ $? -eq 0 ]; then
    sudo shutdown -h now
fi
