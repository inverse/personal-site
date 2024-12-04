---
layout: post
title: WLED fairy lights
date: 2024-12-04 21:13 +0100
comments: true
tags:
- esp32
- nodemcu
- lights
---

The [WLED][0] project is something I have been meaning to use for a while but never got around to experimenting with until recently when I purchased some [WS2812B Fairy Lights][1] to decorate our living room with. The setup was easier than expected and the capabilities of this platform far exceeded my expectations.

From being able to leverage the vast array of preset colours, setup custom playlist, easy integration with Home Assistant, multiple controller synchronization, and more.

## Equipments

- [WS2812B Fairy Lights][1]
- [Cable Connectors][2]
- [NodeMCU ESP32][3]
- [5v 2a Power adaptor][4]
- [Jumper Wires][5]

## Setup

WLED does provide a [web based installer][6] for flashing your controller board via the WebUSB API that's exposed via Chrome but that didn't work for me. Instead I followed the [serial flashing guide using esptool][7].

Once installed I went about connecting the device to the to the Wifi network following the [quick start guide][8].

After the device was added to my network I went around configuring the device for the LED's I had. Below is the main change I made for the LEDs.

![WLED LED config](/assets/img/posts/wled/wled_led_config.png)

the next step would be to wire up the power supply to the LED cable and splicing this so that it could be used for powering the ESP32. This was quite straight forward using the cable connectors,  jumper wires, and the provided power input from the LED cable.

![Wired up](/assets/img/posts/wled/wired_up.jpg)


Finally was to wire up the controller by connecting the GND and 5V pins to the relevant + and - power input. As well as the data line for the LED's onto GPIO2 as that's what I had configured on the WebUI. C

![NodeMCU ESP32 wired up](/assets/img/posts/wled/nodemcu_pin_connect.png)

_Note: consult your particular NodeMCU chip for it's pinout as it may be different to the one I used._



[0]: https://kno.wled.ge/
[1]: https://www.amazon.de/exec/obidos/ASIN/B0D6XQW9JR/hexagon05-21/
[2]: https://www.amazon.de/exec/obidos/ASIN/B0BCNTVV4S/hexagon05-21/
[3]: https://www.amazon.de/exec/obidos/ASIN/B074RGW2VQ/hexagon05-21/
[4]: https://www.amazon.de/exec/obidos/ASIN/B09KNFD38L/hexagon05-21/
[5]: https://www.amazon.de/exec/obidos/ASIN/B01EV70C78/hexagon05-21/
[6]: https://install.wled.me/
[7]: https://kno.wled.ge/basics/install-binary/#flashing-method-2-esptool
[8]: https://kno.wled.ge/basics/getting-started/#quick-start-guide
