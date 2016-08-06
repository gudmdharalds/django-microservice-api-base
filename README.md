A basic Dockerfile for django-microservice API. 

# Purpose
If you are building microservice APIs using Django, this Dockerfile might
be helpful, as it provides the very basics needed to run such a microservice API. 
This includes an Apache-webserver, stripped down to run only Python and Django, 
based on CentOS. The server has some security-enhancements in place, also.

The docker process will launch only Apache on start. Apache will launch as non-root,
listening on port `8080`.

In your project's Dockerfile, you can specify a volume that should be mounted,
containing, for instance, all the secrets that the microservice needs to operate.

For instance: 
> VOLUME ["/var/www/api/code/api/settings/secrets/"]

You will also need to add a configuration-file for Apache, so that a virtual-host
will be recognized and your Python code will actually run when the Apache-server 
is called appropriately:

> ADD docker-files/*.conf /etc/httpd/conf.d/

See `examples/apache-vhost.conf` for an example Apache-configuration file. See 
also `èxamples/Dockerfile-example.txt`for an example Dockerfile that depends on
the current one. Be careful when you edit those files; every line is critical.
Be especially careful when you edit `apache-vhost.conf`, make sure that the path
to the `wsgi.py` file is correct.

The examples assume that the base-directory for the microservice is in 
`/var/www/api`, with the code available at `/var/www/api/code`. You might want
to keep it that way, to have some kind of similarity between microservices, and
to make deployment based on the examples easier.

To catch the log-files the Apache-server creates, you will have to mount 
`/etc/httpd/logs/` into a file-system on the Docker-host, and then harvest the
files. Make sure that Apache is able to write into this filesystem. You can
also override the log-configuration, of course.

# Building
To create the docker-image, run

> cd ~/build 

> git clone ...

> docker build -t django-microservice-api-base django-microservice-api-base

You can then base your Dockerfiles on this one, by including a line like this:

> FROM django-microservice-api-base

# Running

After creating your own Docker-image, you can launch it like this:

> docker run --volume=/home/docker/data/yourimage/logs/:/etc/httpd/logs/  -d -t yourimage

