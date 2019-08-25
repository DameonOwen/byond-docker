# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Source Engine
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        ubuntu:18.04

LABEL       author="Pterodactyl Software" maintainer="support@pterodactyl.io"

ENV         DEBIAN_FRONTEND noninteractive \
            BYOND_MAJOR=512 \
            BYOND_MINOR=1468

# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y tar curl gcc g++ lib32gcc1 libgcc1 libcurl4-gnutls-dev:i386 libcurl4:i386 lib32tinfo5 libtinfo5:i386 lib32z1 libstdc++6 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libreadline5 libncursesw5 lib32ncursesw5 iproute2 gdb libsdl1.2debian libfontconfig telnet net-tools netcat libtcmalloc-minimal4:i386 unzip make\
            && useradd -m -d /home/container container \
            && cd /home/container \
            && curl "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip \
            && unzip byond.zip \
            && cd byond \
            && sed -i 's|install:|&\n\tmkdir -p $(MAN_DIR)/man6|' Makefile \
            && make install
            && cd .. \
            && rm -rf byond byond.zip

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
