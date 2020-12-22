---
layout: post
title: Replacing our NAS
date: 2020-12-21 22:51 +0100
comments: true
tags:
- nas
- home-server
- self-hosted
---

A couple of months ago our old single drive [WD My Cloud Home][0] NAS died. The HDD failed and even shucking the device and trying to connect with a SATA adaptor failed to read the drive. Thankfully nothing important was lost as that was all backed up off site.

This lead to to searching for a replacement device which had more redundancy built into avoid such situations. I ultimately ended up purchasing a [Synology DS218][1] as it featured 2 drives and enough compute power to be future proof if I ever decided to self host some other applications along side.

## Choosing the right drives

When building a NAS you need to think about the types of drives that will be used. Considering the device will be more often then not powered most of the time you should look into getting some NAS grade drives. Synology provides such [compatibility][2] listings for it's products.

At first I purchased some [8 TB Ironwolf Pro][3] drives which once installed it was immediately apparent they were not suitable for our setup considering the NAS is situated in the living room. They were extremely loud and made clicking noises each few seconds which was reminiscent of HDD tech from the early 2000s.

After lots of researching I ultimately decided to try some [6TB WD Red Plus (WD60EFRX)][4] drives as lots of people were reporting relatively silent operation and this was what was in the WD My Cloud which was super quiet.

Just be careful to check the model which you have purchased as WD also sell NAS grade drives which use SMR technology compared to the more commonly used CMR technology. With WD SMR technology [reportedly][6] being very sub-par for a NAS setup.

An easy way to identify this from what i've researched is through the product numbers

| Technology   | Model |
|--------|-------------|
| CMR    | WDXXEFRX    |
| SMR    | WDXXEFAX    |

Where XX specifies the size of the drive which in my case was 60 indicating 6TB.

## Further reading

- [CMR vs SMR][5]

[0]: https://affiliate.malachisoord.com/t/053a2e24-0881-4e08-a4ec-3dba2cb16adf
[1]: https://affiliate.malachisoord.com/t/3a822a2d-cffe-45b3-b686-52c763267609
[2]: https://www.synology.com/en-global/compatibility
[3]: https://affiliate.malachisoord.com/t/c0cc9bd4-43f6-46b7-a611-2723454eacd1
[4]: https://affiliate.malachisoord.com/t/18b9168b-e1bd-45de-992c-29971aa8a5c6
[5]: https://www.buffalotech.com/blog/cmr-vs-smr-hard-drives-in-network-attached-storage-nas
[6]: https://arstechnica.com/gadgets/2020/06/western-digitals-smr-disks-arent-great-but-theyre-not-garbage/
