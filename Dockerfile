FROM alpine:latest

RUN apk update && \
	apk add alpine-sdk cmake clang libressl-dev vim gdb
