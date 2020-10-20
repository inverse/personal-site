---
layout: post
title: Running Wireshark against android
date: 2020-10-20 22:11 +0200
tags:
- linux
- android
- wireshark
---

I recently purchased some [Libratone][0] [Zipp Mini speakers][1] that were on offer and wanted a way to control these through [Home Assistant][2].

Without any public API available I found an awesome [post by Benjamin Hanke][8] documenting his journey on reverse engineering the basic controls for controlling this device.

However I noticed there were some aspects missing such as getting the now playing information which would be useful for supporting this device as a Media Player.

After struggling with a variety of emulators that would not load the application due to missing libraries I looked into an alternative solution which lead me to a [blog post by Martin Sauter][3] involving installing `tcpdump` on your rooted Android device and redirecting the pcap dump to [Wireshark][6] on your laptop.

## Setting up the Android device (rooted)

Install [Termux][4] on your device. Once installed we will need to install [`tcpdump`][5], a tool that allows us to dump traffic from a network. To do this we will first need to install the root repository.

```bash
pkg install root-repo
```laptop
```bash
pkg install tcpdump
```

## On the host

Now from your Linux computer you need to install [Android Debug Bridge (adb)][7] and [Wireshark][8]. Once installed and you have successfully paired your computer with your Android phone through adb, simply run:

```bash
adb exec-out "tcpdump -i any -U -w - 2>/dev/null" | sudo wireshark -k -S -i -
```

This will run tcpdump on the device and return the stream back to the host piping this through to Wireshark.

[0]: https://www.libratone.com/
[1]: https://www.amazon.de/-/en/Libratone-Wireless-Multiroom-Speaker-Standard/dp/B0150DTEK8
[2]: https://www.home-assistant.io/
[3]: https://blog.wirelessmoves.com/2017/02/adb-and-tcpdump-on-android-for-live-wireshark-tracing.html
[4]: https://termux.com/
[5]: https://www.tcpdump.org/manpages/tcpdump.1.html
[6]: https://www.wireshark.org/
[7]: https://developer.android.com/studio/command-line/adb
[8]: https://benjaminhanke.de/baublog/technik/libratone-zipp-wlan-lautsprecher-in-loxone-einbinden/
