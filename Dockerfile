FROM debian

ARG UID
ARG GID

RUN apt update && apt install -y sudo wget

RUN mkdir -p /opt/ts3 && chmod -R 775 /opt/ts3 && chown -R ts3:ts3 /opt/ts3

WORKDIR /opt/ollama

RUN useradd -u -U -G ts3 ts3 \
    && RUN usermod -u $UID ts3 \
    && groupmod -g $GID ts3

RUN chsh -s /bin/bash ts3

RUN wget https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_win64-3.13.7.zip
