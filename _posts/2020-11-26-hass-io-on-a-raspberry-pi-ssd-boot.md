---
layout: post
title: Hass.io on a Raspberry Pi SSD Boot
date: 2020-11-26 22:08 +0100
tags:
- home-assistant
- pi
---

My Home Assistant setup recently died due to the SDCard finally giving up after 3 years of continual use. Thankfully I had a relatively recent snapshot of my setup so getting up and running again was mostly painless. However this time I invested in an SSD and converting my setup to boot from that.

## Equipment needed

- [Raspberry PI3][4]
- [SSD][5]
- [SATA to USB adaptor][6]
- [SDCard][7] (for enabling USB boot)

### Create snapshot (for existing setups)

First take a snapshot from the UI. Follow [SuburbanNerd's guide][3] on this topic.

### Getting the PI ready for USB Boot

Following the guide from [Stefan][0] on the [Home Assistant forums][1] the steps were relatively straight forward.

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

Use a tool such as [balena etcher][2] to flash the hass.io install to the SSD.

Once flashed, disconnect and connect this to the PI, ensuring that the SDCard is removed.

Power on the PI and wait for it to boot.

Once booted it should be accessible from the network through `http://homeassistant.local:8123`.

After home assistant has been installed you will be greeted by a screen prompting you to setup.

If you are coming from an existing install you will be able to provide the snapshot downloaded in an earlier step. Finally now wait for the device to reload your existing configuration. This can take a while to do, for me I noticed it took around 20 minutes to restore the device to it's previous state.

[0]: https://community.home-assistant.io/t/usb-boot-on-raspberry-pi-3/20358/129
[1]: https://community.home-assistant.io/
[2]: https://www.balena.io/etcher/
[3]: https://suburbannerd.com/hassiobackup/
[4]: https://affiliate.malachisoord.com/t/c373281f-2a9e-42af-bc1e-db0f01ae12b1
[5]: https://affiliate.malachisoord.com/t/2eef12ce-e94f-450a-a475-e7db6be7806a
[6]: https://affiliate.malachisoord.com/t/bd3ee124-3a2c-4ce0-a6d6-9537aa0fa1e0
[7]: https://affiliate.malachisoord.com/t/27d86c77-e3e8-4e21-abc9-2be97e2003b4
[8]: https://www.raspberrypi.org/software/operating-systems/
