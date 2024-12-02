#!/bin/bash

ETH_INTERNAL=$(ifconfig | grep -B1 173.20.0.4 | grep -o "^\w*") # < Here required name of iface for internal network
ETH_EXTERNAL=$(ifconfig | grep -B1 173.21.0.4 | grep -o "^\w*") # < Here required name of iface for external network (internet)

echo "> ETH_INTERNAL: $ETH_INTERNAL"
echo "> ETH_EXTERNAL: $ETH_EXTERNAL"

DEC_TTL=(cat /hops | wc -l)

# decrease ttl for hops after fake hops (only for external iface, fakeroute should see these packets)
# you need only this in production
iptables -t nat -A PREROUTING -o "$ETH_EXTERNAL" -j TTL --ttl-dec "$DEC_TTL"

# Not for production, add 40ms delay for all ICMP packets from next hops to client (on external iface)
tc qdisc add dev "$ETH_EXTERNAL" root netem delay 40ms

# Not for production, Configure forwarding as gateway
( iptables -t nat -A POSTROUTING -o "$ETH_INTERNAL" -j MASQUERADE &&
  iptables -t nat -A POSTROUTING -o "$ETH_EXTERNAL" -j MASQUERADE &&
  iptables -A FORWARD -i "$ETH_EXTERNAL" -j ACCEPT &&
  iptables -A FORWARD -i "$ETH_INTERNAL" -j ACCEPT
  ) || \
  exit 1

python3 /fakeroute/fakeroute.py --hops /hops
