---
layout: post
title: Washing Machine Cycle Notifications
date: 2020-04-08 21:16 +0200
comments: true
tags:
- home-automation
- home-assistant
- node-red
---

In this post I will explain how I hooked up our normal washing machine to provide some power usage insights, such as sending notifications that include the cycle time and power consumption.

I'm using [Home Assistant][0] and leveraging [Node-Red][1] installed via an addon to provide the automation layer. By leveraging the addon it provides seem-less integration to query entities and trigger services.

For this setup I used a [Gosund SP111][7] but you could any power sensing smart plug that you can feed the data into Home Assistant.

## Setting up the sensors

I flashed the plug with [Tasmota][6] allowing me to push the data via MQTT to be consumed by Home Assistant. You can do this automatically via the MQTT auto discovery flag but I like to manually set things up to allow me to learn as I go.

```yaml
- name: washing_machine_energy
  platform: mqtt
  state_topic: "tele/socket-10/SENSOR"
  value_template: '{{ value_json["ENERGY"]["Total"] }}'
  unit_of_measurement: kWh
- name: washing_machine_power
  platform: mqtt
  state_topic: "tele/socket-10/SENSOR"
  value_template: '{{ value_json["ENERGY"]["Power"] }}'
  unit_of_measurement: W
```

Since the power usage changes during the wash cycle I added an additional template based sensor that would signal if the device was on or off based of the power draw is > 5w and has been on for more than 60 seconds.

```yaml
- platform: template
  sensors:
    washing_machine_state:
      friendly_name: Washing Machine Status
      value_template: >-
          {% raw %}{% if (states('sensor.washing_machine_power')|int >= 5 and (as_timestamp(now()) - as_timestamp(states.sensor.desk_power.last_changed)) / 60 | int > 3) %}
            on
          {% else %}
            off
          {% endif %}{% endraw %}
```

_You could probably achieve similar behaviour in Node-Red but I wanted to keep this logic in Home Assistant for now._

## Notification Side

For the notification side I opted to use the [Telegram integration][8] since it's easy to work with, free, doesn't involve me installing another app as I use it daily, and is pretty rich for other capabilities such as sending videos and images.  

## Setting up Node-Red

If you've never worked with Node-Red I highly recommend you read their [official documentation][3] or watch a few starter videos such as:

- [Intro to Node-RED: Part 1 Fundamentals][4]
- [Node-RED + Home Assistant How-To][5]

For this automation you will need to setup 3 nodes.

![Washing Machine Power Flow](/assets/img/posts/washing-machine-power/flow.png)

### State node

This is the input node that is used to kick things off. It matches the the `sensor.washing_machine_state` entity and is setup as a bool sensor to output only on state cange.

### Function node

This is where the real logic happens. Computing the energy usage and the elapsed cycle time.

```js
const haStates = global.get('homeassistant').homeAssistant.states;
const entity = haStates['sensor.washing_machine_energy'];

if(msg.payload) {
    const data = {
        state: entity.state,
        startTime: Date.now(),
    };
    context.set('savedState', data);
} else {
    const data = context.get('savedState');

    if (data === undefined) {
        return;
    }

    const energy = parseFloat(Math.abs(entity.state - data.state)).toFixed(2);

    const duration = millisToMinutesAndSeconds(Date.now() - data.startTime);

    const payload = {
        energy: energy,
        duration: duration,
    }

    msg.payload = payload;

    return msg;
}

function millisToMinutesAndSeconds(millis) {
  let minutes = Math.floor(millis / 60000);
  let seconds = ((millis % 60000) / 1000).toFixed(0);
  return minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
}
```

### Service node

Finally once the computation has been calculated and the payload has been emitted to the notifier service.

The Data for the service call consisted of this JSON structure:

```json
{"message": "Washing machine used {{payload.energy}} kwh and ran for {{payload.duration}} during the last cycle"}
```

[0]: https://www.home-assistant.io
[1]: https://nodered.org/
[3]: https://nodered.org/docs/
[4]: https://www.youtube.com/watch?v=3AR432bguOY
[5]: https://www.youtube.com/watch?v=SuoSXVqjyfc
[6]: https://tasmota.github.io/docs/
[7]: https://affiliate.malachisoord.com/t/940fc6b7-d20a-46d7-b6bb-2f6bdcaaed7b
[8]: https://www.home-assistant.io/integrations/telegram_bot 
