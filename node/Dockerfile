FROM ubuntu

RUN apt update ; \
  apt install -y python3.12-minimal iproute2 iptables iputils-ping traceroute net-tools \
    tcpdump

COPY init.sh /init.sh

CMD ["/bin/bash", "-c", "bash /init.sh && echo '=====' && ip route && echo '=====' && while true ; do sleep 1000 ; done"]
