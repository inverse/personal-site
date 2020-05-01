---
layout: post
title: Home Assistant utility meter setup
comments: true
tags:
- home-automation
- home-assistant
date: 2019-12-03 22:36 +0100
---
In our house we have a few older generation [Teckin SP22][6]'s running [Espurna][4] and newer [Gosund SP111][5] running [Tasmota][3] that all publish their energy statistics via MQTT to Home Assistant. 

I wanted a unified way to visualise the daily and monthly energy usage of these devices to better grasp how much energy we are consuming.

Home Assistant provides a [Utility Meter][0] component that allows exactly that behaviour, with the granularity of even providing peak and off-peak tariffs if your energy provider offer such.

The problem however is this operates on a single entity and the devices that I had configured are exposed individually.

e.g. this is how Espurna and Tasmota expose them when manually configured.

```yaml

# Tasmota

- name: socket_7_energy
  platform: mqtt
  state_topic: "tele/socket-7/SENSOR"
  value_template: '{{ value_json["ENERGY"]["Total"] }}'
  unit_of_measurement: kWh
- name: socket_7_power
  platform: mqtt
  state_topic: "tele/socket-7/SENSOR"
  value_template: '{{ value_json["ENERGY"]["Power"] }}'
  unit_of_measurement: W

# Espurna

- name: socket_balcony_energy
  platform: mqtt
  state_topic: socket-6/energy
  unit_of_measurement: kWh
- name: socket_balcony_power
  platform: mqtt
  state_topic: socket-6/power
  unit_of_measurement: W

```

To unify these sensor readings you can use the powerful [Templating platform][7] to combine these and expose them as a single reading.

```yaml
- platform: template
  sensors: 
    energy_total_usage:
      friendly_name: Total Energy Usage
      unit_of_measurement: kWh
      value_template: >-  
        {% raw %}{{ 
          (states.sensor.socket_media_energy.state | float) +
          (states.sensor.socket_desk_energy.state | float) +
          (states.sensor.socket_coffee_energy.state | float) +
          (states.sensor.socket_aurora_bedlight_energy.state | float) +
          (states.sensor.socket_fairy_lights_energy.state | float) +
          (states.sensor.socket_7_energy.state | float) +
          (states.sensor.socket_8_energy.state | float)
        }}{% endraw %}
    power_total_usage:
      friendly_name: Total Power Usage
      unit_of_measurement: W
      value_template: >-  
        {% raw %}{{ 
          (states.sensor.socket_media_power.state | float) +
          (states.sensor.socket_desk_power.state | float) +
          (states.sensor.socket_coffee_power.state | float) +
          (states.sensor.socket_aurora_bedlight_power.state | float) +
          (states.sensor.socket_fairy_lights_power.state | float) +
          (states.sensor.socket_7_power.state | float) +
          (states.sensor.socket_8_power.state | float)
        }}{% endraw %}
```

Next you'll be able to hook up the utility meter configuration as such.


```yaml
energy_total_usage_daily:
  source: sensor.energy_total_usage
  cycle: daily

energy_total_usage_monthly:
  source: sensor.energy_total_usage
  cycle: monthly
```

# Visualising

Like in [previous posts]({% post_url 2019-11-25-connecting-tasmota-to-home-assistant %}), I highly recommend the [Mini Graph Card][8] extension by [@kalkih][9]. It provides various minimalistic and customisable cards that can be useful for displaying metrics and sensor statistics. 

![Energy Daily](/assets/img/posts/lovelace-energy-daily.png)

```yaml
  - type: custom:mini-graph-card
    name: Energy Daily
    entities:
      - sensor.energy_total_usage_daily

```

![Energy Monthly](/assets/img/posts/lovelace-energy-monthly.png)

```yaml
  - type: custom:mini-graph-card
    name: Energy Monthly
    entities:
      - sensor.energy_total_usage_monthly

```

![Power Gauge](/assets/img/posts/lovelace-power-gauge.png)

```yaml
  - type: gauge
    name: Power
    unit: W
    max: 1500
    entity: sensor.power_total_usage
    severity:
      green: 100
      yellow: 150
      red: 300
```

![Power Graph](/assets/img/posts/lovelace-power-graph.png)

```yaml
  - type: custom:mini-graph-card
    name: Power
    icon: mdi:flash
    entities: 
      - sensor.power_total_usage
    show:
      graph: bar
```

# Next steps

While this easily gives you nice daily and monthly unified overviews the power consumption of your smart plugs it doesn't allow you to query other time frames or drill down by device, without exposing the stats for each sensor manually. 

An alternative approach which would complement this setup would be to publish your sensor stats to [InfluxDB][1] and graph this data using [Grafana][2]. But that'll be for another post.

# Further reading

- [Home Assistant - Utility meter][0]
- [Home Assistant - Templating platform][7]

[0]: https://www.home-assistant.io/integrations/utility_meter/
[1]: https://www.influxdata.com/
[2]: https://grafana.com/
[3]: https://github.com/arendst/Tasmota/
[4]: https://github.com/xoseperez/espurna
[5]: https://www.amazon.de/exec/obidos/ASIN/B085Q5ZR33/hexagon05-21/
[6]: https://www.amazon.de/exec/obidos/ASIN/B07CDCYLQ6/hexagon05-21/
[7]: https://www.home-assistant.io/integrations/template/
[8]: https://github.com/kalkih/mini-graph-card
[9]: https://github.com/kalkih
[10]: https://github.com/kalkih/mini-graph-card#install