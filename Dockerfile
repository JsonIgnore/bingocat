FROM ruby:2.7.2-alpine

RUN gem install bundler -v 2.1.4

RUN apk add make g++ sqlite-dev

COPY Gemfile Gemfile.lock /home/app/
WORKDIR /home/app

RUN mkdir /home/app/db
VOLUME ["/home/app/db"]

EXPOSE 4567

RUN bundle install

COPY app.rb config.ru package.json webpack.config.js /home/app/
COPY dist /home/app/dist
COPY lib /home/app/lib
COPY public /home/app/public
COPY src /home/app/src
COPY views /home/app/views

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "4567"]
