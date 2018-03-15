FROM ruby:2.1.5
RUN apt-get update -qq && apt-get install -y build-essential ruby-dev libxslt1-dev libxml2-dev nodejs sqlite3

RUN git clone https://github.com/nomlab/camome.git -b 20160216_demo

WORKDIR camome

ADD Gemfile Gemfile
RUN bundle install --path vendor/bundle
ADD config/secrets.yml config/secrets.yml
RUN git submodule init
RUN git config submodule.vendor/assets/bootstrap-table.url https://github.com/wenzhixin/bootstrap-table.git
RUN git config submodule.vendor/assets/jsSHA.url https://github.com/Caligatio/jsSHA.git
RUN git submodule update
ADD db/development.sqlite3.bak db/development.sqlite3
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s"]