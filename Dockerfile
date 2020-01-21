FROM ubuntu:18.04

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    automake \
    ca-certificates \
    g++ \
    git \
    libtool \
    make \
    pkg-config \
    wget \
    libicu-dev \
    zlib1g-dev \
    libtiff5-dev \
    libjpeg8-dev \
    libpng-dev \
    libpango1.0-dev \
    libcairo2-dev \
    && apt-get install -y --no-install-recommends \
    asciidoc \
    docbook-xsl \
    xsltproc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

ENV TESSERACT_VER="4.1"

RUN wget http://www.leptonica.org/source/leptonica-1.79.0.tar.gz \
    && git clone -b ${TESSERACT_VER} https://github.com/tesseract-ocr/tesseract.git --single-branch \
    && tar -zxvf leptonica-1.79.0.tar.gz \
    && rm leptonica-1.79.0.tar.gz

WORKDIR /opt/leptonica-1.79.0

# leptonica-1.79.0のインストール
RUN ./configure \
    && make \
    && make install

WORKDIR /opt/tesseract

# tesseractのインストール(学習環境も併せて)
RUN ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && ldconfig \
    && make training \
    && make training-install

ENV TESSDATA_PREFIX="/usr/local/share/tessdata"

RUN wget https://github.com/tesseract-ocr/tessdata_best/raw/master/eng.traineddata -P ${TESSDATA_PREFIX} \
    && wget https://github.com/tesseract-ocr/tessdata_best/raw/master/jpn.traineddata -P ${TESSDATA_PREFIX} \
    && wget https://github.com/tesseract-ocr/tessdata_best/raw/master/jpn_vert.traineddata -P ${TESSDATA_PREFIX}

COPY ./resource/fonts.tgz /usr/share/fonts

WORKDIR /usr/share/fonts

RUN tar xvf fonts.tgz \
&& rm fonts.tgz

WORKDIR /opt/tesseract