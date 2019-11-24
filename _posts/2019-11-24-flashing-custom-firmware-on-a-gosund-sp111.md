---
layout: post
title: Flashing custom firmware on a Gosund SP111
comments: true
tags:
- home-automation
- tasmota
- smart-plug
date: 2019-11-24 21:00 +0100
---

We have some older generation [Teckin SP22][4]'s which I previously flashed with [Espurna][1]. They have since changed the model
making it harder to flash due to the removal of the 4 screws on the back. People online reported some levels of success using [Tuya Convert]
[2], but I wanted something that I could flash via serial.

This lead me to looking into alternatives, eventually leading me to the [Gosund SP111][3] due to it also featuring power reading capabilities and higher load rating.

To flash this device you will need:

- [FTDI Adaptor](https://www.amazon.de/exec/obidos/ASIN/B01N9RZK6I/hexagon05-21/)
- [Female to male jumper wires](https://www.amazon.de/exec/obidos/ASIN/B07K8PVKBP/hexagon05-21/)
- [Mini USB cable](https://www.amazon.de/exec/obidos/ASIN/B00NH13S44/hexagon05-21/)
- [Small Philips head screwdriver](https://www.amazon.de/exec/obidos/ASIN/B07Q3TDMK2/hexagon05-21/)

There are several custom firmwares available for these ESP8266 based devices, including:

- [Espurna][1]
- [Tasmota][5]
- [esphome][6]

This time I went with Tasmota as it was well documented, has a big community, and I wanted to try something different.

# Preparing the device

To be able to flash the device you must first remove a single screw which can be done from the back of the device.

![Gosund SP111 closed back](/assets/img/posts/gesund-sp111-closed-back.jpg)

Once losened you should be able pop off the top, around the translucent rim.

![Gosund SP111 open](/assets/img/posts/gesund-sp111-open.jpg)

As you can see from the diagram there are the soldering points exposed which we must connect the relevent jumper cables too.


| FTDI   | Gosund |
|--------|--------|
| `3.3v` | `3.3v` |
| `GND`  | `GND`  |
| `RX`   | `TX`   |
| `TX`   | `RX`   |

This table describes the way in which you should connect the devise to the FTDI.


![Gosund SP111 open atached](/assets/img/posts/gesund-sp111-open-attached.jpg)

I ended up sharpening the male ends of the jumper cables slightly so that they would fall slightly through the holes, using tape to secure them to the side of the device making it easier to work with.

![FTDI wired](/assets/img/posts/ftdi-wired.jpg)

Here is the other end of the FTDI wired up showing the two cables wired to `GND` which will be used later for putting the device into flashing mode.

# Flashing

For the flashing process I used [esptool][7] a simple well documented command line tool.

To put the device into flashing mode you need to cross `GPIO0` with `GND` for a few seconds whilst connecting the FTDI adaptor.

You can easily do this by holding the bridged cable on `GPI0` by hand and removing shorly after. To tell this worked correctly when removed  the red LED turns dimmed, indicating it's in flashing mode.


Backup existing firmware (optional):
```
sudo esptool.py --port /dev/ttyUSB0 read_flash 0x00000 0x100000 <name-of-backup>.bin
```
_replacing `<name-of-backup>` with something more meaningful like `gosund-sp111-v1.1`_


Erasing existing firmware:
```
sudo esptool.py --port /dev/ttyUSB0 erase_flash
```

Flashing new firmware
```
sudo esptool.py --port /dev/ttyUSB0 write_flash -fs 1MB -fm dout 0x0 sonoff.bin
```

_where `sonoff.bin` is the [latest Tasmota build][9]._


Once finished disconnect cables and assemble device. Follow the [official documentation][8] from here regarding setting up the device.

# Additional info

I noticed that the LED was always on no matter if the device is on or off. To fix this others reported pasting the following value into the console of the web UI.

```
SetOption3 0
```

# Further reading

- [Gosund SP111 mit Tasmota][0]
- [Tasmota][5]

[0]: https://www.bastelbunker.de/gosund-sp111-mit-tasmota/
[1]: https://github.com/xoseperez/espurna
[2]: https://github.com/ct-Open-Source/tuya-convert
[3]: https://www.amazon.de/exec/obidos/ASIN/B07PRF28SR/hexagon05-21/
[4]: https://www.amazon.de/exec/obidos/ASIN/B07CDCYLQ6/hexagon05-21/
[5]: https://github.com/arendst/Tasmota/
[6]: https://esphome.io/
[7]: https://github.com/espressif/esptool
[8]: https://github.com/arendst/Tasmota/wiki/Initial-Configuration
[9]: https://github.com/arendst/Tasmota/releases