FROM node:16-alpine3.15

WORKDIR /opt/test

COPY . /opt/test

RUN npm ci

CMD npm run test
