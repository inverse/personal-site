---
layout: post
title: Running Wireshark against android
date: 2020-10-20 22:11 +0200
comments: true
tags:
- linux
- android
- wireshark
---

I recently purchased some [Libratone][0] [Zipp Mini speakers][1] that were on offer and wanted a way to control these through [Home Assistant][2].

Without any public API available I found an awesome [post by Benjamin Hanke][8] documenting his journey on reverse engineering the basic controls for controlling this device.

However I noticed there were some aspects missing such as getting the now playing information which would be useful for supporting this device as a Media Player.

After struggling with a variety of emulators that would not load the application due to missing libraries I looked into an alternative solution which lead me to a [blog post by Martin Sauter][3] involving installing [`tcpdump`][5] on your rooted Android device and redirecting the pcap dump to [Wireshark][6] on your laptop.

## Setting up the Android device (rooted)

My device is running LinageOS 17.1 and is rooted allowing me to run applications that require root permissions such as tcpdump.

First you must enable [developer options][4] on your device.

Once enabled enable both "Android Debugging" and "Rooted debugging" from the developer options.

## On the host

Now from your Linux computer you need to install [Android Debug Bridge (adb)][7] and [Wireshark][8]. Once installed you will now need to pair your phone:

```bash
sudo adb devices
```

_Note: you must accept the debug request from your device_

Next lets enable adb in root mode:

```bash
adb root
```

Finally lets shell into the device and check if tcpdump is installed.

```bash
adb shell
which tcpdump # should return something like /system/bin/tcpdump
```

For my custom firmware it looks like it came bundled with it. If this does not return a path to tcpdump then you will need to install this on your device. You have have luck following [this guide][9].

If tcpdump is now found all that's left is to run the following:

```bash
adb exec-out "tcpdump -i any -U -w - 2>/dev/null" | sudo wireshark -k -S -i -
```

This will run tcpdump on the device and return the stream back to the host piping this through to Wireshark.

![Wireshark](/assets/img/posts/running-wireshark-against-android/wireshark.png)

From here you can now inspect all the traffic happening on the device which can be quite noisy. To make it easier to find only the communication between your Android device and the Libratone you can Use an IP filter.

Which in my case is running on `192.168.1.131` and can be applied on the top bar like:

```text
ip.addr == 192.168.1.131
```

That's it for now. I will update with more once I have figured out what network calls are relevant!

[0]: https://www.libratone.com/
[1]: https://www.amazon.com/exec/obidos/ASIN/B072BRZFCY/hexagon014-20/
[2]: https://www.home-assistant.io/
[3]: https://blog.wirelessmoves.com/2017/02/adb-and-tcpdump-on-android-for-live-wireshark-tracing.html
[4]: https://developer.android.com/studio/debug/dev-options
[5]: https://www.tcpdump.org/manpages/tcpdump.1.html
[6]: https://www.wireshark.org/
[7]: https://developer.android.com/studio/command-line/adb
[8]: https://benjaminhanke.de/baublog/technik/libratone-zipp-wlan-lautsprecher-in-loxone-einbinden/
[9]: https://www.andreafortuna.org/2018/05/28/how-to-install-and-run-tcpdump-on-android-devices/
