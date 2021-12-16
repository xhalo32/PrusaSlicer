FROM debian:buster

RUN useradd --create-home --home-dir /home/prusaslicer prusaslicer

WORKDIR /home/prusaslicer

ENTRYPOINT ["/home/prusaslicer/build/src/prusa-slicer"]

RUN apt-get update \
  && apt-get install -y locales \
  && sed -i \
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

RUN apt-get install -y freeglut3 \
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
  libnlopt0 \
  libboost-all-dev \
  libopenvdb-dev \
  libcgal-dev \
  libwxgtk3.0

COPY --chown=prusaslicer:prusaslicer ./build ./build
COPY --chown=prusaslicer:prusaslicer ./resources ./resources

# RUN /home/prusaslicer/build/src/prusa-slicer
