---
layout: post
title: Sideloading Android Apps on ChromeOS
date: 2020-07-20 22:20 +0200
comments: true
tags:
- android
- chromeos
---

I recently purchased my wife a [Lenovo IdeaPad Duet Chromebook][0] as a replacement for her aging Dell laptop. Since she mainly using her laptop for surfing and light tasks it was a good choice from the reviews I read and at that price point.

ChromeOS in it self is awesome and having full Play Store eco system at your fingers is great but I wanted to install some apps from [F-Droid][2] which lead me to search for a solution to sideload apps.

Lots of the articles I read pointed to enabling developer mode which is something I didn't want to do because it requires resetting the device to factory default and it has the potential to void your warranty.

This lead me to find a solution that didn't involve doing this.

## Requirements

- [Lenovo IdeaPad Duet Chromebook][0]

## Steps

### Setup Linux (Beta)

From the settings navigate to the "Linux (Beta)" section and install

For more information on how to do this consult the [official documentation][3]

### Enable ADB

Once the linux subsystem has been installed on your device navigate to the "Linux (Beta)" section again in the options.

Then > "Develop Android apps" and click "Enable ADB debugging"

More information on this process can be found on the [Support documentation][4].

Once you have enabled this and the device has rebooted you're ready for the next step.

### Setting up ADB on Linux

Open up the Linux terminal app and run the following commands to install [ADB][5] to allow you to interact with the Android subsystem.

```bash
sudo apt update
sudp apt install adb
```

Then copy the downloaded APK files from your download directory to the Linux folder using the Files application.

Once copied installing applications is as simple as running

```bash
adb install <my-apk.apk>
```

## Further reading

- [Android Police - Sideloading without developer mode][1]

[0]: https://affiliate.malachisoord.com/t/2d8e02d6-7715-4970-b379-cb7261a359a7
[1]: https://www.androidpolice.com/2019/12/26/chrome-os-80-adds-ability-to-sideload-android-apps-without-developer-mode-but-doesnt-make-it-easy/
[2]: https://www.f-droid.org/
[3]: https://support.google.com/chromebook/answer/9145439?hl=en
[4]: https://support.google.com/chromebook/answer/9770692?hl=en
[5]: https://developer.android.com/studio/command-line/adb
