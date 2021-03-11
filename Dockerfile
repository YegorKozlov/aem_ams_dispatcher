FROM centos/systemd

MAINTAINER Yegor Kozlov <https://github.com/YegorKozlov/>

# Install HTTPD and enable it
RUN yum -y install httpd; yum clean all; systemctl enable httpd.service

# Copy all config files to the image
COPY etc/httpd /etc/httpd
COPY etc/sysconfig /etc/sysconfig

# Copy the dispatcher *.so module
COPY usr/lib64/httpd/modules/mod_dispatcher.so /usr/lib64/httpd/modules/mod_dispatcher.so

# create directores for the dispatcher cache
RUN mkdir -p /mnt/var/www/html && \
    mkdir -p /mnt/var/www/default && \
    chown -R apache:apache /mnt/var/www

EXPOSE 80

CMD ["/usr/sbin/init"]

