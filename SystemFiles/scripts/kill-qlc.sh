#/bin/bash
zenity --info --timeout=1 --text="Chiudo..."
sudo (sleep 1 && pkill -15 -f qlcplus) &
sudo (sleep 1 && killall qlcplus) &
#sudo systemctl stop qlcplus.service
