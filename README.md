# Rhasspy-Voice-Box
This is a simple script to setup a raspberry pi as a Rhasspy Voice Assistant.
currently it Assumes you ar using the wm8960-audio-hat, WS2812 LEDs connected to pin 12(optional Opt-In), and that you are using an MQTT server. Its also set up to be used as a base-slave configuration as explained here: https://rhasspy.readthedocs.io/en/latest/tutorials/#server-with-satellites
![20210723_142915](https://user-images.githubusercontent.com/46109936/132101795-ab6fc0a8-ee79-4e48-94f4-013428607ab8.jpg)
##Hardware List
Audio HAT:
https://www.diyelectronics.co.za/store/hats/2366-wm8960-audio-hat-for-raspberry-pi.html?search_query=WM8960&results=2
Raspberry Pi(with header soldered):
https://www.diyelectronics.co.za/store/boards/1803-raspberry-pi-zero-w.html

##3D Objects
https://www.thingiverse.com/thing:4949320

##Software Setup
1. Install Raspberry Pi OS Lite : https://www.raspberrypi.com/software/
2. Setup your Wifi Network and ssh by adding a blank ssh.txt, and a wpa_supplicant.conf file to the root of Boot directory on the SD Card before powering up your Pi:
https://www.raspberrypi-spy.co.uk/2017/04/manually-setting-up-pi-wifi-using-wpa_supplicant-conf/
3. Stick the SD into your Pi, and power it up. Give it a few minutes to get itself together.
4. once the Pi is available on the network, SSH into it using the relevant IP address.
5. Run the following command to update, install, and pull the needed files:
         
         `` sudo apt update && sudo apt upgrade -y && sudo apt install git -y && git clone https://github.com/Whogives23/Rhasspy-Voice-Box.git``
6. Reboot:
        
        `` sudo reboot``
7. Once it comes back online, run the following commands to start setup, and follow the on-screen prompts:
          ```
          cd ./Rhasspy-Voice-Box
          sudo bash VoiceBox_installer.sh
          ```
##Hardware Setup          
![20210827_144734](https://user-images.githubusercontent.com/46109936/132100676-1383e2bf-b027-407b-a615-2ba236f68812.jpg)
![20210904_174254](https://user-images.githubusercontent.com/46109936/132100684-104d979a-36a5-4e67-b8b0-9ba1321778e0.jpg)
![20210904_174247](https://user-images.githubusercontent.com/46109936/132100687-b369be40-f5fa-4d7e-a9fd-eea92693af01.jpg)
![20210827_144331](https://user-images.githubusercontent.com/46109936/132100689-2015de03-6c46-4de1-9820-88657e78b13c.jpg)
![20210827_144152](https://user-images.githubusercontent.com/46109936/132100690-790d4188-8b4d-44c1-8b9b-192172375dad.jpg)
