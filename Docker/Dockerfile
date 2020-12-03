FROM node:lts-alpine
LABEL maintainer="Evine Deng <evinedeng@foxmail.com>"
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' /etc/apk/repositories \
    && apk update -f \
    && apk --no-cache add -f bash \
                             coreutils \
                             git \
                             wget \
                             curl \
                             nano \
                             tzdata \
                             perl \
                             openssl \
    && rm -rf /var/cache/apk/*
ENV HOME=/root LC_CTYPE=zh_CN.UTF-8 LANG=en_US.UTF-8 SHELL=/bin/bash PS1="\u@\h:\w \$ "
COPY Docker/entrypoint.sh /entrypoint.sh
COPY first_run.sh /first_run.sh 
RUN chmod 777 /entrypoint.sh \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone
WORKDIR /root
VOLUME /root
ENTRYPOINT /entrypoint.sh
