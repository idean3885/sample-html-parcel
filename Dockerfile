FROM node:16-alpine AS node

FROM alpine:3.18

RUN apk update upgrade && \
    apk add git && \
    apk add ca-certificates && \
    apk add curl

# Copy node to alpine linux
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

# Copy yarn to alpine linux
COPY --from=node /opt/yarn* /opt/yarn
RUN ln -vfns /opt/yarn/bin/yarn /usr/local/bin/yarn
RUN ln -vfns /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

# npm run parcel dependancy
RUN apk add --update --no-cache py-pip make g++ util-linux

WORKDIR /app
COPY . /app
RUN npm ci

EXPOSE 1234
ENTRYPOINT npm run start

