---
layout: post
title: Uncovering Security Flaws in JWT Flows
date: 2025-03-22 23:36 +0100
comments: true
tags:
- jwt
- tado
- security
---

Last year, our landlord replaced our [IOLite][0]-controlled heating system with standard manual operated valves. Returning to manual control was inconvenient, so I sought a solution, that:

- Provided similar functionality
- Integrated seamlessly with [Home Assistant][1]
- Allowed local control for offline use
- Required no reverse engineering (unlike [IOLite]({% post_url 2020-08-06-reverse-engineering-iolite-remote-api %}))

This led me to the [Tado X][2] product line, which colleagues at work highly recommended. Notably, it supports Matter integration, making it an appealing choice.

<!--truncate-->

## Setup & Discovery

Setting up Tado was straightforward, After reading this [forum article][4], I opted for the Matter integration, which worked flawlessly after pairing each device with the provided hub. Native Tado X outside of matter is currently limited, but the library maintainers are adding support in the future.

Alongside its native app, Tado provides a [Web UI][5] for remote home control via a browser.

### Investigating Authentication

Curious about how authentication was handled, I inspected the web application and found that token information was stored in local storage under the key `ngStorage-token`, Implying the framework in use was [AngularJS][13] based leveraging the [ngstorage][12] package.

Using [jwt-cli][6] to inspect the token didn't reveal anything unusual. But this raised an important question:

> What happens if I change my password?

While JWTs are not inherently revocable, in theory, a password reset should invalidate the refresh token used to issue new tokens.

### The Security Flaw

I discovered a flaw in this reset flow, even after a password reset, the refresh token remained valid indefinitely. This means that attackers (or anyone with access to the token) could continue issuing new tokens without the user's ability to revoke it.

## Reporting the Issue

Unfortunately, Tado lacked a dedicated security reporting process. Everything had to go through customer support.

### Timeline of Events

- `31.12.2024` - First contact with customer support regarding the issue.
- `21.01.2025` - Follow-up on my original security report to find out how it was being handled.
- `12.02.2025` - [Official deprecation][7] of the insecure password flow, announced in the [PyTado][8] repo and on [Home Assistant][9], along with migration guidelines and a deprecation timeline.

While it was great to see transparency around the API sunset, the communication process could have been smoother. Better coordination with Home Assistant's release cycle might have helped minimize disruption for users. Especially considering according to reported stats around [3.4%][11] use this integration and would be affected.

## Reflections

When reaching out to Tado's engineering team directly, I found them to be open and transparent. They acknowledged that they were aware of the weakness had been pushing for a fix for a long time. Their willingness to engage in dialogue was refreshing and encouraging, especially for someone interested in infosec but not an expert in that field.

💡 Props to the engineers for engaging with the community! At no point did I feel discouraged from inspecting the system—on the contrary, I was encouraged to look further.

🚀 Tado, perhaps it's time to publish an [official security policy][10] to make the triage process easier? I'm not expecting some sort of bug bounty program, just a way to easier report security issues directly to the relevant folks.

## Further Reading

- [OAuth Password Flow][14] (legacy)
- [Device Authentication Grant][15]

## Buying

- [From the supplier direct][16]
- [Tink -often have great deals][17]
- [From Amazon][18]

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
[12]: https://www.npmjs.com/package/ngstorage
[13]: https://angularjs.org/
[14]: https://datatracker.ietf.org/doc/html/rfc8628
[15]: https://oauth.net/2/grant-types/password/
[16]: https://shop.tado.com/
[17]: https://www.tink.de/b/tado
[18]: https://amzn.to/4hRC10Z
