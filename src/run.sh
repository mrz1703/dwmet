#!/bin/bash
set -ex


# Env
APP_REFRESH_TIME=${APP_REFRESH_TIME:-10}
APP_CHECK_TIMEOUT=${APP_TIMEOUT:-5}
APP_LIST_DOMAINNAME=${APP_LIST_DOMAINNAME}
APP_INFLUXDB_HOST=${APP_INFLUXDB_HOST}
APP_INFLUXDB_DB=${APP_INFLUXDB_DB}

[[ -z $APP_LIST_DOMAINNAME ]] && echo 'Set env APP_LIST_DOMAINNAME' && exit 1
[[ -z $APP_INFLUXDB_HOST ]] && echo 'Set env APP_INFLUXDB_HOST' && exit 1
[[ -z $APP_INFLUXDB_DB ]] && echo 'Set env APP_INFLUXDB_DB' && exit 1


sort_domains() {
  IFS=',' read -ra ADDR <<< "$APP_LIST_DOMAINNAME"

  for addr in ${ADDR[@]}
  do
    echo "$addr"
  done | rev | sort | uniq | sort | rev | xargs
}

timestamp() {
    date +"%s000000000"
}

get_metrics() {
    metrics=$(curl --max-time $APP_CHECK_TIMEOUT --connect-timeout $APP_CHECK_TIMEOUT -w \
        "web_metrics,address=$domainname time_namelookup=%{time_namelookup},time_connect=%{time_connect},time_appconnect=%{time_appconnect},time_pretransfer=%{time_pretransfer},time_redirect=%{time_redirect},time_starttransfer=%{time_starttransfer},time_total=%{time_total},http_code=%{http_code},size_download=%{size_download},size_header=%{size_header},size_request=%{size_request},size_upload=%{size_upload},speed_download=%{speed_download},speed_upload=%{speed_upload} $(timestamp)" \
            -o /dev/null -s "$domainname" | sed -r 's|([0-9]),([0-9])|\1.\2|g')

    curl -i -XPOST "$APP_INFLUXDB_HOST/write?db=$APP_INFLUXDB_DB" -s --data-binary @- <<< $metrics
}




trap 'echo -e "\nTRAP SIGNAL STOP\n"; exit 1' SIGINT SIGTERM SIGKILL

SORT_DOMAINS=`sort_domains`
echo "LIST_ADDRESS: $APP_LIST_DOMAINNAME"
echo "LIST_ADDRESS (SORTED):"; echo $SORT_DOMAINS | sed -e 's| |\n|g'

while true; do
    for domainname in $SORT_DOMAINS; do
        get_metrics &
    done
    sleep $APP_REFRESH_TIME
done