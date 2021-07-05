#!/bin/sh

Processor=$(uname -m)

# Update Pi
apt update -y && apt upgrade -y && apt dist-upgrade -y

# Install Docker

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Needed Packages
apt install git python3 python3-pip apt-transport-https ca-certificates curl gnupg lsb-release
pip3 install paho-mqtt
pip3 install rpi-ws281x

# Install Audio Hat Driver
git clone https://github.com/waveshare/WM8960-Audio-HAT
cd WM8960-Audio-HAT
 ./install.sh 

#Setup the Docker Container for Rhasspy
if [ "$Processor" =  'armv6l' ]
then
	# For RPI zero:
	echo "Setting Docker to Experimental for Pi Zero"
	echo "{ \"experimental\": true }" > /etc/docker/daemon.json
	systemctl restart docker
	docker pull --platform linux/arm/v6 rhasspy/rhasspy
fi
#Run the Docker Container
docker run -d -p 12101:12101 \
      --name rhasspy \
      --restart unless-stopped \
      -v "$HOME/.config/rhasspy/profiles:/profiles" \
      -v "/etc/localtime:/etc/localtime:ro" \
      --device /dev/snd:/dev/snd \
      rhasspy/rhasspy \
      --user-profiles /profiles \
      --profile en

#Setup and run a service to run the python script that controls the LEDs
cd ..
cp ./mqttled.service /lib/systemd/system/mqttled.service
cp ./mqtt_led.py /home/pi/mqtt_led.py
chmod +x /home/pi/mqtt_led.py
chmod 644 /lib/systemd/system/mqttled.service
systemctl daemon-reload
systemctl enable mqttled.service
systemctl start mqttled.service
systemctl status mqttled.service

reboot
