---
layout: post
title: Reset Home Assistant owner password
date: 2025-12-24 12:40 +0100
tags:
- home-assistant
- recovery
---

I recently had to reset the owner account on my Home Assistant instance after forgetting the password.

Thankfully Home Assistant provides [comprehensive documentation][0] that walks through several recovery options. The notes below capture the exact flow I used on a Home Assistant OS install, where the supervisor runs Home Assistant inside a managed container.

Following the [container command line documentation][1], the steps I needed were fairly similar: first SSH to the device (via the [SSH add-on][2]).

Once connected, get a shell in the Home Assistant container to call `hass`:

```bash
docker exec -it homeassistant bash
```

Then reset the password:

```bash
hass --script auth --config /config change_password <username> <new-password>
```

Finally, log back to the host by calling `exit` and then restart Home Assistant:

```bash
ha core restart
```

Verify by signing in to the UI with the updated password to confirm the change.

[0]: https://www.home-assistant.io/docs/locked_out/
[1]: https://www.home-assistant.io/docs/locked_out/#to-reset-a-users-password-via-the-container-command-line
[2]: https://community.home-assistant.io/t/home-assistant-community-add-on-ssh-web-terminal/33820
