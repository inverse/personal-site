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

> **Note** Be sure to get the higher rated 3500W (15A) version as they container the newer PCB that provides such ease of flashing.

To flash this device, you will need:

- [FTDI Adaptor](https://affiliate.malachisoord.com/t/20cb7a7d-1157-4823-b181-9ecedf82ef21)
- [Female to male jumper wires](https://affiliate.malachisoord.com/t/b3af143d-1206-460a-98e9-d309ef8b846a)
- [Mini USB cable](https://affiliate.malachisoord.com/t/bb7ee6e6-6dc5-4dcf-91c0-cc1b755b4a03)
- [Small Philips head screwdriver](https://affiliate.malachisoord.com/t/8bf9d6f3-d5e7-4aef-b09a-7b6e1d36f98c)

There are several custom firmwares available for these ESP8266 based devices, including:

- [Espurna][1]
- [Tasmota][5]
- [esphome][6]

This time I went with Tasmota as it was well documented, has a big community, and I wanted to try something different.

## Preparing the device

To be able to flash the device you must first remove a single philips head screw which can be done from the back of the device.

![Gosund SP111 closed back](/assets/img/posts/gosund-sp111-closed-back.jpg)

Once loosened you should be able pop off the top, around the translucent rim.

![Gosund SP111 open](/assets/img/posts/gosund-sp111-open.jpg)

As you can see from the diagram there are the soldering points exposed which we must connect the relevant jumper cables too.

| FTDI   | Gosund |
|--------|--------|
| `3.3v` | `3.3v` |
| `GND`  | `GND`  |
| `RX`   | `TX`   |
| `TX`   | `RX`   |

This table outlines the way in which you should connect the plug to the FTDI adaptor.

![Gosund SP111 open atached](/assets/img/posts/gosund-sp111-open-attached.jpg)

I ended up sharpening the male ends of the jumper cables slightly so that they would fall slightly through the holes, using tape to secure them to the side of the device making it easier to work with.

> **Note** the diagram above is for illustration purposes and missing `GND` being connected.

![FTDI wired](/assets/img/posts/ftdi-wired.jpg)

Here is the other end of the FTDI wired up showing the two cables wired to `GND` which will be used later for putting the device into flashing mode.

## Flashing

For the flashing process I used [esptool][7] a simple well documented command line tool.

To put the device into flashing mode you need to cross `GPIO0` with `GND` for a few seconds whilst connecting the FTDI adaptor.

You can easily do this by holding the bridged cable on `GPI0` by hand and removing shortly after. To tell this worked correctly when removed  the red LED turns dimmed, indicating it's in flashing mode.

Backup existing firmware (optional):

```bash
sudo esptool.py --port /dev/ttyUSB0 read_flash 0x00000 0x100000 <name-of-backup>.bin
```

_replacing `<name-of-backup>` with something more meaningful like `gosund-sp111-v1.1`_

Erasing existing firmware:

```bash
sudo esptool.py --port /dev/ttyUSB0 erase_flash
```

Flashing new firmware

```bash
sudo esptool.py --port /dev/ttyUSB0 write_flash -fs 1MB -fm dout 0x0 sonoff.bin
```

_where `sonoff.bin` is the [latest Tasmota build][9]._

Once finished, disconnect cables and assemble device. Follow the [official documentation][8] from here regarding setting up the device.

### Template

Here is the device template that I used to configure the device:

```text
{"NAME":"Gosund SP111 V","GPIO":[57,255,56,255,132,134,0,0,131,17,0,21,0],"FLAG":0,"BASE":45}
```

## Further reading

- [Gosund SP111 mit Tasmota][0]
- [Tasmota][5]

[0]: https://www.bastelbunker.de/gosund-sp111-mit-tasmota/
[1]: https://github.com/xoseperez/espurna
[2]: https://github.com/ct-Open-Source/tuya-convert
[3]: https://affiliate.malachisoord.com/t/940fc6b7-d20a-46d7-b6bb-2f6bdcaaed7b
[4]: https://affiliate.malachisoord.com/t/cb945e08-9e4f-40d2-8870-23ff9012cad0 
[5]: https://github.com/arendst/Tasmota/
[6]: https://esphome.io/
[7]: https://github.com/espressif/esptool
[8]: https://github.com/arendst/Tasmota/wiki/Initial-Configuration
[9]: https://github.com/arendst/Tasmota/releases
