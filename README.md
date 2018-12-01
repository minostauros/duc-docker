# duc-docker
[![Docker Automated build](https://img.shields.io/docker/automated/tigerdockermediocore/duc-docker.svg)](https://hub.docker.com/r/tigerdockermediocore/duc-docker) [![Docker Build Status](https://img.shields.io/docker/build/tigerdockermediocore/duc-docker.svg)](https://hub.docker.com/r/tigerdockermediocore/duc-docker)

Dockerized version of [duc](https://duc.zevv.nl), a disk usage analyzer.
See [docker hub](https://hub.docker.com/r/tigerdockermediocore/duc-docker/) to pull the images.

This image has some tweaks to achieve my personal need, but everything is straightforward (see its [github repo](https://github.com/minostauros/duc-docker/)).


## Usage
### Apache CGI Server
By default, this image will just start up as an apache server for duc databases. Say you have two db files named `one.db`, and `two.db` in your host directoy `/mydbs/` and a database file `/home/myduc.db` . Then running the following command
```sh
docker run -d -p 80:80 -v /mydbs/:/duc/db/:ro -v /home/myduc.db:/duc/.duc.db:ro tigerdockermediocore/duc-docker:latest
```
will provide following web pages
  - http://localhost:80/one.cgi    <- based on /mydbs/one.db mounted as /duc/db/one.db
  - http://localhost:80/two.cgi    <- based on /mydbs/two.db mounted as /duc/db/two.db
  - http://localhost:80/index.cgi  <- based on /home/myduc.db mounted as /duc/.duc.db


### duc Indexing
Mount directories you want to index into `/host` with readonly property. For example,
```sh
docker run -d -v /home:/host/home:ro -v /media:/host/media:ro tigerdockermediocore/duc-docker:latest duc index /host
```
will index `/home` and `/media`, creating `/duc/.duc.db` inside the container. So don't forget to pull out the db file afterward!

## References
  - Original duc: https://duc.zevv.nl
  - Reference duc-docker: https://hub.docker.com/r/digitalman2112/duc/
