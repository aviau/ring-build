FROM debian:jessie

RUN apt-get update && apt-get install -y git \
    autoconf \
    automake \
    cmake \
    libtool \
    libdbus-1-dev \
    libdbus-c++-dev \
    libupnp-dev \
    libgnutls28-dev \
    libebook1.2-dev \
    libclutter-gtk-1.0-dev \
    libclutter-1.0-dev \
    libglib2.0-dev \
    libgtk-3-dev \
    libnotify-dev \
    qtbase5-dev \
    qttools5-dev \
    qttools5-dev-tools \
    yasm \
    autopoint \
    unbound-anchor \
    git-core \
    autotools-dev \
    gnome-icon-theme-symbolic \
    gettext \
    libpulse-dev \
    libsamplerate0-dev \
    libdbus-1-dev \
    libasound2-dev \
    libexpat1-dev \
    libpcre3-dev \
    libyaml-cpp-dev \
    libboost-dev \
    libdbus-c++-dev \
    libsndfile1-dev \
    libsrtp-dev \
    libxext-dev \
    libxfixes-dev \
    yasm \
    autopoint \
    unbound-anchor \
    libspeex-dev \
    libspeexdsp-dev \
    autotools-dev \
    chrpath \
    uuid-dev \
    libudev-dev

RUN git clone --recursive https://github.com/savoirfairelinux/ring-project.git /ring-project
WORKDIR /ring-project
RUN cd client-gnome && git fetch https://gerrit-ring.savoirfairelinux.com/ring-lrc refs/changes/87/3887/6 && git checkout FETCH_HEAD

# Daemon configure
RUN mkdir -p daemon/contrib/native
RUN cd daemon/contrib/native && \
        ../bootstrap \
                --disable-ogg \
                --disable-flac \
                --disable-vorbis \
                --disable-vorbisenc \
                --disable-speex \
                --disable-sndfile \
                --disable-speexdsp && \
        make -j4
RUN cd daemon && \
        ./autogen.sh && \
        ./configure --prefix=/usr

# lrc configure
RUN cd lrc && \
        mkdir build && \
        cd build && \
        cmake  \
            -DRING_BUILD_DIR=/ring-project/daemon/src \
            -DCMAKE_INSTALL_PREFIX=/usr \
            -DENABLE_VIDEO=true \
            ..


# gnome client configure
ADD gnome/CMakeLists.txt /ring-project/client-gnome/CMakeLists.txt
ADD gnome/FindLibRingClient.cmake /ring-project/client-gnome/cmake/FindLibRingClient.cmake
RUN cd client-gnome && \
        mkdir build && \
        cd build && \
        cmake \
            -DCMAKE_INSTALL_PREFIX=/usr \
            -DLibRingClient_SRC_DIR=/ring-project/lrc/src \
            ..

# daemon build
RUN cd daemon && make -j4

# lrc build
RUN cd lrc/build && make -j4

# gnome client build
RUN cd client-gnome/build && make LDFLAGS="-lpthread" -j4
