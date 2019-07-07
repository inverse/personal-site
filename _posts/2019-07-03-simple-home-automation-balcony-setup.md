---
layout: post
title: Simple home automation balcony setup
comments: true
tags:
- home-automation
- balcony
date: 2019-07-03 22:20 +0200
---
I've been getting into some home automation for our apartment for a while ever since my father got us an Amazon Alexa device to call home with. Since then we expanded our setup to include smart plugs, and Philips Hue lighting. While on their own these produces can work well on their own. 

The real power comes when leveraging a product such as [Home Assistant][0] to bring it all together into a unified platform and more control.

One thing we recently introduced in our setup was to include a very simple balcony watering system that can be controlled remotely and automated via timers and other triggers.

This post documents the equipment required outside of the standard Home Assistant setup and the configuration required to get going.

# Parts

- [Drip irrigation kit](https://www.amazon.de/exec/obidos/ASIN/B07H3LCB52/hexagon05-21/)
- [12V adaptor](https://www.amazon.de/exec/obidos/ASIN/B019IHQND8/hexagon05-21/)
- [Pump](https://www.amazon.de/exec/obidos/ASIN/B07L89V1N6/hexagon05-21/)
- [Smart plug](https://www.amazon.de/exec/obidos/ASIN/B07D5V139R/hexagon05-21/)
- [Water container](https://www.amazon.de/exec/obidos/ASIN/B001QEQZCQ/hexagon05-21/)
- [Hose adaptor](https://www.amazon.de/exec/obidos/ASIN/B007L37976/hexagon05-21/)

# Setup

The setup with these components was straight forward, with the components pretty much connecting and screwing together and just working.

The only complicated thing was flashing custom firmware onto the smart plug as I wanted to have a purely offline setup. I went with [espurna][3] for this but you could also try [esphome][4] which provides a nice API and easy YAML configuration.

## Home Assistant configuration

The automation currently consists of 3 parts.

- A daily watering schedule which is triggered based on the time
- Secondary schedule, triggered by time and temperature forecast
- Manual invocation and automatic off after defined duration

For the first one I also decided to use [Push Bullet][2] to notify my devices when it was triggered, I wanted this to be notified easily whilst on vacation.

### timers.yaml

For this setup you will need to setup two timers


```yaml

# The main timer for automation triggers
balcony_water:
  duration: '00:02:00'

# Secondary timer for manual invocation
balcony_water_max:
  duration: '00:02:00'
```

### automation.yaml

```yaml
- alias: 'Balcony water automatic (start)'
  trigger:
    - platform: time
      at: '21:30:00'
  action:
  - service: script.balcony_water_start

- alias: 'Balcony water hot day (start)'
  trigger:
    - platform: time
      at: '09:30:00'
  condition:
      condition: and
      conditions:
        - condition: numeric_state
          entity_id:  sensor.yr_temperature
          above: 25
  action:
  - service: script.balcony_water_start

- alias: 'Balcony water automatic (stop)'
  trigger:
  - platform: event
    event_type: timer.finished
    event_data:
      entity_id: timer.balcony_water
  action:
  - service: switch.turn_off
    entity_id: switch.socket_balcony
  - service: notify.pushbullet_chi
    data:
      message: 'Balcony watering finished'




- alias: 'Balcony water manual (start)'
  trigger:
  - platform: state
    entity_id: switch.socket_balcony
    to: 'on'
  action:
  - service: timer.start
    entity_id: timer.balcony_water_max

- alias: 'Balcony water manual (stop)'
  trigger:
  - platform: event
    event_type: timer.finished
    event_data:
      entity_id: timer.balcony_water_max
  action:
  - service: switch.turn_off
    entity_id: switch.socket_balcony
```

# Improvements

As the title says this setup is _very_ basic right now and gives no feedback on the water remaining in the tank, the moisture in the soil, or outside air temperature.

All these points are things I would love to improve in the future, especially the first point.

# Photos

![Drip nozzle](/assets/img/posts/ha-balcony-1.jpg)
![Water storage](/assets/img/posts/ha-balcony-2.jpg)
![Setup](/assets/img/posts/ha-balcony-3.jpg)

# Further reading

- [Andreas Gohr - Automated Plant Watering][1]

[0]: https://www.home-assistant.io/
[1]: https://www.splitbrain.org/blog/2017-06/10-automated_plant_watering
[2]: https://www.pushbullet.com/
[3]: https://github.com/xoseperez/espurna
[4]: https://esphome.io/