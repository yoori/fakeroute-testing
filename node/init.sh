#!/bin/bash

( ip route del default && \
  ip route add default via 173.20.0.4 && \
  tail -f /dev/null ) || \
  exit 1


