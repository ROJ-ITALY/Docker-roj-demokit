FROM crops/poky:latest

COPY scripts/entrypoint.sh /
COPY scripts/poky-launch.sh /usr/bin
COPY scripts/usersetup.py /usr/bin/

USER root

# Set proxy for apt. Uncomment the line below if you need to use a proxy server: set <IP> and <port> with yours.
#RUN echo "Acquire::http::Proxy \"http://192.168.1.107:8080/\";" > /etc/apt/apt.conf

RUN apt-get update \
       && apt-get install -y g++-multilib gcc-multilib vim \
       && apt-get install -y libncurses5-dev \
       && apt-get install -y python-dev

RUN chmod 775 /usr/bin/poky-launch.sh && \
        rm /usr/bin/poky-entry.py

RUN chmod 775 /usr/bin/usersetup.py

USER usersetup

ENTRYPOINT ["/entrypoint.sh"]
