# aem-dispatcher docker

AEM Dispatcher Docker


Build an Image

- place your httpd configurations to the **etc/httpd** folder
- build the image: **docker build --rm --no-cache -t ams-dispatcher .**
- start the container: **docker run --privileged --name ams-dispatcher --rm -p 80:80 ams-dispatcher** 
- stop the container: **docker stop  ams-dispatcher**

Add hosts:

- edit your hosts file and add 
```
127.0.0.1 localhost.we-retail.com
```
- start AEM Publish on port 4503
- navigate to http://localhost.we-retail.com/us/en

