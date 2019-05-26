FROM arm64v8/nginx:1.16.0-alpine
ENV NGINX_VERSION 1.16.0


MAINTAINER docker@intrepid.de

ENV DOCKER_GEN_VERSION 0.7.4

# Install wget and install/updates certificates
# Install Forego
ADD ./forego /usr/local/bin/forego
RUN chmod u+x /usr/local/bin/forego && \
    passwd -l root ; \
#    apk upgrade --no-cache && \
#    apk --no-cache add --virtual .run-deps \
    apk --update --upgrade --no-cache add \
      ca-certificates \
      bash \
      wget \
      openssl && \
    update-ca-certificates && \
# Configure Nginx and apply fix for very long server names
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf && \
    wget --quiet https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
    tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
    rm /docker-gen-alpine-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -rf /var/www/localhost

COPY network_internal.conf /etc/nginx/

COPY . /app/
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam"]
VOLUME ["/var/cache/nginx"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
