#Docker-MYSQL

Dockerfile for multi deamon process using supervisor.
Using sshd and mysql.

CentOS6.4, Docker 0.7.2

#Usage

```
git clone git@github.com:yss44/docker_mysqld.git
cd docker_mysqld
docker build yoshiso/mysqld .
docker run -p 2222 -p 3306 -d yoshiso/mysqld
```


SSH listening port 2222

```
ssh -p 2222 -i path/to/identify_file yoshiso@XXX.XXX.XXX.XXX
```

Mysql listening port 3306

Host

    $ ssh -p 2222 -i sshd/id_docker_ssh.dev yoshiso@172.17.0.56

Container

```
$ mysql -u root -p
mysql> create database test;
mysql> grant all privileges on sample.* to test@'172.17.%.%' identified by 'password';
mysql> exit;
Bye
$ exit
```

Host

    $ mysql -u test -ppassword -h 172.17.0.56
    mysql>

ok!
