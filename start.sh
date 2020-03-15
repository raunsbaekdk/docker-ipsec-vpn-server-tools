#!/bin/sh

# Check if sudo and then add module af_key
if sudo -n true
then
  sudo modprobe af_key
else
  modprobe af_key
fi

# Create folders and touch files
touch etc/ipsec.secrets
touch etc/ipsec.users

# Declare arguments variable
EXTRA_ARGS=

# Check if post-up file exists
if [ -f $PWD/etc/post-up.sh ]; then
  EXTRA_ARGS="-v $PWD/etc/post-up.sh:/post-up.sh"
fi

# Check if pre-up file exists
if [ -f $PWD/etc/pre-up.sh ]; then
  EXTRA_ARGS="-v $PWD/etc/pre-up.sh:/pre-up.sh"
fi

# Create network specific to this container (can be used to route traffic via another outgoing ip)
docker network create --attachable --opt 'com.docker.network.bridge.name=bridge-coi' --opt 'com.docker.network.bridge.enable_ip_masquerade=false' bridge-coi

# Run start up
docker run \
  --network bridge-coi \
  --name ipsec-vpn-server \
  -p 500:500/udp \
  -p 4500:4500/udp \
  -v "$PWD/etc/ipsec.secrets:/etc/ipsec.secrets" \
  -v "$PWD/etc/ipsec.users:/etc/ipsec.users" \
  $EXTRA_ARGS \
  -v /lib/modules:/lib/modules:ro \
  -d --privileged \
  --restart=always \
  raunsbaekdk/docker-ipsec-vpn-server
