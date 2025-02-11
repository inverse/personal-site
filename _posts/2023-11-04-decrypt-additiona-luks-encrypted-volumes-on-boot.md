---
layout: post
title: Decrypt additional LUKS encrypted volumes on boot
date: 2023-11-04 11:21 +0100
comments: true
tags:
- linux
- encryption
- luks
---

I recently upgraded to a new PC which has multiple drives that I wanted to encrypt and decrypt these automatically on boot.

My distribution of choice is [EndevourOS][0] as it provides an easy way to get started with an arch based system.

The installer provides a way to easily created a LUKS encrypted drive for the system but I wanted to add additional drives in with the same security.

## Setting up the drive

The first step was to format the drive as `EXT4` and encrypted it using the Gnome disk utility.

## Automating the decryption.

Next would be to add the key file that is being used by the main drive to the additional drive. For me this was as the root of the volume at `/crypto_keyfile.bin`.

This identified this by running `sudo cat /etc/crypttab` and finding the reference to the keyfile.

Adding the key:

```bash
sudo cryptsetup luksAddKey /dev/sda1 /crypto_keyfile.bin
```

Once added I needed to look up the UUID of the drive. This was done using `blkid`.

```bash
malachi@pulsar ~ $ sudo blkid -t TYPE=crypto_LUKS
/dev/nvme0n1p3: UUID="071bdefa-99a5-4fb3-bba6-f579c70c4ffd" TYPE="crypto_LUKS" PARTUUID="f32c0419-7a66-4d1a-a2ed-118041af01ee"
/dev/nvme0n1p2: UUID="fc5d3ddc-9285-4ecc-89c9-94178f929985" TYPE="crypto_LUKS" PARTLABEL="endeavouros" PARTUUID="4b831e27-8df0-427c-bf3d-2bf59879d638"

# New drive
/dev/sda1: UUID="978ed2e3-f056-44a9-91ce-d91576047abe" TYPE="crypto_LUKS" PARTLABEL="Basic data partition" PARTUUID="b87a3f60-abbd-480a-a65d-294d089bf2c5"
```

Next was adding this to `/etc/crypttab` to automate the decryption.

```bash
malachi@pulsar ~ $ sudo cat /etc/crypttab
# /etc/crypttab: mappings for encrypted partitions.
#
# Each mapped device will be created in /dev/mapper, so your /etc/fstab
# should use the /dev/mapper/<name> paths for encrypted devices.
#
# See crypttab(5) for the supported syntax.
#
# NOTE: You need not list your root (/) partition here, but it must be set up
#       beforehand by the initramfs (/etc/mkinitcpio.conf). The same applies
#       to encrypted swap, which should be set up with mkinitcpio-openswap
#       for resume support.
#
# <name>               <device>                         <password> <options>
luks-fc5d3ddc-9285-4ecc-89c9-94178f929985 UUID=fc5d3ddc-9285-4ecc-89c9-94178f929985     /crypto_keyfile.bin luks
luks-071bdefa-99a5-4fb3-bba6-f579c70c4ffd UUID=071bdefa-99a5-4fb3-bba6-f579c70c4ffd     /crypto_keyfile.bin luks

# New drive
luks-978ed2e3-f056-44a9-91ce-d91576047abe UUID=978ed2e3-f056-44a9-91ce-d91576047abe     /crypto_keyfile.bin luks
```

## Mounting the volume

The final step is to mount the now decrypted volume by adding an entry for this in `/etc/fstab`.


```bash
malachi@pulsar ~ $ cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a device; this may
# be used with UUID= as a more robust way to name devices that works even if
# disks are added and removed. See fstab(5).
#
# <file system>             <mount point>  <type>  <options>  <dump>  <pass>
UUID=152E-489E                            /boot/efi      vfat    defaults,noatime 0 2
/dev/mapper/luks-fc5d3ddc-9285-4ecc-89c9-94178f929985 /              btrfs   subvol=/@,defaults,noatime,compress=zstd 0 0
/dev/mapper/luks-fc5d3ddc-9285-4ecc-89c9-94178f929985 /home          btrfs   subvol=/@home,defaults,noatime,compress=zstd 0 0
/dev/mapper/luks-fc5d3ddc-9285-4ecc-89c9-94178f929985 /var/cache     btrfs   subvol=/@cache,defaults,noatime,compress=zstd 0 0
/dev/mapper/luks-fc5d3ddc-9285-4ecc-89c9-94178f929985 /var/log       btrfs   subvol=/@log,defaults,noatime,compress=zstd 0 0
/dev/mapper/luks-071bdefa-99a5-4fb3-bba6-f579c70c4ffd swap           swap    defaults   0 0
tmpfs                                     /tmp           tmpfs   defaults,noatime,mode=1777 0 0

# newly mounted drive
/dev/mapper/luks-978ed2e3-f056-44a9-91ce-d91576047abe  /mnt/stuff ext4    rw,relatime   0    2
```

And that was it, once I rebooted the computer I could see the drive being decrypted and was available at the defined mount point as `/mnt/stuff`.


[0]: https://endeavouros.com/
