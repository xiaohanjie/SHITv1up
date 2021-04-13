FROM centos:centos7.6.1810
# MAINTAINER siddontang@gmail.com

# RUN apt-get -y -q update && \
#        apt-get -y -q install software-properties-common && \
#        apt-get -y -q update && \
#        apt-get install -qqy \
#        git \
#        gnuplot \
#        wget \
#        less vim # not required by chaos itself, just for ease of use
#
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]

RUN yum install -y bsdtar &&\
        yum install -y rsync &&\
        yum install -y libvirt &&\
        yum install -y libvirt-devel &&\
        yum install -y gcc &&\
        yum install -y openssh-server &&\
        yum install -y openssh-clients &&\
        yum install -y vim &&\
        yum install -y sshpass &&\
        yum install -y java


#RUN systemctl start libvirtd
#RUN systemctl enable libvirtd

# You need to locate chaos in this directory (up.sh does that automatically)
ADD vagrant /home/vagrant

RUN rpm -ivh /home/vagrant/rpm/*
RUN vagrant plugin install vagrant-libvirt

ADD ./bashrc /root/.bashrc

ADD ./init.sh /init.sh
RUN chmod +x /init.sh

#RUN ./init.sh
CMD ["/init.sh"]
#ENTRYPOINT ["/init.sh"]
CMD ["/usr/sbin/init"]
