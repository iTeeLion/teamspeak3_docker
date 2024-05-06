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
    && tar xvjf ./teamspeak3-server_linux_amd64-3.13.7.tar.bz2 \
    && rm ./teamspeak3-server_linux_amd64-3.13.7.tar.bz2

RUN cp -r ./teamspeak3-server_linux_amd64/* /opt/ts3 \
    && rm -rf ./teamspeak3-server_linux_amd64

RUN echo "license_accepted=1" >> ./.ts3server_license_accepted

RUN ./ts3server

