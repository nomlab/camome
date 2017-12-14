FROM ruby:2.1.5
RUN apt-get update -qq && apt-get install -y build-essential ruby-dev libxslt1-dev libxml2-dev libpq-dev nodejs sqlite3 postgresql-client redis-server

RUN git clone https://github.com/nomlab/camome.git

WORKDIR camome

RUN bundle install --path vendor/bundle
ADD config/secrets.yml config/secrets.yml
ADD config/application_settings.yml config/application_settings.yml
ADD config/database.yml config/database.yml
RUN git submodule init
RUN git config submodule.vendor/assets/bootstrap-table.url https://github.com/wenzhixin/bootstrap-table.git
RUN git config submodule.vendor/assets/jsSHA.url https://github.com/Caligatio/jsSHA.git
RUN git submodule update 