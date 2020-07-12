FROM debian:buster

RUN useradd --create-home --home-dir /home/prusaslicer prusaslicer

WORKDIR /home/prusaslicer

RUN apt-get update \
  && apt-get install -y \
  locales

RUN sed -i \
  -e 's/^# \(cs_CZ\.UTF-8.*\)/\1/' \
  -e 's/^# \(de_DE\.UTF-8.*\)/\1/' \
  -e 's/^# \(en_US\.UTF-8.*\)/\1/' \
  -e 's/^# \(es_ES\.UTF-8.*\)/\1/' \
  -e 's/^# \(fr_FR\.UTF-8.*\)/\1/' \
  -e 's/^# \(it_IT\.UTF-8.*\)/\1/' \
  -e 's/^# \(ko_KR\.UTF-8.*\)/\1/' \
  -e 's/^# \(pl_PL\.UTF-8.*\)/\1/' \
  -e 's/^# \(uk_UA\.UTF-8.*\)/\1/' \
  -e 's/^# \(zh_CN\.UTF-8.*\)/\1/' \
  /etc/locale.gen \
  && locale-gen

RUN apt-get update \
  && apt-get install -y \
  freeglut3 \
  libgtk2.0-dev \
  libwxgtk3.0-dev \
  libwx-perl \
  libxmu-dev \
  libgl1-mesa-glx \
  libgl1-mesa-dri \
  xdg-utils \
  jq \
  curl \
  ca-certificates \
  unzip \
  bzip2 \
  git \
  cmake \
  make \
  gcc \
  libboost-all-dev \
  libtbb-dev \
  libcurl4-openssl-dev \
  libcereal-dev \
  libnlopt-dev \
  libnlopt-cxx-dev \
  libopenvdb-dev \
  libopenvdb-tools \
  libcgal-dev \
  libdbus-1-dev \
  libudev-dev

# RUN apt-get install -y software-properties-common
# RUN apt-key adv --fetch-keys https://repos.codelite.org/CodeLite.asc
# RUN apt-add-repository 'deb https://repos.codelite.org/wx3.1.3/debian/ buster libs'
# RUN apt-get update
# RUN apt-get install -y \
#   libwxbase3.1-dev \
#   libwxgtk3.1-dev \
#   libwxgtk-webview3.1-dev \
#   libwxgtk-media3.1-dev \

RUN rm -r /usr/include/CGAL
COPY CGAL /usr/include/CGAL

USER prusaslicer

COPY --chown=prusaslicer:prusaslicer ./ ./

ENV TERM=xterm-256color
ENV PRUSASLICER_MAKEFLAGS=-j6

RUN mkdir ~/build \
  && cd ~/build \
  && cmake .. -DSLIC3R_WX_STABLE=1

# VOLUME /home/prusaslicer/build

RUN cd ~/build && make $PRUSASLICER_MAKEFLAGS

USER root
# RUN cd /home/prusaslicer/build && make install
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get autoclean
USER prusaslicer

ENTRYPOINT [ "/home/prusaslicer/build/src/prusa-slicer" ]
