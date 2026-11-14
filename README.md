# Решение уровня на 4 балла

```sh
docker build -t ipr:1 .
./run_docker.sh
./test.sh
docker logs ipr
```

Логи в task1.log


# Решение уровня на 6 баллов

## Запуск

```sh
cp .env.example .env
docker compose up -d --build
```
При необходимости можно поменять `.env`, но нужны обязательные переменные окружения.

## .env

Все как app/README.md. Но есть еще один обязательный параметр.
```sh
OUTSIDE_PORT=8080           # локальный порт
```

## Проверка
Собрал и запустил новый контейнер
`docker compose up -d --build`. После этого запустил `test.sh`
```sh
{"greeting": "Wake up, Neo!", "count": 0, "hostname": "9425edb3d05d", "storage": "sqlite"}
{"greeting": "Wake up, Neo!", "count": 1, "hostname": "9425edb3d05d", "storage": "sqlite"}
{"status": "ready", "storage": "sqlite"}
```
В `test.sh` отправился один POST зарпос который увеличил счетчик. 
Удалил контейнер

```sh
docker kill ipr-app-1
docker rm ipr-app-1
```
Запустил новый контейнер и запустил `test.sh`
```sh
docker compose up -d
./test.sh
{"greeting": "Wake up, Neo!", "count": 1, "hostname": "9ca553e81e83", "storage": "sqlite"}
{"greeting": "Wake up, Neo!", "count": 2, "hostname": "9ca553e81e83", "storage": "sqlite"}
{"status": "ready", "storage": "sqlite"}
```
Счетчик сохранился после удаления контейнера.


# Решение уровня на 8 баллов

Добавил redis. Запуск остался таким же.

## Проверка

Проверка перезапуска контейнера. Счетчик остается таким же.
```sh
curl -X POST 127.0.0.1:8080/increment
        {"greeting": "Wake up, Neo!", "count": 12, "hostname": "19ce102ee888", "storage": "redis"}
docker compose down
docker compose up -d
curl 127.0.0.1:8080/
        {"greeting": "Wake up, Neo!", "count": 12, "hostname": "5cd9bcb19225", "storage": "redis"}

```

Проверка остановки redis. Сервис работает, но redis не отвечает.
```sh
docker compose stop redis
curl 127.0.0.1:8080/healthz
    {"status": "alive"}
curl 127.0.0.1:8080/readyz
    {"error": "storage_unavailable"}
curl -X POST 127.0.0.1:8080/increment
    {"error": "storage_unavailable"}
```
Проверка запуска redis. Все продолжает работать.
```sh
docker compose start redis
curl 127.0.0.1:8080
    {"greeting": "Wake up, Neo!", "count": 12, "hostname": "5cd9bcb19225", "storage": "redis"}
curl -X POST 127.0.0.1:8080/increment
    {"greeting": "Wake up, Neo!", "count": 13, "hostname": "5cd9bcb19225", "storage": "redis"}
```