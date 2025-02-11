---
layout: post
title: Graceful OLED TV shutdown automation
date: 2025-02-11 20:30 +0100
comments: true
tags:
tags:
- home-automation
- home-assistant
---

A while back we upgraded our TV to a Philips OLED Ambilight model similar to the [Philips Ambilight 55OLED759](https://www.amazon.com/exec/obidos/ASIN/B0D3VM2HGM/hexagon014-20/). The difference going from LED to OLED was impressive but there is a software feature that soon became rather annoying in that the TV would from time to time prompt you to let it refresh itself to improve the life of the OLED display.

It was only recently when my father visited and told me how he resolved this behaviour on his OLED TV with automation that put the TV into standby for 10 minutes before switching off the smart plug.

Since my setup with similar I went about adding this behaviour to the existing shutdown script that get invokes each evening which consisted of modifying it to perform this action:

```yaml
all_off:
  sequence:
    ...
    - action: media_player.turn_off
      target:
        entity_id:
          - media_player.philips_tv
    - delay:
        hours: 0
        minutes: 10
        seconds: 0
        milliseconds: 0
    - action: switch.turn_off
      target:
        entity_id:
          - switch.media
```

Since adding this logic the TV hasn't prompted to refresh itself.
