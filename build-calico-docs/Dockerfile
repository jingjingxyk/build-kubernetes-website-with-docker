FROM ruby:latest AS calico_build_dev

RUN apt update -y && apt install -y gcc make cmake git curl wget ruby-dev

#ADD calico /calico

RUN git clone https://github.com/projectcalico/calico.git
WORKDIR /calico
ENV PROJECT_DIR=/calico
RUN git branch -a

RUN gem install bundler jekyll
# BUILD DOCUMENT
WORKDIR /calico/calico/
RUN cp /calico/calico/netlify/Gemfile Gemfile
RUN  bundle install --gemfile $PROJECT_DIR/calico/netlify/Gemfile

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

RUN make bin/helm
#ENV PATH=$PATH:$(pwd)/bin
WORKDIR /calico/calico/

RUN bundle exec    jekyll build  --config $PROJECT_DIR/calico/_config.yml,$PROJECT_DIR/calico/netlify/_config_latest.yml --destination _site
RUN ls -alh _site/ &&  ls -alh _site/
RUN  cp -R _site/ /site
ADD ./robots.txt /site/robots.txt

FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=calico_build_dev /site /usr/share/nginx/html/
COPY ./default.conf /etc/nginx/conf.d/default.conf

