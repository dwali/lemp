# LEMP
Docker image with Linux, nginx, mysql(mariaDB), PHP - for development PHP aplication

## build container
```bash
docker build . -t dwali/lemp
```

## run container
```bash
docker run -p 80:80 -v $(pwd)/www:/www --name -d lemp dwali/lemp
```
