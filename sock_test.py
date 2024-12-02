import socket

HOST = socket.gethostbyname(socket.gethostname())
print("HOST: " + str(HOST))

src_addr = b"\x01\x02\x03\x04\x05\x06"
dst_addr = b"\x01\x02\x03\x04\x05\x06"
payload = (b"["*30) + b"PAYLOAD" + (b"]"*30)
checksum = b"\x1a\x2b\x3c\x4d"
ethertype = b"\x08\x01"




"""
sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
#sock.bind(("173.20.0.4", 0))

packet = b'E\x00\x00X\x00\x01\x00\x00@\x01 s\xad\x14\x00\x04\xad\x14\x00\x05\x0b\x00CC\x00\x00\x00\x00E\x00\x00<\xcf\xd8\x00\x00\x01\x11Yx\xad\x14\x00\x05@\xe9\xa2^\xa9Z\x82\x9a\x00(\x90\x9a@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'
#sock.sendto(dst_addr + src_addr + ethertype + payload + checksum, ("173.20.0.5", 0))
sock.sendto(packet, ("173.20.0.5", 0))
"""


sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, )
#sock.bind(("173.20.0.4", 0))

packet = b'E\x00\x00X\x00\x01\x00\x00@\x01 s\xad\x14\x00\x04\xad\x14\x00\x05\x0b\x00CC\x00\x00\x00\x00E\x00\x00<\xcf\xd8\x00\x00\x01\x11Yx\xad\x14\x00\x05@\xe9\xa2^\xa9Z\x82\x9a\x00(\x90\x9a@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'
#sock.sendto(dst_addr + src_addr + ethertype + payload + checksum, ("173.20.0.5", 0))
sock.sendto(packet, ("eth0", 0))
