# [Docker-H5ai](https://github.com/IllyaTheHath/Docker-H5ai)

[![Docker](https://img.shields.io/badge/docker-latest-blue?logo=docker)](https://hub.docker.com/r/illyathehath/h5ai)
[![Docker Builds](https://img.shields.io/docker/cloud/build/illyathehath/h5ai)](https://hub.docker.com/r/illyathehath/h5ai/builds)
[![License](https://img.shields.io/github/license/IllyaTheHath/Docker-H5ai)](https://github.com/IllyaTheHath/Docker-H5ai/blob/master/LICENSE)

Another docker version of **[h5ai](https://larsjung.de/h5ai/)** file indexer for HTTP web servers, with file managent using **[File Browser](https://filebrowser.org/)**.

## How to use this image

### Using Docker Commands
```
docker run -d \
-p 80:80 --name=h5ai --restart=always \
-v $(pwd)/h5ai/files:/www \
-v $(pwd)/h5ai/filebrowser:/etc/filebrowser \
illyathehath/h5ai
```
The path */www* is where h5ai and your files places.  
The path */etc/filebrowser* is where File Browser database places.  

File managent(File Browser) path is under http://yourdomain/manage/ (Don't forge '/' at the end of the url)
Default username and password are all ***admin***

### Using Docker Compose
```
version: "3"
services:
  h5ai:
    image: illyathehath/h5ai
    restart: always
    ports:
      - "80:80"
    volumes:
      - $(pwd)/h5ai/files:/www
      - $(pwd)/h5ai/filebrowser:/etc/filebrowser
```

### Build your own image
```docker build -t your/h5ai .```

Please note that there are four environment variable:  
***APK_MIRROR*** is alpine package manager's source mirror, default value is ***mirrors.tuna.tsinghua.edu.cn*** which is located in china.  
***H5AI_VERSION*** is the version of h5ai, the newest is ***0.29.2*** for now.  
***TZ*** is the timezone of the container, default is ***Asia/Shanghai*** (CST).  
***TZ_PHP*** is the timezone of php inside the container,default is ***Asia\\/Shanghai*** (CST).  