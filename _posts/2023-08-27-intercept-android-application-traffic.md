---
layout: post
title: Intercept Android application traffic
date: 2023-08-27 20:58 +0200
comments: true
tags:
- android
- mitm
- traffic
---

It's been a while since I've had the need to intercept traffic from an Android when things were a lot less secure and you could just use a tool such as [Charles Proxy][0] as a proxy between your device.

Unless you're debugging your own application in which you can modify your applications trust anchors to allow user signed certificates it can be problematic. There are tools such as [apk-mitm][3] but I didn't have much luck with using it and the patched application kept crashing on my device.

# Solution

The solution I went with was to use [HTTP Toolkit][1] with an Android Virtual Device setup using Android Studio.

> Make sure the version being run is below Android 14 as there are some significant security changes made in this version.

Once the AVD was running I used [rootAVD][4] to root the device in order to allow applications to use the user generated certificates.

After the AVD rebooted I opened up HTTP Toolkit and hit the Android device via ADB which automated setting up the Android application and installing the certificates into the system directory. Just make sure you click allow on [Magisk][5] for root permissions.

# Further Reading

- [Intercepting Android HTTPS][3]


[0]: https://www.charlesproxy.com/
[1]: https://httptoolkit.com/
[2]: https://httptoolkit.com/blog/intercepting-android-https/
[3]: https://github.com/shroudedcode/apk-mitm
[4]: https://github.com/newbit1/rootAVD
[5]: https://github.com/topjohnwu/Magisk
