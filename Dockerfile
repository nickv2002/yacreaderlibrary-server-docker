FROM debian:stretch

ARG YACR_COMMIT
LABEL maintainer="xthursdayx"

WORKDIR /src
WORKDIR git

RUN \
 echo "**** install runtime packages ****" && \
 apt-get update && \
 apt-get install -y \
    curl \
    git \
    qt5-default \
    libpoppler-qt5-dev \
    libpoppler-qt5-1 \
    wget \
    unzip \
    libqt5sql5-sqlite \
    libqt5sql5 \
    sqlite3 \
    libqt5network5 \
    libqt5gui5 \
    libqt5core5a \
    build-essential && \	
 echo "**** install YACReader ****" && \
 if [ -z ${YACR_COMMIT+x} ]; then \
	YACR_COMMIT=$(curl -sX GET https://api.github.com/repos/YACReader/yacreader/commits/develop \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 git clone -b develop --single-branch https://github.com/YACReader/yacreader.git . && \
 git checkout ${YACR_COMMIT} && \
 cd compressed_archive/unarr/ && \
 wget github.com/selmf/unarr/archive/master.zip && \
 unzip master.zip  && \
 rm master.zip && \
 cd unarr-master/lzmasdk && \
 ln -s 7zTypes.h Types.h && \
 cd /src/git/YACReaderLibraryServer && \
 qmake YACReaderLibraryServer.pro && \
 make  && \
 make install && \
 echo "**** cleanup ****" && \
 cd / && \
 apt-get clean && \
 apt-get purge -y git wget build-essential && \
 apt-get -y autoremove && \
 rm -rf \
        /src \
        /var/cache/apt

ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

VOLUME /comics

EXPOSE 8080

ENV LC_ALL=C.UTF8

ENTRYPOINT ["YACReaderLibraryServer","start"]
