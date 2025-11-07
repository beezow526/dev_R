FROM rocker/rstudio:latest

ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
RUN sed -i '$d' /etc/locale.gen \
  && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Update and install necessary libraries
RUN apt-get update && apt-get install -y \
  cmake \
  fonts-ipaexfont \
  fonts-noto-cjk \
  libxml2-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  zlib1g-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libpng-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libtiff5-dev \ 
  libjpeg-dev \ 
  && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages('languageserver', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('lme4', 'bnlearn', 'rbmn', 'penalized', 'corpcor'), dependencies = TRUE)"
RUN R -e "if (!require('BiocManager', quietly = TRUE)) install.packages('BiocManager'); BiocManager::install('Rgraphviz')"
RUN R -e "install.packages('tidyverse', dependencies = TRUE)"
