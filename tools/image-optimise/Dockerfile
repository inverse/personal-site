FROM alpine:latest

RUN apk update \
    && apk add --no-cache jpegoptim optipng

WORKDIR /app

ADD script.sh .

ENTRYPOINT [ "/app/script.sh" ]
