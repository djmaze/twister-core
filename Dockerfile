#
# Dockerfile for building Twister peer-to-peer micro-blogging
#
FROM mazzolino/armhf-ubuntu:14.04

# Install twister-core
RUN apt-get update
RUN apt-get install -y git autoconf libtool build-essential libboost-all-dev libssl-dev libdb++-dev libminiupnpc-dev && apt-get clean
#RUN git clone https://github.com/miguelfreitas/twister-core.git
ADD . /twister-core
RUN cd twister-core && \
    ./bootstrap.sh --disable-sse2 --with-boost-libdir=/usr/lib/arm-linux-gnueabihf && \
    make

# Install twister-html
RUN git clone https://github.com/miguelfreitas/twister-html.git /twister-html

# Configure HOME directory
# and persist twister data directory as a volume
ENV HOME /root
VOLUME /root/.twister

# Run twisterd by default
ENTRYPOINT ["/twister-core/twisterd", "-rpcuser=user", "-rpcpassword=pwd", "-rpcallowip=172.17.42.1", "-htmldir=/twister-html", "-printtoconsole"]
EXPOSE 28332
