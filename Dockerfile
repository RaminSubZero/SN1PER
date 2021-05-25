FROM kalilinux/kali-rolling

RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
        && apt-get -yqq update \
        && apt-get -yqq dist-upgrade \
        && apt-get clean
RUN apt-get install -yqq metasploit-framework

RUN apt-get install -yqq python3-pip

RUN sudo pip3 install python-owasp-zap-v2.4 && pip3 install python-owasp-zap-v2.4

RUN sed -i 's/systemctl status ${PG_SERVICE}/service ${PG_SERVICE} status/g' /usr/bin/msfdb && \
    service postgresql start && \
    msfdb reinit

COPY . .

RUN cd Sn1per-9.0 \
    && ./install.sh

ENTRYPOINT [ "/usr/bin/sniper" ]
