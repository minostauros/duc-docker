FROM ubuntu:18.04
MAINTAINER minostauros <6764739+minostauros@users.noreply.github.com>

# Set correct environment variables
ENV HOME /duc

# Install Dependencies
RUN apt-get update -qq && \ 
	apt-get install -qq wget apache2 libncursesw5-dev libcairo2-dev libpango1.0-dev build-essential libtokyocabinet-dev && \ 
	apt-get autoremove && \
	apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

# Install duc
# /duc/db is a directory to mount multiple DBs, for server. duc_startup.sh look into this directory and create CGIs
RUN mkdir /duc && \
    mkdir /duc/db && \ 
    cd /duc && \
    wget https://github.com/zevv/duc/releases/download/1.4.4/duc-1.4.4.tar.gz && \
    tar xzf duc-1.4.4.tar.gz && \
    rm duc-1.4.4.tar.gz && \
    cd duc-1.4.4 && \
    ./configure && \ 
    make && \
    make install && \
    cd .. && \
    rm -rf duc-1.4.4

COPY assets/index.cgi /var/www/duc/
COPY assets/000-default.conf /etc/apache2/sites-available/
COPY assets/duc_startup.sh /duc/

#create a starter database so that we can set permissions for cgi access
RUN mkdir /host && \
	duc index /host/ && \
	chmod 777 /duc/ && \
	chmod 777 /duc/.duc.db && \
	a2enmod cgi && \
	chmod +x /duc/duc_startup.sh && \
	chmod +x /var/www/duc/index.cgi

ENV DUC_CGI_OPTIONS --list --tooltip --dpi=120
VOLUME /host /duc/db	
EXPOSE 80

WORKDIR /duc
CMD /duc/duc_startup.sh
