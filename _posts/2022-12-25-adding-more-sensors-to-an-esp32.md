---
layout: post
title: Adding more sensors to an ESP32
date: 2022-12-25 16:11 +0100
comments: true
tags:
- esp32
- nodemcu
- sensors
---

I've been running an [ESP32 NodeMCU][0] in the bedroom for motion, temperature, and humidity for a while and have wanted to extend it's functionality by adding light sensing too,  in order to improve the motion light control to trigger when the lux is a certain level vs the current functional, but limited mode based on the position of the sun.

I had initially been putting this off as I wasn't sure how best to spice the jumper wires since the device only had 2x ground and 2x 3v3 power pins. However decided try. The process was fairly simple and involved:

- First cutting off 1 end of the required jumper wires and using a pair of wire cutters to expose the wire inside
- Hook the wires together so that they make good contact
- Wrap exposed section in electrical tape to secure and make more stable

Here is the final result:

![Close up](/assets/img/posts/adding-more-sensors-to-an-esp32/close.jpg)

Overview of the whole enclosure:

![Overview](/assets/img/posts/adding-more-sensors-to-an-esp32/overview.jpg)

ESPHome WebUI: 

![ESPHome WebUI](/assets/img/posts/adding-more-sensors-to-an-esp32/esphome.png)


## Further reading

- [ESPHome based PIR motion sensor setup][1]


[0]: https://affiliate.malachisoord.com/t/fd3c736b-3c34-4107-abd7-f1e3d2ae3dd3
[1]: {% post_url 2019-12-05-esphome-based-pir-motion-sensor-setup %}
