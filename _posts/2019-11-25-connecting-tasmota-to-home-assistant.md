---
layout: post
title: Connecting Tasmota to Home Assistant
tags:
- home-automation
- tasmota
- smart-plug
- home-assistant
- mqtt
date: 2019-11-25 22:06 +0100
---
Leading on from a previous post regarding [Flashing custom firmware onto Gosund SP111]({% post_url 2019-11-24-flashing-custom-firmware-on-a-gosund-sp111 %}) devices.

This post explains how to connect devices running [Tasmota][3] to [Home Assistant][1], allowing both control and integrating sensors if your device has power sensing capabilities such as the [Gosund SP111][0].

This post assumes that you have a working Home Assistant setup already configured with MQTT __without discovery enabled__. If you haven't already got this setup please follow their [official documentation][2].

# Setting up the device

To start with ensure that you have configured MQTT on the device. To enable MQTT you must first go `Configuration -> Configure Other -> Check MQTT Enable`

![Tasmota enable MQTT](/assets/img/posts/tasmota-enable-mqtt.png)

Once enabled you can configure the device to connect to the MQTT broker that you have setup to be used by Home Assistant.

![Tasmota configure MQTT](/assets/img/posts/tasmota-mqtt.png)

Your device should reboot after saving, and from the console view you should be able to clearly see if there is an authentication or configuration issue.

# Configuring home assistant

## Setting up switches

In your home-assistant configuration under `switch:` you can now configure your MQTT based device.

```yaml
- name: socket_7
  platform: mqtt
  state_topic: stat/socket-7/POWER
  command_topic: cmnd/socket-7/POWER
  availability_topic: tele/socket-7/LWT
  qos: 1
  payload_on: 'ON'
  payload_off: 'OFF'
  payload_available: Online
  payload_not_available: Offline
  retain: false

```

Replacing `socket_7` with the name of your device, and `socket-7` with the topic you configured earlier.

You can retrieve this information on the information page on Tasmota.

## Setting up sensors

If your Tasmota enabled device exposes some sensors like power reading. You will also be able to extract this out and expose this to Home Assistant.

Place the following under `sensor:` within your Home Assistant configuration.

```yaml
- name: socket_7_energy
  platform: mqtt
  state_topic: "tele/socket-7/SENSOR"
  value_template: '{{ value_json["ENERGY"]["Total"] }}'
  unit_of_measurement: kWh

- name: socket_7_power
  platform: mqtt
  state_topic: "tele/socket-7/SENSOR"
  value_template: '{{ value_json["ENERGY"]["Power"] }}'
  unit_of_measurement: W
```

Replacing the `name` values with something meaningful to you, and `socket-7` with the topic you configured earlier.

To understand what kind of information is being published you can view the raw messages from the console view of the Tasmota UI. Or leverage another tool to help you explorer your topics including:

- [MQTT Explorer][4]
- [MQTTLens][6]

# Useful reading

- [Hassio Docs - Template Sensor][5]
- [Tasmota Docs][7]

[0]: https://www.amazon.de/exec/obidos/ASIN/B07PRF28SR/hexagon05-21/
[1]: https://www.home-assistant.io/
[2]: https://www.home-assistant.io/docs/mqtt/
[3]: https://github.com/arendst/Tasmota/
[4]: http://mqtt-explorer.com/
[5]: https://www.home-assistant.io/integrations/template/
[6]: https://chrome.google.com/webstore/detail/mqttlens/hemojaaeigabkbcookmlgmdigohjobjm?hl=en
[7]: https://tasmota.github.io/docs/#/Home