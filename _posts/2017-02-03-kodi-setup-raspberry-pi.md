---
layout: post
title: Kodi setup Raspberry Pi
comments: true
tags:
  - kodi
  - linux
  - raspberry-pi
---

[Kodi][0] is an open source peice of software designed to provide a media center experience for your video, music, pictures, and applications. It runs of many different platforms including, Linux, OS X, Windows, and Android.

This article will cover my experience setting up a media center like experience, specifically using the [OSMC][1] pre-built distribution.

# Requirements

- Raspberry PI 2+
- Micro SDCard
- HDMI cable
- A HDMI compatible TV
- USB keyboard

# Kodi flavours

There are a few pre-made distributions designed to run on the Raspberry PI including:

- [OSMC][1]
- [OpenELEC][2]
- [LibreELEC][3]

However you could always opt to set things up on the distribution of your choice by compiling from source or using one of the pre-built Kodi [binaries][11].

# Installing

1. First download the latest available [disk image version][5] of OSMC for your PI version.
2. Once downloaded extract the gz file using your favourite unarchiver.
3. Next write the img to your SDCard. The official Raspberry Pi site [covers this well][6].
4. Connect power adaptor, HDMI cable, freshly imaged SDCard into the Pi and wait for the first boot to finish.
5. And that's it :)

# Setting things up

## Internet connectivity

The first thing you will want to do is configure the network of the device. If you are connecting via Ethernet you can skip this step as it _should_ be already configured but for WiFI connectivity, or additional network configurations you will want to navigate to the "My OSMC" settings screen. For detailed instructions on this visit the [dedicated wiki][7].

## Remotes

Kodi is designed to be operated without a keyboard and there are many ways to interact with it.

Firstly, if you are connected to a TV which supports HDMI CEC you should be able to use your TV's remote to navigate. You may need to enable this on your device, check with your manufacturer manual for instructions.

Also there are many Kodi remotes available for Android. The two I have experience with are:

- [Yatse][8]
- [Kore][9] (Offical Kodi app)

Both are pretty feature rich, however Yatse feels more intuitive and provides some additional functionality such as local media playback. But this requires the paid in app purchase.

# Further reading

- [OSMC Raspberry Pi FAQ][4]
- [Kodi Wiki][12]

[0]: https://kodi.tv/
[1]: https://osmc.tv/
[2]: https://openelec.tv/
[3]: https://libreelec.tv/
[4]: https://osmc.tv/wiki/raspberry-pi/frequently-asked-questions/
[5]: https://osmc.tv/download/
[6]: https://www.raspberrypi.org/documentation/installation/installing-images/
[7]: https://osmc.tv/wiki/general/setting-up-your-network-connection/
[8]: https://play.google.com/store/apps/details?id=org.leetzone.android.yatsewidgetfree
[9]: https://play.google.com/store/apps/details?id=org.xbmc.kore
[10]: https://en.wikipedia.org/wiki/Consumer_Electronics_Control
[11]: https://kodi.tv/download/
[12]: https://kodi.wiki/
