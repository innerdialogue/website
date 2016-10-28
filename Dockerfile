FROM debian:wheezy

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl procps && \
    rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.1 && \
    rm -rf /var/lib/apt/lists/* && \
    bash -c 'source /usr/local/rvm/scripts/rvm; rvm cleanup all'

COPY Gemfile Gemfile.lock /app/
WORKDIR /app

RUN bash -c '\
    source /usr/local/rvm/scripts/rvm; \
    gem install bundler && \
    gem install puma -v 2.15.3 && \
    bundle install && \
    rvm cleanup all'

COPY . /app

EXPOSE 9292

ENTRYPOINT ["/app/scripts/start.sh"]
CMD puma
