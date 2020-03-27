FROM node:8.12-alpine
RUN apk update && apk add vim && apk add nodejs-npm && apk add bash
RUN apk add --update \
  python \
  python-dev \
  py-pip \
  build-base \
  && rm -rf /var/cache/apk/*
RUN npm install --upgrade npm && npm install -g nodemon && mkdir /app
WORKDIR /app
COPY . /app/
COPY .env /app/.env
RUN npm install
EXPOSE 5000
CMD nodemon index.js 5000
