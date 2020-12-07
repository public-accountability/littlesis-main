FROM littlesis/ruby:latest

RUN mkdir -p /littlesis
WORKDIR /littlesis
COPY ./Gemfile.lock ./Gemfile ./
RUN bundle install --jobs=2 --retry=5

EXPOSE 8080

CMD ["bundle", "exec", "puma"]
