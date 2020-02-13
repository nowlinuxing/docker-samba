FROM ubuntu:19.10

RUN apt update \
    && apt install -y \
    samba

RUN mkdir /mount \
    && cp /etc/samba/smb.conf /etc/samba/smb.conf.orig

ADD https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-x86_64-linux /root/mitamae
RUN chmod +x /root/mitamae

COPY samba.sh smb.conf.base /root/

EXPOSE 139 445

CMD ["/root/samba.sh"]
