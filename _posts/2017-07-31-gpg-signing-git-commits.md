---
layout: post
title: GPG signing git commits
comments: true
tags:
  - linux
  - ubuntu
  - gpg
  - security
---

GNU Privacy Guard (GnuPG or GPG) is the free and open source implementation of the [OpenPGP protocol][3], that allows you to encrypt and sign your data and communication.

In the context of git, this allows users to verify that data is coming from a trusted source.

This article will cover how to setup GPG and configure it to sign your git commits.

## Generating your own GPG key

Keys can be generated either from the command line or by leveraging GUI applications.

The command line tool for GPG should come installed by default on Ubuntu. However if it's not provided you should be able to install it by running:

`sudo apt install gnupg`

To generate a key run the below command and follow the on screen instructions.

`gpg --gen-key`

Like with SSH keys it's recommended to use a passphrase to add an extra layer of security.

Once setup you can list the keys registered.

`gpg --list-keys`

If you want to modify an existing key run

`gpg --edit-key <id>`

where `<id>` is replace with your ID that is displayed after key creation creation or when calling the list command.

### Useful tools

- [Seahorse][5] - GNOME application for managing encryption keys
- [GNU Privacy Assistant (GPA)][6] - GUI for the GnuPG
- [OpenPGP Applet][7] - GNOME application for easy signing/decrypting messages
- [Mailvelope][8] - Chrome extension for signing/decrypting emails

## Usage within git

To configure commit signing on a single commit provide the `-S` flag. e.g.

`git commit -S -m 'Your message here'`

Alternatively this can either be configured on an repository level by

`git config commit.gpgsign true`

or globally by running

`git config --global commit.gpgsign true`

## Further reading

- [The GNU Privacy Guard (Official Site)][2]
- [Signing commits using GPG by Github][0]
- [Signing Your Work by Git tools][1]
- [GnuPrivacyGuardHowto][4]

[0]: https://help.github.com/articles/signing-commits-using-gpg/
[1]: https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
[2]: https://gnupg.org/
[3]: https://www.ietf.org/rfc/rfc4880.txt
[4]: https://help.ubuntu.com/community/GnuPrivacyGuardHowto
[5]: https://wiki.gnome.org/Apps/Seahorse/
[6]: https://www.gnupg.org/related_software/gpa/
[7]: https://openpgp-applet.alioth.debian.org/web/
[8]: https://chrome.google.com/webstore/detail/mailvelope/kajibbejlbohfaggdiogboambcijhkke?hl=en

