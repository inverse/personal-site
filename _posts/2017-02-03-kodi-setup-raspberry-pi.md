---
layout: post
title: Kodi setup Raspberry Pi
comments: true
tags:
  - Kodi
  - Media
  - Linux
---

[Kodi][0] is an open source peice of software designed for providing you with a media center experience for your video, music, pictures, amoungst other things. 

It runs of many different platforms including, Linux, OS X, Windows, and Android.

This article will cover my experience with setting it up on a Raspberry PI, specifically using the [OSMC][1] pre-built distribution. 

# Requirements

- Raspberry PI 2+ (however will run on 1, but performance would be limited)
- Micro SDCard
- 2a USB adaptor (or powered USB po)
- HDMI cable
- A HDMI compatible display
- USB keyboard

# Versions

There are a few pre-made distributions designed to run on the Raspberry PI and other hardware including:

- [OSMC][1]
- [OpenELEC][2]
- [LibreELEC][3]

However you could always opt to set things up on the distribution of your choice by compiling from source or using one of the pre-built Kodi binaries.

# Installing

1. First download the latest available [disk image version][5] of OSMC for the Pi. 
2. Once downloaded extract the gz file using your favourite unarchiver. 
3. Next write the img to your SDCard. The official Raspberry Pi site [covers this well][6].
4. Connect power adaptor, HDMI cable, freshly imaged SDCard into the Pi and wait for boot. And that's it.

# Setting things up

The first thing you will want to do is configure the network of the device. If you are connecting via Ethernet you can skip this step as it _should_ be already configured but for WiFI connectivity, or additional network configurations you will want to navigate to the "My OSMC" settings screen. For detailed instructions on this visit the [dedicated wiki][7].

# Remotes

Kodi is designed to be operated without a keyboard and there are many other ways to interact with it.

Firstly, if you are connected to a TV which supports HDMI CEC you should be able to use your remote to navigate. You may need to enable this on your device, check with your manufacturer manual for instructions.

There are many Kodi remotes available for Android. However the two I have experience with are:

- [Yatse][8]
- [Kore][9] (Offical Kodi app)

Both are pretty feature rich, however Yatse feels more intuitive and provides some additional functionality such as local media playback. However this requires the paid unlock.

# Further Reading

- [OSMC Raspberry Pi FAQ][4]

[0]: https://kodi.tv/
[1]: https://osmc.tv/
[2]: http://openelec.tv/
[3]: https://libreelec.tv/
[4]: https://osmc.tv/wiki/raspberry-pi/frequently-asked-questions/
[5]: https://osmc.tv/download/
[6]: https://www.raspberrypi.org/documentation/installation/installing-images/
[7]: https://osmc.tv/wiki/general/setting-up-your-network-connection/
[8]: https://play.google.com/store/apps/details?id=org.leetzone.android.yatsewidgetfree
[9]: https://play.google.com/store/apps/details?id=org.xbmc.kore
[10]: https://en.wikipedia.org/wiki/Consumer_Electronics_Control