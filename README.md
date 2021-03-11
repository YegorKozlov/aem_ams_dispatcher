# aem-dispatcher docker

## AMS-Compatible Dispatcher Docker Image



## Dockerfile


The AMS Dispatcher Docker Image leverages the [Official CentOS systemd docker container](https://hub.docker.com/r/centos/systemd/).
*systemd* is important because AMS runs HTTPd as a systemd service and reads variables from _/etc/sysconfig/httpd_ on service startup.

! Note that /etc/sysconfig/httpd is specific to centos-based distributions which include Centos, Red Hat and Amazon Linux. 

```dockerfile
FROM centos/systemd

# Install HTTPD and enable it
RUN yum -y install httpd mod_ssl mod_so mod_security openssl; yum clean all; systemctl enable httpd.service

# Copy the dispatcher *.so module
COPY usr/lib64/httpd/modules/mod_dispatcher.so /usr/lib64/httpd/modules/mod_dispatcher.so

# Copy all config files to the image
COPY etc/httpd /etc/httpd

# Copy environment variables
COPY etc/sysconfig /etc/sysconfig

# create directores for the dispatcher cache
RUN mkdir -p /mnt/var/www/html && \
    mkdir -p /mnt/var/www/default && \
    chown -R apache:apache /mnt/var/www

EXPOSE 80

CMD ["/usr/sbin/init"]
```

## Build the image

```shell
$ docker build --rm --no-cache -t ams-dispatcher .
```

## Start the container

```shell
$ docker run --privileged --name ams-dispatcher --rm -p 80:80 ams-dispatcher
```
This will start the Centos7 container with Httpd and publishes the 80 port from the container to the host.

## Test it out

edit your hosts file and add 
```
127.0.0.1 localhost.we-retail.com
```
start AEM Publish on port 4503
http://localhost.we-retail.com/content/we-retail/us/en.html

## Dispatcher Logs
Connect to a running container and tail logs in /etc/httpd/logs/*

```shell
$ docker exec -it ams-dispatcher bash
[root@2eab4de89b31 /]# cd /etc/httpd/logs
[root@2eab4de89b31 logs]# tail -f dispatcher.log
[Tue Mar 02 15:22:50 2021] [D] [pid 8] Adding request header: X-Forwarded-For
[Tue Mar 02 15:22:50 2021] [D] [pid 8] Adding request header: Server-Agent
[Tue Mar 02 15:22:50 2021] [D] [pid 8] response.status = 200
[Tue Mar 02 15:22:50 2021] [D] [pid 8] response.headers[Date] = "Tue, 02 Mar 2021 15:22:50 GMT"
[Tue Mar 02 15:22:50 2021] [D] [pid 8] response.headers[X-Content-Type-Options] = "nosniff"
[Tue Mar 02 15:22:50 2021] [D] [pid 8] response.headers[Content-Type] = "application/json;charset=iso-8859-1"
...
```

## Environment variables
Environment-specific parameters such as AEM URL and log level can be customized [/etc/sysconfig/httpd](./etc/sysconfig/httpd)

```shell
appId="we_retail"
DISP_ID="dispatcher1docker"
PUBLISH_IP="host.docker.internal"
PUBLISH_PORT="4503"
PUBLISH_DEFAULT_HOSTNAME="localhost.we-retail.com"
PUBLISH_DOCROOT="/mnt/var/www/default"
DISP_LOG_LEVEL="debug"
```

