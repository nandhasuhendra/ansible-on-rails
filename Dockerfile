FROM ruby:2.5.1-alpine

RUN apk add --no-cache sqlite sqlite-dev nodejs yarn build-base tzdata
RUN apk --update add sudo python py-pip openssl ca-certificates
RUN apk --update add --virtual build-dependencies python-dev libffi-dev openssl-dev build-base
RUN pip install --upgrade pip cffi \
    && pip install ansible
RUN apk --update add sshpass openssh-client rsync \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /etc/ansible \
    && echo 'localhost' > /etc/ansible/hosts

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install

COPY . ./

RUN bin/rails db:migrate RAILS_ENV=production\
    && bin/rails db:seed RAILS_ENV=production\
    && RAILS_ENV=production bin/rails webpacker:compile

EXPOSE 3000

RUN chmod +x start.sh
CMD ["./start.sh"]
