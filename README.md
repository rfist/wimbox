# wimbox

Lightweight, reproducible homelab configuration for small single-board computers.

## Maintenance

### Docker image/build cache pruning

Unused Docker images and build cache accumulate over time and can fill the disk.
`scripts/docker_prune.sh` removes anything not attached to a container and older
than 7 days, run weekly via a user-level systemd timer.

To enable it on a new system:

```
mkdir -p ~/.config/systemd/user
ln -sf ~/homelab/scripts/systemd/docker-prune.service ~/.config/systemd/user/docker-prune.service
ln -sf ~/homelab/scripts/systemd/docker-prune.timer ~/.config/systemd/user/docker-prune.timer
systemctl --user daemon-reload
systemctl --user enable --now docker-prune.timer
loginctl enable-linger "$USER"
```

`loginctl enable-linger` lets the timer run even when no session is logged in
(needed on a headless box). Check it's scheduled with:

```
systemctl --user list-timers docker-prune.timer
```
