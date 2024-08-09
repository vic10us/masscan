[![Docker](https://github.com/vic10us/masscan-docker/actions/workflows/docker-publish.yml/badge.svg)](https://githu>

# MASSCAN Docker base image layer

This is the masscan docker image

## Build image

```bash
docker build --build-arg="VERSION=1.0.0" -t vic10us/masscan:latest -f ./src/Dockerfile .
```

## Running a simple scan

```bash
docker run -it fortifydata/masscan -p 0-1024 10.1.1.0/24 --rate 300000
```

## Run a scan all TCP and UDP ports and store the results to a json file on the host machine

```bash
docker run -v ~/:/data -it fortifydata/masscan 10.1.1.0/24 \
    -p0-65535,U:1-65535 \
    --rate 800000  \
    -oJ /data/file$(date +"%y%m%d%H%M%S").json \
    --banners \
    --open-only \
    --http-user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
```