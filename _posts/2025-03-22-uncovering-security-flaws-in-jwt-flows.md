---
layout: post
title: Uncovering security flaws in JWT flows
date: 2025-03-22 23:36 +0100
comments: true
tags:
- jwt
- tado
- security
---

Last year, our landlord replaced our [IOLite][0] controlled heating system with the standard manually operated valves. Returning to manual control was inconvenient, so I sought a solution that would provide similar functionality while integrating seamlessly with [Home Assistant][1],without the need for reverse engineering, as was required with IOLite, but also also allowing local control for full offline goodness.

This led to a recommendation for the [Tado X][2] product line, which colleagues at work spoke highly of. Notably, it supports Matter integration, making it an appealing choice.

### Setup & Discovery

Setup was straightforward, and after reading this [forum article][4], I opted for the Matter integration, which worked flawlessly after pairing each device with the provided hub. Alongside its native app, Tado also provides a [Web UI][5] for remote home control via a browser.

Curious about their authentication handling, I investigated further and found that token information was stored in local storage under the variable `ngStorage-token`. Using [jwt-cli][6] to inspect the token didn't reveal anything unexpected, which led me to a question:

> What happens if I change my password?

While I knew JWTs are not inherently revocable, in theory, a password reset should invalidate the refresh token used for issuing new tokens.

However, I discovered a security flaw: the refresh token remained valid indefinitely, even after a password reset, allowing it be used to issue new tokens with a way for the user to sop this. 

### Reporting the Issue

Unfortunately, Tado lacks a straightforward method for reporting security issues. Instead, everything had to be triaged through their standard customer support channels.

#### Timeline:

- **31.12.2024** - First contact with customer support regarding the issue.
- **21.01.2025** – Follow-up on my original security report.
- **12.02.2025** – [Official deprecation][7] of the insecure password flow, announced in the [PyTado][8] repo and on [Home Assistant][9], along with migration guidelines and a deprecation timeline.

While it was good to see transparency around the API sunset, the communication and support could have been improved. Understanding Home Assistant's release cycle better might have helped minimize disruptions, which going by the public information available is used on [3.4%] of active installs.

### Reflections

When reaching out to members of Tado’s engineering team, I found them to be open and transparent. They acknowledged that they had been pushing for this issue to be addressed for a long time. Their willingness to engage in dialogue was refreshing and encouraging—especially as someone interested in infosec but not an expert.

Props to the engineers for their engagement with the community! At no point did I feel discouraged from inspecting the system; in fact, I was encouraged to look further.

Tado, perhaps it's time to publish an [official security policy][10]?

[0]: https://iolite.de/en/
[1]: https://www.home-assistant.io/
[2]: https://www.tado.com/en
[4]: https://community.home-assistant.io/t/using-tado-smart-thermostat-x-through-matter/736576
[5]: https://app.tado.com/
[6]: https://github.com/mike-engel/jwt-cli
[7]: https://support.tado.com/en/articles/8565472-how-do-i-authenticate-to-access-the-rest-api
[8]: https://github.com/wmalgadey/PyTado/issues/155
[9]: https://github.com/home-assistant/core/issues/138518
[10]: https://securitytxt.org/
[11]: https://www.home-assistant.io/integrations/tado/
