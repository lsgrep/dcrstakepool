## build container
FROM golang:alpine AS build-env

RUN apk update; apk add git build-base

WORKDIR $GOPATH/src/github.com/lsgrep/dcrstakepool

ADD . $GOPATH/src/github.com/lsgrep/dcrstakepool

RUN cd $GOPATH/src/github.com/lsgrep/dcrstakepool;\
    GO111MODULE=on go mod vendor && go build && cd ../ &&  mv dcrstakepool /dcrstakepool

## final container
FROM alpine
RUN apk update && apk add ca-certificates bash && rm -rf /var/cache/apk/*

## for permission denied etc issues, BTW not a good practice ,  TODO
USER root

WORKDIR /work/dcrstakepool

COPY --from=build-env /dcrstakepool /work/dcrstakepool

CMD ["/work/dcrstakepool/dcrstakepool"]