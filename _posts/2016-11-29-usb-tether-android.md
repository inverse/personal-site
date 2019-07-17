---
layout: post
title: USB tether Android device
comments: true
tags:
  - linux
  - android
  - usb
  - tips
---

I've been playing around with some linux live distributions recently but the main problem I had was the inability to have network support with the majority of them due to my WiFi broadcom chip not being supported out of the box. 

Thankfully I found that USB tethering via an Android device worked flawlessly and I was able to get online. To set this up first connect your device via a USB cable and on the device go to:


```
Settings > Wireless & Networks > More > Tethering & portable hotspot > Other
```

And check the `Android tether` option.

![Android tethering options](/assets/img/posts/android-tether-1.png)

Once enabled you should be online.

## Notes

Asuming your device is connected to WiFi this connection will be used. Otherwise your cellular network will be used so _be warned_.

## Futher reading

- [Android Tethering - Arch Linux Wiki][0]

[0]:https://wiki.archlinux.org/index.php/android_tethering