# Readme
Сервис собирает информацию о времени соединения с http(s) доменом, а так же общее время и скорость загрузки страницы.

# Переменные окружения

 - `APP_REFRESH_TIME` - (int) - Частота получения и пуша метрик в influxdb в секундах (Default: 10)
 - `APP_CHECK_TIMEOUT` - (int) - Максимальное время ожидания ответа в секундах (Default: 5)
 - `APP_INFLUXDB_HOST` - (ip:port) - Адрес и порт хоста influxdb
 - `APP_INFLUXDB_DB` - (string) - Имя базы данных influxdb
 - `APP_LIST_DOMAINNAME` - (string) - Список адресов для которых будет собираться метрика через запятую. (Пример: "https://yandex.ru,https://google.com")

# Пример дашборда в grafana
[![N|Solid](https://i.imgur.com/iVBa36A.png)](https://i.imgur.com/iVBa36A.png)
[![N|Solid](https://i.imgur.com/LXtlFzu.png)](https://i.imgur.com/LXtlFzu.png)
[![N|Solid](https://i.imgur.com/RQc2vee.png)](https://i.imgur.com/RQc2vee.png)

