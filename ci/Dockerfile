FROM debian:unstable-slim

ARG DEBIAN_FRONTEND=noninteractive

# Wait for Debian to ship libwayland-egl
ENV KNOWN_GOOD_MESA=67f7a16b5985
ENV KNOWN_GOOD_CTS=fd68124a565e
ENV KNOWN_GOOD_EPOXY=737b6918703c
ENV KNOWN_GOOD_QEMU=41feb5b955f0

ENV GOPATH=/usr/local/go
ENV PATH=$PATH:/usr/local/go/bin
ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:/usr/local/share/pkgconfig
ENV LDFLAGS="-L/usr/local/lib64"

ENV XDG_RUNTIME_DIR=/tmp
ENV WAYLAND_DISPLAY=wayland-0
ENV SDL_VIDEODRIVER=wayland

RUN echo 'path-exclude=/usr/share/doc/*' > /etc/dpkg/dpkg.cfg.d/99-exclude-cruft
RUN echo 'path-exclude=/usr/share/man/*' >> /etc/dpkg/dpkg.cfg.d/99-exclude-cruft
RUN echo '#!/bin/sh' > /usr/sbin/policy-rc.d
RUN echo 'exit 101' >> /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

RUN echo deb-src http://deb.debian.org/debian unstable main >> /etc/apt/sources.list
RUN apt-get update && apt-get -y install ca-certificates
RUN apt-get update && apt-get -y install git \
                                         check \
                                         weston \
                                         linux-image-amd64 \
                                         libgbm-dev \
                                         libxvmc-dev \
                                         autoconf \
                                         golang-go \
                                         git \
                                         ca-certificates \
                                         procps \
                                         systemd \
                                         dbus \
                                         busybox \
                                         cmake \
                                         spirv-headers \
                                         libsdl2-dev \
                                         strace \
                                         mercurial \
                                         systemd-coredump \
                                         kbd
RUN apt-get update && apt-get -y build-dep qemu \
                                           mesa \
                                           virglrenderer \
                                           libepoxy \
                                           libsdl2 \
                                           piglit

RUN go get -v github.com/tomeuv/fakemachine/cmd/fakemachine
RUN go install -x github.com/tomeuv/fakemachine/cmd/fakemachine

# Drop this once http://hg.libsdl.org/SDL/rev/295cf9910d75 makes it into Debian
RUN hg clone http://hg.libsdl.org/SDL
WORKDIR /SDL
RUN ./autogen.sh && \
    ./configure  --prefix=/usr/local \
                 --disable-rpath \
                 --enable-sdl-dlopen \
                 --disable-loadso \
                 --disable-nas \
                 --disable-esd \
                 --disable-arts \
                 --disable-alsa-shared \
                 --disable-pulseaudio-shared \
                 --enable-ibus \
                 --disable-x11-shared \
                 --disable-video-directfb \
                 --enable-video-opengles \
                 --enable-video-wayland \
                 --disable-wayland-shared \
                 --disable-video-vulkan && \
    make -j$(nproc) install && \
    rm -rf /SDL
WORKDIR /

RUN git clone https://github.com/anholt/libepoxy.git
WORKDIR /libepoxy
RUN git checkout $KNOWN_GOOD_EPOXY && \
    git log --oneline -n 1 && \
    ./autogen.sh --prefix=/usr/local && \
    make -j$(nproc) install && \
    rm -rf /libepoxy
WORKDIR /

RUN git clone https://github.com/KhronosGroup/VK-GL-CTS.git
WORKDIR /VK-GL-CTS
RUN git checkout $KNOWN_GOOD_CTS && \
    git log --oneline -n 1 && \
    mkdir build && \
    cd build && \
    cmake .. -DDEQP_TARGET=wayland && \
    make -j$(nproc) && \
    mv /VK-GL-CTS /usr/local/.
WORKDIR /

RUN git clone git://anongit.freedesktop.org/mesa/mesa
WORKDIR /mesa
RUN git checkout $KNOWN_GOOD_MESA && \
    git log --oneline -n 1 && \
    ./autogen.sh --prefix=/usr/local --with-platforms="drm x11 wayland" --with-dri-drivers= --with-gallium-drivers="swrast virgl" --enable-debug --enable-llvm ac_cv_path_LLVM_CONFIG=llvm-config-6.0 && \
    make -j$(nproc) install && \
    rm -rf /mesa
WORKDIR /

RUN git clone --depth 1 https://gitlab.freedesktop.org/tomeu/virglrenderer.git
WORKDIR /virglrenderer
RUN git log --oneline -n 1 && \
    ./autogen.sh --prefix=/usr/local && \
    make -j$(nproc) install && \
    rm -rf /virglrenderer
WORKDIR /

# fakemachine hardcodes the path to qemu-system-x86_64
RUN git clone git://git.qemu.org/qemu.git
WORKDIR /qemu
RUN git checkout $KNOWN_GOOD_QEMU && \
    git log --oneline -n 1 && \
    ./configure --prefix=/usr/local --target-list=x86_64-softmmu --enable-kvm --enable-virglrenderer --enable-debug --disable-werror --enable-sdl && \
    make -j$(nproc) install && \
    rm -rf /qemu && \
    ln -s /usr/local/bin/qemu-system-x86_64 /usr/bin/qemu-system-x86_64
WORKDIR /

COPY weston.service /usr/lib/systemd/system/.
