FROM debian:stretch as builder

LABEL maintainer="xthursdayx"

WORKDIR /src
WORKDIR git

RUN \
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
        build-essential
RUN \
 git clone https://github.com/YACReader/yacreader.git . && \
 git checkout develop
RUN \
 cd compressed_archive/unarr/ && \
 wget github.com/selmf/unarr/archive/master.zip && \
 unzip master.zip  && \
 rm master.zip && \
 cd unarr-master/lzmasdk && \
 ln -s 7zTypes.h Types.h
RUN \
 cd /src/git/YACReaderLibraryServer && \
 qmake YACReaderLibraryServer.pro && \
 make  && \
 make install

FROM alpine:latest

COPY --from=builder /usr/bin/YACReaderLibraryServer .

ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

VOLUME /comics

EXPOSE 8080

ENV LC_ALL=C.UTF8

ENTRYPOINT ["YACReaderLibraryServer","start"]
