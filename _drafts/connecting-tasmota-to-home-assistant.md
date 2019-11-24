---
layout: post
title: Connecting Tasmota to Home Assistant
tags:
- home-automation
- tasmota
- smart-plug
- home-assistant
- mqtt
---

Leading on from a previous post regarding [Flashing custom firmware onto Gosund SP111]({% post_url 2019-11-24-flashing-custom-firmware-on-a-gosund-sp111 %}) devices. 

This post explains how to connect devices running Tasmota to [Home Assistant][1], allowing both control and integrating sensors if your device has power sensing capabilities such as the [Gosund SP111][0].

This post assumes that you have a working Home Assistant setup already configured with MQTT without discovery enabled. If you haven't already got this setup please follow their [official documentation][2].

# Setting up the device

To start with ensure that you have configured MQTT on the device. To enable MQTT you must first go `Configuration -> Configure Other -> Check MQTT Enable`

![Tasmota enable MQTT](/assets/img/posts/tasmota-enable-mqtt.png)

Once enabled you can configure the device to connect to the MQTT broker that you have setup to be used by Home Assistant.

![Tasmota configure MQTT](/assets/img/posts/tasmota-mqtt.png)

# Configuring home assistant

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

[0]: https://www.amazon.de/exec/obidos/ASIN/B07PRF28SR/hexagon05-21/
[1]: https://www.home-assistant.io/
[2]: https://www.home-assistant.io/docs/mqtt/broker