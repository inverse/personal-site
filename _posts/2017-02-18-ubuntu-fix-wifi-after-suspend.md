---
layout: post
title: Ubuntu Wifi fix after suspend
comments: true
tags:
- linux
- ubuntu
- dell-xps-15
- wifi
---

I'm running a fresh install Ubuntu Gnome 16.10 on my XPS 15 and I noticed that whenever I put the laptop in suspend I was unable to connect to my WiFi network upon resume.

Looking online it appears that I am not alone with this [problem][0]. Following the discussion found that restarting the network-manager service fixed this.

`sudo systemctl restart network-manager.service`

You can automate this by creating a new systemd service which calls this whenever coming out of suspend, hibernate, or hybrid sleep.

First create the new service by `sudo nano /etc/systemd/system/wifi-resume.service` and pasting the following content:

```bash
[Unit]
Description=Restart NetworkManager at resume
After=suspend.target
After=hibernate.target
After=hybrid-sleep.target

[Service]
ExecStart=/bin/systemctl --no-block restart network-manager.service

[Install]
WantedBy=suspend.target
WantedBy=hibernate.target
WantedBy=hybrid-sleep.target
```
_Credit go to the authors of the replies on [ask ubuntu thread][0]._

Save and exit nano and then enable the new systemd service:

`sudo systemctl enable wifi-resume.service`

You can subsitute `enable` with `disable` to turn off the service and then remove the file if you find it's not working as expected.

## Further reading

- [Systemd Wikipedia entry][1]
- [Understanding and using systemd][2]

[0]: http://askubuntu.com/questions/761180/wifi-doesnt-work-after-suspend-after-16-04-upgrade
[1]: https://en.wikipedia.org/wiki/Systemd
[2]: https://www.linux.com/learn/understanding-and-using-systemd
