---
layout: post
title: Custom ROMs on a Xiaomi Redmi Note 10 Pro
date: 2021-09-13 21:55 +0200
comments: true
tags:
- android
- arrowos
- custom-roms
- gcam
---

I was an avid user of custom ROMs for my Android phones when vendors used to stop providing updates or included too much bloat with their releases.  However that stopped when I got a Moto X4 which was for me the right balance and it performed well.

Recently I upgraded to a [Xiaomi Redmi Note 10 Pro][9] due to the amazing price for the specifications it detailed and it didn't fail to deliver. However, I found using MIUI an issue, while it was fluid and performant I found it too bloated and there were UI quirks with some applications which were frustrating.

This lead me to take the plunge back into the scene to see how I could go about installing Custom ROMs which lead me back to [XDA][0], and after some research [posting this][1]. I got a really helpful answer directing my to the [Pixel Experience Wiki page][2] explaining how to get into an unlocked state.

The process was fairly simple although required waiting a significant amount of time for the device to be able to be unlocked, presumably to deter people from doing so.

After unlocking the bootloader I found a site explaining [how to flash TWRP][4], an Android recovery I was familiar with. Once flashed I downloaded the latest version of [ArrowOS][3] for sweet with GAPPS and that was it, finally on a zero bloat, minimal ASOP ROM for this amazing device.

## Improving the camera experience

The Stock camera experience for ArrowOS was less than ideal and looked for a better solution. I knew there were several options available. Including:

- [Gcam Mod][8] - Modification of the well known Google Camera for other ROMs
- [ANXCamera][7] - Port of the MIUI camera for ASOP based roms

I went with a GCam mod and configuration from [a thread][5] on Reddit from [mastorofpuppies][6] who also detailed their whole experience migrating.

<!-- Write up about tasker -->

<!-- Write about battery improvements -->

## Closing thoughts

I've been using this ROM for over 6 weeks and it's been amazing once I ironed out the problems I had above. The performance is solid and the battery is as good as on stock.

## Further reading

- [XDA - Redmi Note 10 Pro][0]

[0]: https://forum.xda-developers.com/f/redmi-note-10-pro.12117/
[1]: https://forum.xda-developers.com/t/help-getting-started-again.4312039/#post-85435347
[2]: https://wiki.pixelexperience.org/devices/sweet/install/
[3]: https://arrowos.net/download/sweet
[4]: https://www.getdroidtips.com/twrp-recovery-redmi-note-10-pro/
[5]: https://www.reddit.com/r/Xiaomi/comments/ottb85/just_flashed_arrowos_on_my_new_redmi_note_10_pro/h74c0kw/?utm_source=reddit&utm_medium=web2x&context=3
[6]: https://www.reddit.com/user/mastorofpuppies/
[7]: https://camera.aeonax.com/
[8]: https://www.celsoazevedo.com/files/android/google-camera/
[9]: https://affiliate.malachisoord.com/t/a10437df-15cc-417e-b0dc-6d8342262737
