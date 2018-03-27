FROM ubuntu:16.04

MAINTAINER Rendo Wibawa <rendo.aw@gmail.com>


USER root
WORKDIR /root

RUN apt-get update && apt-get -y install git \
    autoconf \
    automake \
    libtool \
    make \
    gawk \
    libreadline-dev \
    texinfo \
    dejagnu \
    pkg-config \
    libpam0g-dev \
    libjson-c-dev \
    bison \
    flex \
    python-pytest \
    libc-ares-dev \
    python3-dev \
    libsystemd-dev \
    python-ipaddr

RUN pip install sphinx

RUN groupadd -g 92 frr \
    && groupadd -r -g 85 frrvty \
    && adduser --system --ingroup frr --home /var/run/frr/ --gecos "FRR suite" --shell /sbin/nologin frr \
    && usermod -a -G frrvty frr

RUN git clone https://github.com/frrouting/frr.git frr

RUN cd frr \
&& ./bootstrap.sh \
&& ./configure \
    --prefix=/usr \
    --enable-exampledir=/usr/share/doc/frr/examples/ \
    --localstatedir=/var/run/frr \
    --sbindir=/usr/lib/frr \
    --sysconfdir=/etc/frr \
    --enable-pimd \
    --enable-watchfrr \
    --enable-ospfclient=yes \
    --enable-ospfapi=yes \
    --enable-multipath=64 \
    --enable-user=frr \
    --enable-group=frr \
    --enable-vty-group=frrvty \
    --enable-configfile-mask=0640 \
    --enable-logfile-mask=0640 \
    --enable-rtadv \
    --enable-fpm \
    --enable-systemd=yes \
    --with-pkg-git-version \
    --enable-exampledir \
    --enable-ldpd \
    --enable-shell-access \
    --enable-cumulus \
    --with-pkg-extra-version \
&& make \
&& make check  \
&& make install \
&& install -m 755 -o frr -g frr -d /var/log/frr \
&& install -m 775 -o frr -g frrvty -d /etc/frr \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/zebra.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/bgpd.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/ospfd.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/ospf6d.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/isisd.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/ripd.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/ripngd.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/pimd.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/ldpd.conf \
&& install -m 640 -o frr -g frr /dev/null /etc/frr/nhrpd.conf  \   
&& install -m 640 -o frr -g frrvty /dev/null /etc/frr/vtysh.conf \
&& install -m 644 tools/frr.service /etc/systemd/system/frr.service \
&& install -m 644 tools/etc/default/frr /etc/default/frr \
&& install -m 644 tools/etc/frr/daemons /etc/frr/daemons \
&& install -m 644 tools/etc/frr/daemons.conf /etc/frr/daemons.conf \
&& install -m 644 tools/etc/frr/frr.conf /etc/frr/frr.conf \
&& install -m 644 -o frr -g frr tools/etc/frr/vtysh.conf /etc/frr/vtysh.conf 

RUN echo "" > /etc/frr/daemons \
&& echo "zebra=yes" >> /etc/frr/daemons \
&& echo "bgpd=yes" >> /etc/frr/daemons \
&& echo "ospfd=yes" >> /etc/frr/daemons \
&& echo "ospf6d=yes" >> /etc/frr/daemons \
&& echo "ripd=no" >> /etc/frr/daemons \
&& echo "ripngd=no" >> /etc/frr/daemons \
&& echo "isisd=yes" >> /etc/frr/daemons \
&& echo "pimd=yes" >> /etc/frr/daemons \
&& echo "ldpd=yes" >> /etc/frr/daemons \
&& echo "nhrpd=no" >> /etc/frr/daemons \
&& echo "eigrpd=no" >> /etc/frr/daemons \
&& echo "babeld=no" >> /etc/frr/daemons \
&& echo "sharpd=no" >> /etc/frr/daemons 

copy run.sh /usr/sbin/

RUN chmod +x /usr/sbin/run.sh

CMD ["/usr/sbin/run.sh"]


