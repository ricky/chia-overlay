# Chia Gentoo Overlay

This overlay contains `chia-blockchain` and related ebuilds.

## Installation

Copy [`chia_repo.conf`](chia_repo.conf) to `/etc/portage/repos.conf` and update
`location` to the preferred local path.

e.g.:

```
# wget -O /etc/portage/repos.conf/chia.conf https://raw.githubusercontent.com/ricky/chia-overlay/main/chia_repo.conf
# sed -i 's/CHIA_OVERLAY_PATH/\/var\/db\/repos\/chia/' /etc/portage/repos.conf/chia.conf
# emerge --sync
```

## Quickstart

```console
# emerge net-p2p/chia-blockchain
```

You may need to [accept `~` keywords](https://wiki.gentoo.org/wiki//etc/portage/package.accept_keywords)
for your arch, if you're primarily using stable packages.

Note: The following commands assume you'll want to use the `chia` user, which is
not configured w/ a login shell by default. For any other user, simply drop the
`runuser` part and run the commands directly as that user. When using the OpenRC
script, edit `/etc/conf.d/chia` as necessary.

```console
# runuser -s /bin/sh chia -c 'chia init'
# runuser -s /bin/sh chia -c 'chia keys generate'
```

systemd:

```console
# runuser -s /bin/sh chia -c 'systemctl --user start chia@farmer'
```

OpenRC:
```console
# /etc/init.d/chia start
```

`farmer` can be replaced by any service supported by `chia start` in either the
`systemctl` command or `/etc/conf.d/chia`.
