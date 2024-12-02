FROM ubuntu

ARG UID=0
ARG GID=0
ARG UNAME=root

RUN apt update ; \
  apt install -y python3.12-minimal python3-pip iproute2 iptables iputils-ping traceroute net-tools \
    emacs tcpdump

COPY init.sh /init.sh
COPY fakeroute /fakeroute
COPY hops /hops
COPY sock_test.py /sock_test.py

RUN pip3 install --break-system-packages -r /fakeroute/requirements.txt

CMD ["/bin/bash", "-c", "echo '==================' ; bash /init.sh"]
