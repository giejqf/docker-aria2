FROM ubuntu:latest

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        ca-certificates libxml2 libsqlite3-0 libgnutls30 \
	libssh2-1 libc-ares2 \
	libgnutls-dev nettle-dev libgmp-dev libssh2-1-dev \
	libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev \
	libxml2-dev libcppunit-dev autotools-dev \
	pkg-config autoconf automake autopoint libtool \
	git curl g++ make && \
    git clone https://github.com/aria2/aria2 && \
    cd /aria2 && \
    git checkout -b release-1.26.1 && \
    autoreconf -i && \
    ./configure && \
    make && \
    make install && \
    cd / && \
    rm -rf /aria2 && \
    apt-get -y purge \
	libgnutls-dev nettle-dev libgmp-dev libssh2-1-dev \
	libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev \
	libxml2-dev libcppunit-dev autotools-dev \
	pkg-config autoconf automake autopoint libtool \
	git curl g++ make && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    mkdir -p /app && \
    mkdir -p /app/download && \
    
ADD aria2.conf /app/aria2.conf
WORKDIR /app
VOLUME ["/app/download"]

EXPOSE 6800
ENTRYPOINT ["aria2c", "--conf-path=/app/aria2.conf"]
