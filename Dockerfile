FROM centos/systemd

MAINTAINER Yegor Kozlov <https://github.com/YegorKozlov/>

# Install HTTPD and enable it
RUN yum -y install httpd mod_ssl mod_so mod_security openssl; yum clean all; systemctl enable httpd.service

# Copy all config files to the image
COPY etc/httpd /etc/httpd
COPY etc/sysconfig /etc/sysconfig

# Copy the dispatcher *.so module
COPY usr/lib64/httpd/modules/mod_dispatcher.so /usr/lib64/httpd/modules/mod_dispatcher.so

# create directory for the dispatcher cache
RUN mkdir -p /mnt/var/www/default
RUN chown -R apache:apache /mnt/var/www/default

CMD ["/usr/sbin/init"]

