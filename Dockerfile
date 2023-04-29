FROM yobasystems/alpine-docker

ADD crontab.txt /crontab.txt
COPY entry.sh /entry.sh
RUN chmod 755 /entry.sh
RUN /usr/bin/crontab /crontab.txt

CMD ["/entry.sh"]
