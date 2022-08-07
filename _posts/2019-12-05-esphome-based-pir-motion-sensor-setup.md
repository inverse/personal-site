---
layout: post
title: ESPHome based PIR motion sensor setup
comments: true
tags:
- home-automation
- home-assistant
- esp32
date: 2019-12-05 21:49 +0100
---
We have a couple [Hue Motion Sensors][0] in our apartment to provide some automation for lighting control which work great, albeit a bit expensive.

I wanted to extend our setup for our bedroom and since we already had an [ESP32 NodeMCU][1] device running [ESPHome][2] with a [DHT22][3] Sensor collecting temperature and humidity metrics, extending this felt like the logical choice.

This led me to to discovering some basic [PIR Motion Sensors][11] which can easily be hooked up and report back if motion is detected.

## Parts

- [ESP32 NodeMCU][1]
- ~~[HC-SR501 PIR Motion Sensor][4]~~
- [AM312 PIR Motion Sensor][11]
- [Jumper cables][5]
- [Micro USB power cable][8]
- [Hot gue gun][6] (Optional)
- [DHT22 sensor][3] (Optional)
- [Tupperware box][7] (Optional)

Since writing this blog post I have since replaced the HC-SR501 sensor with a [AM312][11] due to the amount false positives that I was getting. As you can see from the screenshot below it dramatically reduced this. The only downside I have seen so far is the lack of customisation with sensitivity and trigger interval but it has worked flawlessly in the location we have it positioned.

![AM312 Upgrade](/assets/img/posts/am312-ha-upgrade.jpg)

## Configuring ESPHome

ESPHome is an awesome platform that allows you to easily scaffold out IOT projects with a few lines of YAML.

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

Follow the instructions on their website for [getting started][9] and [managing secrets][10].

Once flashed to the device ensuring that the `GPIO` pins are connected correctly. You should be able to navigate to the address you configured or the DHCP provided one and you should get back the sensor statistics.

![ESPHome Bedroom WebUI](/assets/img/posts/esphome-bedroom-sensor-pir.png)

## Configuring Home Assistant

Next lets hook this up to Home Assistant which is as easy as navigating to

```text
Configuration -> Integrations -> + (Bottom left) -> ESPHome
```

and entering the IP/Host of your device.

![Home Assistant ESPHome integration](/assets/img/posts/ha-esphome-integration.png)

Once configured, you will have a `binary_sensor` configured which can be used in automation.

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
  action:B085Q5ZR33
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

## Finished product

I didn't want to leave the ESP32 device exposed so build a very rudimentary case out of a tupperware box.

Cutting a hole on the front for the PIR sensor, using a hot glue gun to keep it fixed. As well as a small hole in the bottom for power, and one on the side for the DHT22 sensor.

To block out as much light from the LED on the ESP32 I cut some cardboard to shape.

![PIR setup open back](/assets/img/posts/pir-setup-open-back.jpg)

![PIR setup open front](/assets/img/posts/pir-setup-open-front.jpg)

[0]: https://affiliate.malachisoord.com/t/8f989f1b-1708-4903-9f1f-2813ce3432c1
[1]: https://affiliate.malachisoord.com/t/fd3c736b-3c34-4107-abd7-f1e3d2ae3dd3
[2]: https://esphome.io/
[3]: https://affiliate.malachisoord.com/t/5604e2ce-adf8-4331-9592-749bfcf2b164
[4]: https://affiliate.malachisoord.com/t/a73db71f-c7cf-4754-bb86-492854e292cf
[5]: https://affiliate.malachisoord.com/t/4022f71a-0f33-41e9-82bd-a00f0bfd7774
[6]: https://affiliate.malachisoord.com/t/2830ba84-043b-48d9-8b01-87101952b734
[7]: https://affiliate.malachisoord.com/t/101a7f1a-28c1-4c3a-9ecc-a7e288c5e28a
[8]: https://affiliate.malachisoord.com/t/14b7dc59-c7ad-4d5d-a52c-472bbdffbee2
[9]: https://esphome.io/guides/getting_started_command_line.html
[10]: https://esphome.io/guides/faq.html?highlight=secrets
[11]: https://affiliate.malachisoord.com/t/5fe0ecca-c895-4f0e-acbd-049572e9e610
