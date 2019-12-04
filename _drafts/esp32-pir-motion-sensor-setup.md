---
layout: post
title: ESP32 PIR motion sensor setup
comments: true
tags:
- home-automation
- home-assistant
- esp32
---

Previously we had used the [Hue Motion Sensors][0] in our apartment to provide some automation for lighting control which work great, albeit a bit expensive.

I wanted to extend our setup for our bedroom and since we already had an [ESP32 NodeMCU][1] device running [ESPHome][2] with a [DHT11][3] Sensor collecting temperature and humidity metrics I looked into extending this with another sensor for motion sensing. 

This led me to to discovering some basic [PIR Motion Sensors][4] which can easily be hooked up and report back if motion is detected.

## Configuring ESPHome

ESPHome is an awesome platform that allows you to easily scaffold out some IOT projects.

Below is the configuration for our ESP device in our bedroom. 

```yaml
esphome:
  name: esphome_bedroom
  platform: ESP32
  board: nodemcu-32s

wifi:
  ssid: 'Sunshine_Recorder'
  password: !secret ssid_password
  domain: .beachi
  manual_ip: # Optional if you want a static IP
    static_ip: 192.168.1.104
    gateway: 192.168.1.1
    subnet: 255.255.255.0

logger:

# For feeding back to HA
api:
  password: !secret password

ota:
  password: !secret password

web_server:
  port: 80


sensor:
  - platform: dht
    model: AM2302
    pin: GPIO15
    temperature:
      name: "Bedroom Temperature"
    humidity:
      name: "Bedroom Humidity"
    update_interval: 60s

binary_sensor:
  - platform: gpio
    pin: GPIO13
    name: "Bedroom Motion"
    device_class: motion

```

Once flashed to the device ensuring that the `GPIO` pins are connected correctly. You should be able to navigate to the address you configured or the DHCP provided one and you should get back the sensor statistics.

![ESPHome Bedroom WebUI](/assets/img/posts/esphome-bedroom-sensor-pir.png)


# Configuring Home Assistant

The real power of this comes when you hook this up to Home Assistant which is as easy as navigating to

```
Configuration -> Integrations -> + (Bottom left) -> ESPHome
```

and entering the IP/Host of your device.


Once configured, you should have a binary_sensor configured which can be used in automation. 

Since our setup is in our bedroom we do not want to have the lighting coming on when we move at night so added an input boolean which gets enabled when we activate our bedtime routine.


```yaml

# Input boolean

bedtime:
  name: Bedtime
  initial: off
  icon: mdi:hotel

# Scripts

bedtime:
  alias: 'Bedtime'
  sequence:
  - service: input_boolean.turn_on
    data:
      entity_id: input_boolean.bedtime
  - service: script.turn_on
    entity_id:
    - script.all_off


# Automation

- alias: Bedroom Motion On
  trigger:
  - platform: state
    entity_id: binary_sensor.bedroom_motion
    to: 'on'
  condition:
  - condition: state
    entity_id: input_boolean.bedtime
    state: 'off'
  - condition: state
    entity_id: sun.sun
    state: 'below_horizon'
  action:
  - service: light.turn_on
    entity_id: light.bedroom
  - service: switch.turn_on
    entity_id: switch.socket_fairy_lights

- alias: Bedroom Motion Off
  trigger:
  - platform: state
    entity_id: binary_sensor.bedroom_motion
    to: 'off'
    for:
      minutes: 1
  action:
  - service: light.turn_off
    entity_id: light.bedroom
  - service: switch.turn_off
    entity_id: switch.socket_fairy_lights

- alias: 'Turn Off Bedtime'
  trigger:
  - platform: time
    at: '08:30:00'
  action:
  - service: input_boolean.turn_off
    data:
      entity_id: input_boolean.bedtime
```

[0]: https://www.amazon.de/exec/obidos/ASIN/B07PRF28SR/hexagon05-21/
[1]: https://www.amazon.de/exec/obidos/ASIN/B07PRF28SR/hexagon05-21/
[2]: https://www.amazon.de/exec/obidos/ASIN/B07PRF28SR/hexagon05-21/
[3]: https://www.amazon.de/exec/obidos/ASIN/B07PRF28SR/hexagon05-21/
[4]: https://www.amazon.de/exec/obidos/ASIN/B07V9GFHFW/hexagon05-21/