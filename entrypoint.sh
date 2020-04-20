#!/bin/bash
set -aeo pipefail
RUID="${RUID:-$(id -u radicale)}"
RGID="${RGID:-$(id -g radicale)}"

# Set radicale UID and GID if changed by variables
[[ "$(id -u radicale)" -ne "$RUID" ]] && usermod -u "$RUID" -o radicale
[[ "$(id -g radicale)" -ne "$RGID" ]] && groupmod -g "$RGID" -o radicale

[[ ! -f /etc/radicale/config ]] && cp /root/config /etc/radicale/config

[[ ! -d /srv/radicale/collections ]] && printf "Creating collection dir\n" && mkdir /srv/radicale/collections

[[ ! "$(stat -c '%U' /srv/radicale/collections)" == "radicale" ]] && printf "Setting permissions on /src/radicale/collections\n" && chown -R radicale:radicale /srv/radicale/collections

if [[ "$1" == "reset-permission" ]]; then
  printf "chown -R radicale:radicale /srv/radicale\n"
  chown -R radicale:radicale /srv/radicale
elif [[ "$1" == "adduser" ]]; then
  read -p "Username: " USERNAME
  htpasswd -B -c /etc/radicale/htpasswd.bcrypt "$USERNAME"
elif [[ "$1" == "radicale" ]]; then
  printf "$*\n"
  printf "Starging radicale ($(radicale --version))\n"
  exec su - radicale -c "$*"
else
  exec "$@"
fi
