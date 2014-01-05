# DOCKER-MYSQLD
#
# VERSION       1

FROM centos

MAINTAINER yoshiso

RUN yum -y update

#Dev tools for all Docker
RUN yum -y install git vim
RUN yum -y install passwd openssh openssh-server openssh-clients sudo

########################################## sshd ##############################################

# create user
RUN useradd yoshiso
RUN passwd -f -u yoshiso
RUN mkdir -p /home/yoshiso/.ssh;chown yoshiso /home/yoshiso/.ssh; chmod 700 /home/yoshiso/.ssh
ADD sshd/authorized_keys /home/yoshiso/.ssh/authorized_keys
RUN chown yoshiso /home/yoshiso/.ssh/authorized_keys;chmod 600 /home/yoshiso/.ssh/authorized_keys
# setup sudoers
RUN echo "yoshiso ALL=(ALL) ALL" >> /etc/sudoers.d/yoshiso

# setup sshd
ADD sshd/sshd_config /etc/ssh/sshd_config
RUN /etc/init.d/sshd start;/etc/init.d/sshd stop

#######################################  Supervisord  ########################################

RUN wget http://peak.telecommunity.com/dist/ez_setup.py;python ez_setup.py;easy_install distribute;
RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py;python get-pip.py;
RUN pip install supervisor

ADD supervisor/supervisord.conf /etc/supervisord.conf

#######################################  Mysql  ########################################

RUN yum -y install mysql-server mysql mysql-devel

ADD mysql/my.cnf /etc/my.cnf
VOLUME ["/var/lib/mysql"]        # mysqlによる書き込みを永続化

RUN touch /etc/sysconfig/network #This file is needed in /etc/init.d/mysqld

ADD mysql/start.sh /start.sh
RUN chmod 700 start.sh

###################################### Docker config #########################################


# expose for sshd,mysqld

EXPOSE 2222 3306

CMD ["/usr/bin/supervisord"]

