FROM ruby:2.6.2 as base

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y --no-install-recommends \
          postgresql-client nodejs ghostscript \
        && rm -rf /var/lib/apt/lists

WORKDIR /usr/src/app

# cache gem installation separately from app
COPY .ruby-version ./
COPY Gemfile* ./

#replacing nproc with 2 to reduce number of jobs to run simultaneously. RUN bundle install --without test --jobs=$(2)
RUN bundle install --without test --jobs=2
# copy app
COPY . .
ENV RAILS_LOG_TO_STDOUT true
EXPOSE 3000

FROM base as development
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# It's called app rather than production because that's what the server that
# sits in front of it expects.
FROM base as app
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
# compile assets
RUN SKIP_S3=true rails assets:precompile
# default to production
ENV RACK_ENV production
ENV RAILS_ENV production
# expose static files for nginx to serve
VOLUME /usr/src/app/public
