FROM codesimple/elm:0.18

RUN npm install -g --silent yarn

WORKDIR /opt/snaeks

COPY package.json /opt/snaeks
COPY yarn.lock /opt/snaeks
RUN yarn install

COPY elm-package.json /opt/snaeks
RUN elm package install -y

COPY src /opt/snaeks/src
RUN yarn build

EXPOSE 5000
ENTRYPOINT yarn serve
