---
layout: post
title: Reset EMQX admin password
date: 2026-09-20
comments: true
tags:
- emqx
- recovery
- home-assistant
---

I recently forgot the password for the admin dashboard on my EMQX instance running on Home Assistant OS and needed to reset it.

Thankfully EMQX ships a built-in CLI that makes this easy without restarting anything.

First, shell into the running EMQX container. Since addons use a unique ID you can look it up by filtering the running containers:

```bash
docker exec -it $(docker ps --format json | jq -r -c 'select( .Names | contains("emqx")).ID') bash
```

Then reset the password for the default `admin` user:

```bash
/opt/emqx/bin/emqx ctl admins passwd <new-password>
```

If you don't know the username to reset, you can create a new one instead:

```bash
/opt/emqx/bin/emqx ctl admins add <new-username> <password>
```

The change takes effect immediately, so verify by signing in to the dashboard with the new credentials.
