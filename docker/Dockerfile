FROM alpine:latest

ENV TZ=Europe/Moscow

RUN apk add --no-cache curl bash tzdata
COPY ./src/run.sh /

RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD ["/run.sh"]