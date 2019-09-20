FROM crops/poky:latest

COPY scripts/entrypoint.sh /
COPY scripts/poky-launch.sh /usr/bin

USER root

# Set proxy for apt
RUN echo "Acquire::http::Proxy \"http://192.168.1.107:8080/\";" > /etc/apt/apt.conf

RUN apt-get update \
       && apt-get install -y g++-multilib gcc-multilib vim \
       && apt-get install -y libncurses5-dev

RUN chmod 775 /usr/bin/poky-launch.sh && \
        rm /usr/bin/poky-entry.py

USER usersetup

ENTRYPOINT ["/entrypoint.sh"]
