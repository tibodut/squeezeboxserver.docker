# squeezeboxserver.docker
Docker image for Logitech Media Server

## Build docker image
```
docker build -t arm32v5/squeezeboxserver:7.9 .
```

## Run squeezeboxserver docker image on RPi
```
docker run -d --restart=always -name squeezeboxserver --network squeezebox -p 80:9000 -v $MUSIC_FOLDER:/music arm32v5/squeezeboxserver:7.9
```
