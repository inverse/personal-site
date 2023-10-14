---
layout: post
title: "Flashing custom firmware with Tuya-Convert"
date: 2020-05-23 22:06 +0200
comments: true
tags:
- home-automation
- smart-plug
---

In a previous post titled [Flashing custom firmware on Gosund SP111 devices]({% post_url 2019-11-24-flashing-custom-firmware-on-a-gosund-sp111 %}) I wrote about how I achieved this by connecting the device to a serial connection.

Having purchased what I believed to be the same product turned out to be the lower rated 2300W and look slightly older generation from the PCB which  made it more difficult to flash without soldering due to only having solder pads.

This lead me to try using [Tuya-Convert][0], a firmware replacement solution that does not even require you to disassemble your smart device.

While their repo describes how you can achieve this using a docker based solution I didn't have much luck with the in-built WiFi adaptor on my laptop so opted for the Raspberry PI based approach since I had a spare one laying around.

## Requirements

- [Raspberry PI 3B+][1]
- [micro SDCard][2]
- [Gosund SP111][3]
- Another device with WiFi, e.g.Wi your phone, or laptop

## Setup

### Setting up the OS

Flash [Rasbian][4] onto the micro SDCard using [balena etcher][8] connect your PI and wait for it to boot.

Once booted you will need to setup WiFi on your device. Follow the [official instructions][5] on how to do this.

Next install `git` to enable you clone the repo down easily.

```bash
sudo apt update
sudo apt install git
```

### Setting up Tuya-Convert

To avoid having to deal with SSH keys on your PI it's simply enough to just clone the repo down over HTTPS.

```bash
git clone https://github.com/ct-Open-Source/tuya-convert.git
cd tuya-convert
./install_prereq.sh
```

### Flashing the device

Tuya-Convert comes packages with [Tasmota][6] or [Espurna][7] but you can also use a different firmware which is explained during the flashing process.

 To get going, start the flashing script:

```bash
./start_flash.sh
```

Follow the on screen instructions be sure to put your device into pairing mode at the start of the process.

### After flashing

I opted to flash my device with Tasmota, which I then flashed the latest standard binary from their release page on Github via the web interface. The reason being that the bundled one is the minimal one and doesn't come with all the support for all the sensors.

#### Tasmota Template

Once flashed I changed the template to configure the GPIO pins correctly to enable me to use the device properly:

```text
{"NAME":"Gosund SP111 V","GPIO":[57,255,56,255,132,134,0,0,131,17,0,21,0],"FLAG":0,"BASE":45}
```

[0]: https://github.com/ct-Open-Source/tuya-convert
[1]: https://www.amazon.com/exec/obidos/ASIN/B07P4LSDYV/hexagon014-20/
[2]: https://www.amazon.com/exec/obidos/ASIN/B073JYVKNX/hexagon014-20/
[3]: https://www.amazon.de/exec/obidos/ASIN/B0054PSES6/hexagon05-21/
[4]: https://www.raspberrypi.org/downloads/raspbian/
[5]: https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md
[6]: https://tasmota.github.io/docs/
[7]: https://github.com/xoseperez/espurna
[8]: https://www.balena.io/etcher/
