#!/bin/bash

/usr/lib/frr/zebra -s 90000000 --daemon -A 127.0.0.1
/usr/lib/frr/bgpd --daemon -A 127.0.0.1
/usr/lib/frr/ospfd --daemon -A 127.0.0.1
/usr/lib/frr/ospf6d --daemon -A ::1
/usr/lib/frr/ldpd -L
/usr/lib/frr/ldpd -E
/usr/lib/frr/ldpd --daemon -A 127.0.0.1
/usr/lib/frr/watchfrr -r /usr/sbin/servicebBfrrbBrestartbB%s -s /usr/sbin/servicebBfrrbBstartbB%s -k /usr/sbin/servicebBfrrbBstopbB%s -b bB zebra bgpd ospfd ospf6d ldpd

