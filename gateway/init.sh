#!/bin/bash

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

ETH_INTERNAL=$(ifconfig | grep -B1 173.20.0.4 | grep -o "^\w*")
ETH_EXTERNAL=$(ifconfig | grep -B1 173.21.0.4 | grep -o "^\w*")

echo "> ETH_INTERNAL: $ETH_INTERNAL"
echo "> ETH_EXTERNAL: $ETH_EXTERNAL"

DEC_TTL=(cat /hops | wc -l)

# decrease ttl for hops after fake hops (only for external iface, fakeroute should see these packets)
iptables -t nat -A PREROUTING -o "$ETH_EXTERNAL" -j TTL --ttl-dec "$DEC_TTL"

# Priority 1 : Disable local system ICMP responses (fakeroute use AF_PACKET, and iptables don't affect on it)
#iptables -I OUTPUT -s 173.20.0.4 -p icmp -m icmp --icmp-type 11 -j DROP || exit 1

# Priority 2 : Add 40ms delay for all ICMP packets from next hops to client (on external iface)
tc qdisc add dev "$ETH_EXTERNAL" root netem delay 40ms
#( tc qdisc add dev "$ETH_EXTERNAL" root handle 1: prio priomap 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 &&
#  tc filter add dev "$ETH_EXTERNAL" parent 1:0 protocol icmp prio 1 u32 match protocol 0x01
#  ) || \
#  exit 1

# 
# tc qdisc add dev "$ETH_EXTERNAL" parent 1:2 handle 20: netem delay 40ms &&

# Priority 2 : Configure forwarding as gateway
( iptables -t nat -A POSTROUTING -o "$ETH_INTERNAL" -j MASQUERADE &&
  iptables -t nat -A POSTROUTING -o "$ETH_EXTERNAL" -j MASQUERADE &&
  iptables -A FORWARD -i "$ETH_EXTERNAL" -j ACCEPT &&
  iptables -A FORWARD -i "$ETH_INTERNAL" -j ACCEPT
  ) || \
  exit 1

python3 /fakeroute/fakeroute.py --hops /hops
sleep 100000
