FROM alpine:latest

MAINTAINER zonghengbaihe521@qq.com


#RUN sed -i "s@http://dl-cdn.alpinelinux.org/@https://mirrors.huaweicloud.com/@g" /etc/apk/repositories
RUN apk update
RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync \
    build-base \
    libc6-compat

ARG HUGO_VERSION
ARG IS_NO_TOOLS

RUN mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz | tar -xz && \
    mv hugo /usr/local/bin/hugo && \
    addgroup -Sg 1000 hugo && \
    adduser -Sg hugo -u 1000 -h /src hugo
ADD website /website
WORKDIR /website
RUN apk add nodejs npm bash
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --nightly
ENV PATH="/root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin:$PATH"
RUN yarn install 
RUN git submodule update --init --recursive --depth 1
#RUN git pull --force
RUN cp -a -R /website/. /src
WORKDIR /src
RUN /usr/local/bin/hugo version
EXPOSE 1313
RUN  hugo --minify
#ENTRYPOINT ["/usr/local/bin/hugo", "server","--buildFuture", "--bind", "0.0.0.0"]

FROM nginx:alpine
MAINTAINER zonghengbaihe521@qq.com
LABEL author=jingjingxyk

COPY --from=0 /src/public/ /usr/share/nginx/html
RUN mkdir -p /usr/share/nginx/html/kubernetes-container-binnary
ADD ./tools /usr/share/nginx/html/kubernetes-container-binnary
RUN ls /usr/share/nginx/html/kubernetes-container-binnary > /usr/share/nginx/html/kubernetes-container-binnary/k8s-soft-list.txt
ADD ./default.conf /etc/nginx/conf.d/default.conf
RUN /bin/sh -c "if( ${IS_NO_TOOLS} );then rm -rf /usr/share/nginx/html/kubernetes-container-binnary; fi"

