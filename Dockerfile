FROM alpine:latest

RUN apk update
RUN apk add alpine-sdk cmake clang libressl-dev vim gdb
