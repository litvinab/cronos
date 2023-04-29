FROM yobasystems/alpine-docker

ADD crontabs/root /etc/crontabs/root
ADD entry.sh /entry.sh
RUN chmod 755 /entry.sh

CMD ["/entry.sh"]
