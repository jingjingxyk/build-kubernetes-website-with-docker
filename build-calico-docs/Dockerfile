FROM ruby:latest AS calico_build_dev

RUN apt update -y && apt install -y gcc make cmake git curl wget ruby-dev

#ADD calico /calico
RUN git clone https://github.com/projectcalico/calico.git
WORKDIR /calico
RUN git branch -a
RUN gem install bundler jekyll
RUN cp netlify/Gemfile Gemfile && bundle install
#RUN make bin/helm
#ENV PATH=$PATH:$(pwd)/bin
RUN bundle exec    jekyll build --config _config.yml,$(pwd)/netlify/_config_latest.yml --destination _site
RUN ls -alh _site/
RUN  cp -R _site/ /site


FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=calico_build_dev /site /usr/share/nginx/html/
COPY ./default.conf /etc/nginx/conf.d/default.conf
