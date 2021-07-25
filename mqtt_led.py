import paho.mqtt.client as mqtt
import time
from rpi_ws281x import PixelStrip, Color
import argparse

# LED strip configuration:
LED_COUNT = <LEDCount>        # Number of LED pixels.
LED_PIN = <LEDPin>          # GPIO pin connected to the pixels (18 uses PWM!).
LED_FREQ_HZ = 800000  # LED signal frequency in hertz (usually 800khz)
LED_DMA = 10          # DMA channel to use for generating signal (try 10)
LED_BRIGHTNESS = 255  # Set to 0 for darkest and 255 for brightest
LED_INVERT = False    # True to invert the signal (when using NPN transistor level shift)
LED_CHANNEL = 0       # set to '1' for GPIOs 13, 19, 41, 45 or 53

#MQTT Broker Info
broker = '<MQTTHost>'
port = 1883
topic = "/<SiteId>/mqtt"
client_id = 'python-mqtt-<SiteId>'
username = '<MQTTUsername>'
password = '<MQTTPassword>'

#Topics to subscribe to
hotwordTopic = "hermes/hotword/jarvis_raspberry-pi/detected"
textCapturedTopic = "hermes/asr/textCaptured"
ttsSayTopic = "hermes/tts/say"
ttsSayFinishedTopic = "hermes/tts/sayFinished"

#Topic List For ease of subscribing
topicList = [(hotwordTopic,0),(textCapturedTopic,0),(ttsSayTopic,0),(ttsSayFinishedTopic,0)]

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected success")
    else:
        print("Connected fail with code {rc}")
    client.subscribe(topicList)

def on_message(client, userdata, msg):
    #print(f"{msg.topic} {msg.payload}")
    print('Trigger Topic:',msg.topic)
    print('Topic   Topic:',ttsSayTopic)
    func = switch(msg.topic)
    func()
def switch(argument):
    switcher= {
        hotwordTopic: redColorWipe,
        textCapturedTopic: greenColorWipe,
        ttsSayTopic: candleTheaterChase,
        ttsSayFinishedTopic: ledBlackout
    }
    return switcher.get(argument,lambda: 'nothing')

# Define functions which animate LEDs in various ways.
def redColorWipe():
    colorWipe(strip,Color(255,0,0))
def greenColorWipe():
    colorWipe(strip,Color(0,255,0))
def blueColorWipe():
    colorWipe(strip,Color(0,0,255))
def ledBlackout():
    colorWipe(strip,Color(0,0,0),100)
def candleTheaterChase():
    theaterChase(strip,Color(224, 157, 55),200,10)
def colorWipe(strip, color, wait_ms=50):
    """Wipe color across display a pixel at a time."""
    for i in range(strip.numPixels()):
        strip.setPixelColor(i, color)
        strip.show()
        time.sleep(wait_ms / 1000.0)


def theaterChase(strip, color, wait_ms=50, iterations=10):
    """Movie theater light style chaser animation."""
    for j in range(iterations):
        for q in range(3):
            for i in range(0, strip.numPixels(), 3):
                strip.setPixelColor(i + q, color)
            strip.show()
            time.sleep(wait_ms / 1000.0)
            for i in range(0, strip.numPixels(), 3):
                strip.setPixelColor(i + q, 0)


def wheel(pos):
    """Generate rainbow colors across 0-255 positions."""
    if pos < 85:
        return Color(pos * 3, 255 - pos * 3, 0)
    elif pos < 170:
        pos -= 85
        return Color(255 - pos * 3, 0, pos * 3)
    else:
        pos -= 170
        return Color(0, pos * 3, 255 - pos * 3)


def rainbow(strip, wait_ms=20, iterations=1):
    """Draw rainbow that fades across all pixels at once."""
    for j in range(256 * iterations):
        for i in range(strip.numPixels()):
            strip.setPixelColor(i, wheel((i + j) & 255))
        strip.show()
        time.sleep(wait_ms / 1000.0)


def rainbowCycle(strip, wait_ms=20, iterations=5):
    """Draw rainbow that uniformly distributes itself across all pixels."""
    for j in range(256 * iterations):
        for i in range(strip.numPixels()):
            strip.setPixelColor(i, wheel(
                (int(i * 256 / strip.numPixels()) + j) & 255))
        strip.show()
        time.sleep(wait_ms / 1000.0)


def theaterChaseRainbow(strip, wait_ms=50):
    """Rainbow movie theater light style chaser animation."""
    for j in range(256):
        for q in range(3):
            for i in range(0, strip.numPixels(), 3):
                strip.setPixelColor(i + q, wheel((i + j) % 255))
            strip.show()
            time.sleep(wait_ms / 1000.0)
            for i in range(0, strip.numPixels(), 3):
                strip.setPixelColor(i + q, 0)
def blackout(strip):
    for i in range(max(strip.numPixels(), strip.numPixels())):
        strip.setPixelColor(i, Color(0, 0, 0))
        strip.show()
if __name__ == '__main__':
    # Process arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--clear', action='store_true', help='clear the display on exit')
    args = parser.parse_args()

    # Create NeoPixel object with appropriate configuration.
    strip = PixelStrip(LED_COUNT, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT, LED_BRIGHTNESS, LED_CHANNEL)
    # Intialize the library (must be called once before other functions).
    strip.begin()
    colorWipe(strip, Color(0, 0, 0), 10)

    #Start MQTT client and subscribe to topics
    client = mqtt.Client(client_id)
    client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(broker, port, 60) 
    client.loop_forever()
