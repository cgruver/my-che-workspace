#!/usr/bin/env bash

export HOME=${HOME:-/home/user}

if [ ! -d "${HOME}" ]
then
  mkdir -p "${HOME}"
fi

if ! whoami &> /dev/null
then
  if [ -w /etc/passwd ]
  then
    echo "${USER_NAME:-user}:x:$(id -u):0:${USER_NAME:-user} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-user}:x:$(id -u):" >> /etc/group
  fi
fi
USER=$(whoami)
START_ID=$(( $(id -u)+1 ))
echo "${USER}:${START_ID}:2147483646" > /etc/subuid
echo "${USER}:${START_ID}:2147483646" > /etc/subgid

mkdir -p "${HOME}"/.config/containers
(echo 'unqualified-search-registries = [';echo '  "registry.access.redhat.com",';echo '  "registry.redhat.io",';echo '  "docker.io"'; echo ']'; echo 'short-name-mode = "permissive"') > ${HOME}/.config/containers/registries.conf

for i in "$@"
do
  case $i in
    --vfs)
      (echo '[storage]';echo 'driver = "vfs"') > "${HOME}"/.config/containers/storage.conf
    ;;
    --fuse)
      mkdir ${HOME}/proc
      (echo "[containers]";echo "netns=\"private\"";echo "volumes=[";echo "  \"${HOME}/proc:/proc:rw\"";echo "]";echo "default_sysctls = []";echo "[engine]";echo "network_cmd_options=[";echo "  \"enable_ipv6=false\"";echo "]") > ${HOME}/.config/containers/containers.conf
    ;;
    --proc)
      (echo '[containers]';echo 'netns="private"';echo 'default_sysctls = []';echo '[engine]';echo 'network_cmd_options=[';echo '  "enable_ipv6=false"';echo ']') > ${HOME}/.config/containers/containers.conf
    ;;
  esac
done

exec "tail -f /dev/null"
