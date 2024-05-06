FROM debian

ARG UID
ARG GID

RUN apt update && apt install -y tar bzip2 wget

RUN useradd -U ts3 \
    && usermod -u $UID ts3 \
    && groupmod -g $GID ts3

RUN mkdir -p /opt/ts3 && chmod -R 775 /opt/ts3 && chown -R ts3:ts3 /opt/ts3

WORKDIR /opt/ts3

RUN chsh -s /bin/bash ts3

RUN wget https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2 \
    tar xvjf ./teamspeak3-server_linux_amd64-3.13.7.tar.bz2 \
    rm ./teamspeak3-server_linux_amd64-3.13.7.tar.bz2 \
    cp -r ./teamspeak3-server_linux_amd64/* /opt/ts3 \
    rm -rf ./teamspeak3-server_linux_amd64

RUN mkdir ./config \
    cp -fs ./config/query_ip_allowlist.txt ./query_ip_allowlist.txt 2> /dev/null \
    cp -fs ./config/query_ip_denylist.txt ./query_ip_denylist.txt 2> /dev/null \
    mkdir ./data \
    cp -n ./ts3server.sqlitedb ./data/ts3server.sqlitedb && rm ./ts3server.sqlitedb && cp -fs ./data/ts3server.sqlitedb ./ts3server.sqlitedb \
    cp -n ./ts3server.sqlitedb-shm ./data/ts3server.sqlitedb-shm && rm ./ts3server.sqlitedb-shm && cp -fs ./data/ts3server.sqlitedb-shm ./ts3server.sqlitedb-shm \
    cp -n ./ts3server.sqlitedb-wal ./data/ts3server.sqlitedb-wal && rm ./ts3server.sqlitedb-wal && cp -fs ./data/ts3server.sqlitedb-wal ./ts3server.sqlitedb-wal

RUN echo "license_accepted=1" >> ./.ts3server_license_accepted

RUN ./ts3server

