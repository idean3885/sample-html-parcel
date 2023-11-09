FROM node:20-alpine AS node

FROM alpine:3.18

RUN apk update && \
    apk upgrade && \
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

# install python3 for node parcel
RUN apk add --no-cache python3 py3-pip


WORKDIR /app
COPY . /app
RUN npm install 2>&1 && \
    npm install -g node-gyp && \
    npm install libxmljs

EXPOSE 1234

ENTRYPOINT while :; do echo 'Press <CTRL+C> to exit.'; sleep 1; done

