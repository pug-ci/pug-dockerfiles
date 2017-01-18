FROM fluent/fluentd:latest-onbuild

MAINTAINER Pug CI Team

USER root
RUN apk add --update bash && rm -rf /var/cache/apk/*

ADD scripts/run.sh /run.sh
ADD scripts/setup_plugins.sh /setup_plugins.sh
RUN chmod 755 /*.sh

WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

RUN gem install fluent-plugin-parser
RUN gem install fluent-plugin-elasticsearch

EXPOSE 24224
EXPOSE 8888

CMD /run.sh
