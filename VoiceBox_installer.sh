#!/bin/sh
SatelliteProfile=./satellite_profile.json
LEDScript=./mqtt_led.py
Processor=$(uname -m)
dockerInstalled=$(docker -v)
echo "WELCOME TO MY RHASSPY SATELLITE SETUP SCRIPT!"
echo "PLEASE SUPPLY THE FOLLOWING INFO:"
echo ""
echo "WHAT IS THIS DEVICE'S NAME?(EG: LoungeEcho)[NO SPACES]"
read SiteId
echo ""
echo "WHAT IS YOUR MQTT BROKER NAME OR IP ADDRESS? (EG: broker.local or 192.168.1.5)"
read HostId
echo ""
echo "WHAT IS YOUR MQTT BROKER USERNAME?"
read MQTTUsername
echo ""
echo "WHAT IS YOUR MQTT BROKER PASSWORD? (LEAVE THIS BLANK IF NONE)"
read MQTTPassword
echo ""
echo "ARE YOU GOING TO BE RUNNING NEOPIXEL LEDS ON THIS DEVICE? (yes/no)"
read isLED 
echo ""
isLED="$isLED" | sed -e 's/\(.*\)/\L\1/'
if [ "$isLED"  = "yes" ]
then
	echo "HOW MANY LEDS ARE YOU USING? (EG: 6)"
	read LEDCount
	echo ""
	echo "WHICH PIN ON THE PI ARE YOU USING FOR THE LEDS? (12 IS PREFERRED)"
	read LEDPin
fi
echo ""
echo "GOOD TO GO. WATCH THIS SPACE"
echo ""
# Update Pi
echo "###########################"
echo "      UPDATING PI"
echo "###########################"

apt update -y && apt upgrade -y && apt dist-upgrade -y

# Install Needed Packages
echo " "
echo "###########################"
echo "    INSTALLING PACKAGES"
echo "###########################"

apt install git python3 python3-pip apt-transport-https ca-certificates curl gnupg lsb-release -y
pip3 install paho-mqtt
pip3 install rpi-ws281x

# Install Docker
echo " "
echo "###########################"
if [ ! "$dockerInstalled" = *"Docker version"* ]
then	
	echo "     INSTALLING DOCKER"
	echo "###########################"
	apt install dpkg -y
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh
else
	echo "  DOCKER ALREADY INSTALLED"
	echo "###########################"

fi

# Install Audio Hat Driver
echo " "
echo "###########################"
echo "  INSTALLING PI AUDIO HAT"
echo "###########################"

git clone https://github.com/waveshare/WM8960-Audio-HAT
cd ./WM8960-Audio-HAT
./install.sh 
cd ..
#Setup the Docker Container for Rhasspy
echo " "
echo "###########################"
echo "    INSTALLING RHASSPY"
echo "###########################"

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

sed -i "s/<SiteID>/$SiteId/g" "$SatelliteProfile"
sed -i "s/<MQTTHost>/$HostId/g" "$SatelliteProfile"
sed -i "s/<MQTTUsername>/$MQTTUsername/g" "$SatelliteProfile"
sed -i "s/<MQTTPassword>/$MQTTPassword/g" "$SatelliteProfile"
docker cp "$SatelliteProfile" rhasspy:/profiles/en/profile.json
#Setup and run a service to run the python script that controls the LEDs
if [ "$isLED" = "yes" ]
then
	echo " "
	echo "###########################"
	echo "  INSTALLING LED SCRIPT"
	echo "###########################"
	sed -i "s/<SiteId>/$SiteId/g" "$LEDScript"
	sed -i "s/<MQTTHost>/$HostId/g" "$LEDScript"
	sed -i "s/<MQTTUsername>/$MQTTUsername/g" "$LEDScript"
	sed -i "s/<MQTTPassword>/$MQTTPassword/g" "$LEDScript"
	sed -i "s/<LEDCount>/$LEDCount/g" "$LEDScript"
	sed -i "s/<LEDPin>/$LEDPin/g" "$LEDScript"
	cp ./mqttled.service /lib/systemd/system/mqttled.service
	cp $LEDScript /home/pi/mqtt_led.py
	chmod +x /home/pi/mqtt_led.py
	chmod 644 /lib/systemd/system/mqttled.service
	systemctl daemon-reload
	systemctl enable mqttled.service
	systemctl start mqttled.service
	servicestate=$(systemctl status mqttled.service)
	echo "$servicestate"
fi
echo "SETUP COMPLETE! PRESS ANY KEY TO REBOOT"
read anykey
reboot
