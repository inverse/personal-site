---
layout: post
title: Reverse engineering IOLITE remote API
date: 2020-08-06 22:07 +0200
comments: true
tags:
- android
- reverse-engineering
- smart-home
---

Our landlords installed a smart heating system into our apartment around 2 years ago. Consisting of a wall mounted tablet and some RF controlled radiator valves to allow us to control these on a schedule or via the control panel in the hall.

![Tablet](/assets/img/posts/reverse-iolite/tablet.png)

![Radiator valve](/assets/img/posts/reverse-iolite/valve.png)

The company which provides both the hardware and software is a company based in Berlin called [IOLITE][0]. They provide smart home equipment for these sorts of residential setups.

Around 6 months ago the device updated and the ability to control the platform through Android own device became available. The App is called Meine intelligente Assistenz or MIA and is available through the [play store][2].

This immediately got me excited as it opened up the possibility to reverse engineer the application and let me hack on the software to and provide a client library of sorts in an attempt integrate with our [Home Assistant][0] based smart home stack.

## Pulling the APK from your device

You will need to install the [Android Debug Bridge (ADB) toolchain][3] on your computer to do this. Once installed you'll need to run the following commands from your shell.

```bash
# Get the path to the apk on your device
adb shell pm path de.iolite.client.android.mia

# Pull the apk to your host
adb pull /data/app/de.iolite.client.android.mia-2.apk /path/to/save/to/mia.apk
```

## Decompiling the apk

Once pulled we need to now convert the APK into another format to understand. While there are tools such as [apktool][7] that convert the APK into smali I find it easier to look at Java so opted for [dex2jar][4]. A tool that converts an APK into a jar file.

```bash
sh d2j-dex2jar.sh -f mia.apk # outputs mia.jar
```

## Reading the jar

You can then view the jar in a tool such as [JD-GUI][6] which allows you to navigate the class structure and to try and make sense of the logic inside.

![JD GUI mia.apk](/assets/img/posts/reverse-iolite/jd-gui.png)

From here I was able to reverse engineer the OAuth flow and figure out how to authenticate with IOLITE's remote API allowing me to gain access to the web view that the Android app presented.

## Reversing the Web UI

This allowed me then to view the source of the application which was written in React and leveraged web-sockets to communicate to the backend API.

From here I was able to figure out the models that were used and the payloads to send thanks to the rich developer toolkit that Chrome provides.

![Chrome debugging](/assets/img/posts/reverse-iolite/chrome-debug.png)

## Python IOLITE client

Since Home Assistant is written in Python I took it upon myself to write a client in Python.

It's not a full client library but but available on [Github][8]. The OAuth communication with token refreshing is in place. Along with basic models for communication and simple interactions.

Along with this I also started building a [Home Assistant integration][9] to make use of the client. Its very rough around the edges but it does intergrate the valves into home assistant.

Feel free to contribute :)

## Further reading

- [Converting apk to jar][5]

[0]: https://iolite.de/en/
[1]: https://www.home-assistant.io/
[2]: https://play.google.com/store/apps/details?id=de.iolite.client.android.mia&hl=en
[3]: https://developer.android.com/studio/command-line/adb
[4]: https://github.com/pxb1988/dex2jar
[5]: https://stackoverflow.com/questions/9812896/converting-apk-to-jar
[6]: https://java-decompiler.github.io/
[7]: https://ibotpeaches.github.io/Apktool/
[8]: https://github.com/inverse/python-iolite-client
[9]: https://github.com/inverse/home-assistant-iolite-component
