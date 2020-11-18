FROM ruby:2.7.2-alpine

RUN gem install bundler -v 2.1.4

WORKDIR app
EXPOSE 4567

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY * ./

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "4567"]
