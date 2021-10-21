# Rhasspy-Voice-Box
This is a simple script to setup a raspberry pi as a Rhasspy Voice Assistant.
currently it Assumes you ar using the wm8960-audio-hat, WS2812 LEDs connected to pin 12(optional Opt-In), and that you are using an MQTT server.
![20210723_142915](https://user-images.githubusercontent.com/46109936/132101795-ab6fc0a8-ee79-4e48-94f4-013428607ab8.jpg)
##Hardware List
Audio HAT:
https://www.diyelectronics.co.za/store/hats/2366-wm8960-audio-hat-for-raspberry-pi.html?search_query=WM8960&results=2
Raspberry Pi:
https://www.pishop.co.za/store/raspberry-pi-boards/raspberry-pi-zero-wireless-wh-pre-soldered-header

##3D Objects
https://www.thingiverse.com/thing:4949320

##Software Setup
          sudo apt update && sudo apt upgrade -y && sudo apt install git -y && git clone https://github.com/Whogives23/Rhasspy-Voice-Box.git
          sudo reboot
          cd ./Rhasspy-Voice-Box
          sudo bash VoiceBox_installer.sh
##Hardware Setup          
![20210827_144734](https://user-images.githubusercontent.com/46109936/132100676-1383e2bf-b027-407b-a615-2ba236f68812.jpg)
![20210904_174254](https://user-images.githubusercontent.com/46109936/132100684-104d979a-36a5-4e67-b8b0-9ba1321778e0.jpg)
![20210904_174247](https://user-images.githubusercontent.com/46109936/132100687-b369be40-f5fa-4d7e-a9fd-eea92693af01.jpg)
![20210827_144331](https://user-images.githubusercontent.com/46109936/132100689-2015de03-6c46-4de1-9820-88657e78b13c.jpg)
![20210827_144152](https://user-images.githubusercontent.com/46109936/132100690-790d4188-8b4d-44c1-8b9b-192172375dad.jpg)
