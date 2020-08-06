---
layout: post
title: Simple home automation balcony setup
comments: true
tags:
- home-automation
- home-assistant
date: 2019-07-03 22:20 +0200
---
I've been getting into some home automation for our apartment for a while, ever since my father got us an Amazon Alexa device to call home with. Since then we expanded our setup to include smart plugs, Philips Hue lighting, and some Broadlink IR controllers. 

Whilst these products can function well in their respective eco-systems. The real power comes when leveraging a product such as [Home Assistant][0] to bring it all together into a single unified platform.

One thing we recently introduced in our setup was to include a very simple balcony watering system that can be controlled remotely and automated via timers and other triggers.

This post documents the equipment required outside of the standard Home Assistant setup and the configuration required to get going.

## Parts

- [Drip irrigation kit](https://affiliate.malachisoord.com/t/3e8d53b5-b834-4447-9953-22b3d3aa3baf)
- [12V adaptor](https://affiliate.malachisoord.com/t/38954035-52fd-4c9e-b7d6-7d7d4a3234a4)
- [12V Pump](https://affiliate.malachisoord.com/t/1fb92780-2e57-4122-b8fd-78d81fc70ca4)
- [Smart plug](https://affiliate.malachisoord.com/t/cb945e08-9e4f-40d2-8870-23ff9012cad0)
- [Water container](https://affiliate.malachisoord.com/t/96598d3c-4ee5-474f-b131-754474503a89)
- [Hose adaptor](https://affiliate.malachisoord.com/t/e31a5f87-940d-461b-8cc3-bf00d52ec309 )

## Setup

The setup with these components was straight forward, with the components pretty much connecting and screwing together and just working.

The only complicated thing was flashing custom firmware onto the smart plug as I wanted to have a purely offline setup. I went with [espurna][3] for this but you could also try [esphome][4] which provides a nice API and easy YAML configuration.

### Home Assistant configuration

The automation currently consists of 3 parts.

- A daily watering schedule which is triggered based on the time
- Secondary schedule, triggered by time and temperature forecast
- Manual invocation and automatic off after defined duration
- Safety mechanism to ensure switch is off, for cases when reboot occurs during watering cycle.

For the first one I also decided to use [Push Bullet][2] to notify my devices when it was triggered, I wanted this to be notified easily whilst on vacation.

#### timers.yaml

For this setup you will need to setup two timers


```yaml

# The main timer for automation triggers
balcony_water:
  duration: '00:02:00'

# Secondary timer for manual invocation
balcony_water_max:
  duration: '00:02:00'
```

Next configure the following automations.

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




- alias: 'Ensure balcony is off on reboot'
  initial_state: 'on'
  trigger:
    - platform: homeassistant
      event: start
  action:
    service: switch.turn_off
    entity_id: switch.socket_balcony
```

## Improvements

As the title says this setup is _very_ basic right now and gives no feedback on the water remaining in the tank, the moisture in the soil, or outside air temperature.

All these points are things I would love to improve in the future, especially the first point.

## Photos

![Drip nozzle](/assets/img/posts/ha-balcony-1.jpg)
![Water storage](/assets/img/posts/ha-balcony-2.jpg)
![Setup](/assets/img/posts/ha-balcony-3.jpg)

## Further reading

- [Andreas Gohr - Automated Plant Watering][1]

[0]: https://www.home-assistant.io/
[1]: https://www.splitbrain.org/blog/2017-06/10-automated_plant_watering
[2]: https://www.pushbullet.com/
[3]: https://github.com/xoseperez/espurna
[4]: https://esphome.io/
