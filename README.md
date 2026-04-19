# profile-sync-daemon-openrc

Minimal OpenRC user service setup for `psd`.

Service behavior:

```text
start   : psd resync
running : psd sync    (periodic)
stop    : psd sync && psd unsync
```

## install

Standard install:

```sh
sudo make install
```

Staging install for packaging:

```sh
make DESTDIR=/tmp/pkgroot install
```

This is a user service because browser profiles such as Chromium live under `~/.config/`.
`psd` must operate on those per-user trees as that user.

References:

- <https://wiki.gentoo.org/wiki/OpenRC/>
- <https://wiki.gentoo.org/wiki/OpenRC/supervise-daemon>

## openrc user service

OpenRC user services require `${XDG_RUNTIME_DIR}`.
Service state is stored under `${XDG_RUNTIME_DIR}/openrc/`.

This service script uses `supervise-daemon` to monitor a long-running sync loop.
At startup it runs `psd resync` once, then executes `psd sync` at a fixed interval.
At shutdown it runs `psd sync && psd unsync` to flush tmpfs-backed data back to disk.

The sync interval is controlled by `PSD_SYNC_INTERVAL`, in seconds.
The default is `300`.

## enable

For a persistent user session, add the target user's `user.<user>` service on the system side.

```sh
sudo ln -s /etc/init.d/user /etc/init.d/user.<user>
sudo rc-update add user.<user>
```

Then add `psd` to the user's runlevel.

```sh
rc-update --user add psd
```

A PAM-driven user session can also be used. If so, follow the OpenRC PAM setup for your system.

## operation

Start:

```sh
rc-service --user psd start
```

Stop:

```sh
rc-service --user psd stop
```

Status:

```sh
rc-service --user psd status
```

Run an immediate sync:

```sh
rc-service --user psd sync_now
```

Reset service state:

```sh
rc-service --user psd zap
```

## notes

Recent OpenRC setups may start user services automatically through PAM.
If that is enabled, adding `user.<user>` for the same user on the system side may conflict with it.

If you intend to manage `user.<user>` manually, set the following in `/etc/rc.conf` as needed.

```sh
rc_autostart_user="NO"
```

Pick one session model and avoid mixing the two.
