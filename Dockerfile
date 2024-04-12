# docker build -f Dockerfile -t goapp .
# docker run -it -p 1234:1234 goapp
# WITH Go Modules

# If you are using docker buildx, use:
# docker buildx build -f Dockerfile -t goapp .

FROM golang:alpine AS builder


# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

RUN mkdir $GOPATH/src/server
ADD ./main.go $GOPATH/src/server
WORKDIR $GOPATH/src/server

RUN go mod init
RUN go mod tidy
RUN go mod download
RUN mkdir /pro
RUN go build -o /pro/server main.go

FROM alpine:latest

RUN mkdir /pro
COPY --from=builder /pro/server /pro/server

EXPOSE 1234
WORKDIR /pro
CMD [ "/pro/server" ]

