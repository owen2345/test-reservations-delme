FROM ruby:3.1-slim as builder
RUN apt-get update && apt-get install curl gnupg build-essential libpq-dev -y
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq
RUN apt install yarn -y

RUN mkdir /app
WORKDIR /app

# Default port and web server command
CMD ["bin/rails server -p 3000 -b 0.0.0.0"]
EXPOSE 3000

#####################################
FROM builder AS development
# install google chrome for capybara
RUN apt-get install wget -y
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# install chromedriver for capybara
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

COPY package.json yarn.lock /app/
#RUN yarn install
COPY Gemfile* /app/
RUN bundle install --jobs 20 --retry 5
COPY . /app



