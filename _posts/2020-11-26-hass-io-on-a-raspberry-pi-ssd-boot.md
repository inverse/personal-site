---
layout: post
title: Hass.io on a Raspberry Pi with USB SSD Boot
date: 2020-11-26 22:08 +0100
comments: true
tags:
- home-assistant
- raspberry-pi
- self-hosted
---

My Home Assistant setup recently died due to the SDCard finally giving up after 3 years of continual use. Thankfully I had a relatively recent snapshot of my setup so getting up and running again was mostly painless. However this time I invested in an SSD and converting my setup to boot from that.

## Equipment needed

- [Raspberry PI 3][4]
- [SSD][5]
- [SATA to USB adaptor][6]
- [SDCard][7] (for enabling USB boot)

### Create snapshot (for existing setups)

First take a snapshot from the UI. Follow [SuburbanNerd's guide][3] for more information on this topic.

### Getting the PI ready for USB Boot

Changing PI to boot from USB uses one-time programmable (OTP) memory. Once this bit has been set, you cannot unset it. That being said you can still boot from an SDCard, it just opens up the possibility to boot from USB devices too.

Following the steps from [Stefan][0] on the [Home Assistant forums][1] the process is relatively straight forward.

First download and install [Raspberry PI OS][8] onto an SDCard using a tool such as [balena etcher][2]. Once flashed, place the SDCard into the PI and power it on.

_Note: if your Pi is running in headless mode, make sure to create file called `ssh` within the `/boot` partition of the install._

Now lets enable the PI for USB boot, Opening up a terminal or via SSH (user: `pi`, password: `raspberry`).

```bash
echo program_usb_boot_mode=1 | sudo tee -a /boot/config.txt
```

Next, reboot.

```bash
sudo reboot
```

Once booted, connect back in and check if the OTP has been programmed correctly.

```bash
vcgencmd otp_dump | grep 17:
```

It should output something like `17: 3020000` indicating this was successful.

## Prepare the SSD

Download the latest compatible Hass.io install for your device.

Connect the SSD to the SATA to USB adaptor and connect this to your PC.

Use a tool such as [balena etcher][2] to flash the Hass.io install to the SSD.

Once flashed, disconnect and connect this to the PI, ensuring that the SDCard is removed.

Power on the PI and wait for it to boot.

Once booted it should be accessible from the network through `https://homeassistant.local:8123`.

After Home Assistant has been installed you will be greeted by a screen prompting you to setup.

If you are coming from an existing install you will be able to provide the snapshot downloaded in an earlier step. Finally now wait for the device to reload your existing configuration. This can take a while to do, for me I noticed it took around 20 minutes to restore the device to it's previous state.

[0]: https://community.home-assistant.io/t/usb-boot-on-raspberry-pi-3/20358/129
[1]: https://community.home-assistant.io/
[2]: https://www.balena.io/etcher/
[3]: https://suburbannerd.com/hassiobackup/
[4]: https://www.amazon.com/exec/obidos/ASIN/B07P4LSDYV/hexagon014-20/
[5]: https://www.amazon.com/exec/obidos/ASIN/B07G3YNLJB/hexagon014-20/
[6]: https://www.amazon.com/exec/obidos/ASIN/B07S9CKV7X/hexagon014-20/
[7]: https://www.amazon.com/exec/obidos/ASIN/B073JYVKNX/hexagon014-20/
[8]: https://www.raspberrypi.org/software/operating-systems/
