import RPi.GPIO as GPIO
import os
import time

# Imposta la numerazione BCM (cioè i numeri GPIO, non i numeri fisici dei pin)
GPIO.setmode(GPIO.BCM)

# Configura il GPIO3 come input con resistenza pull-up interna
GPIO.setup(3, GPIO.IN, pull_up_down=GPIO.PUD_UP)

try:
    while True:
        # Quando il pulsante è premuto (livello basso), esegue lo shutdown
        if GPIO.input(3) == GPIO.LOW:
            print("Pulsante premuto, spengo...")
            os.system("sudo shutdown now")
            break
        time.sleep(0.2)
except KeyboardInterrupt:
    GPIO.cleanup()

