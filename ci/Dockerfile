FROM debian:unstable-slim

RUN mkdir -p /ccache
COPY ccache/* /ccache/.
ENV CCACHE_BASEDIR=/
ENV CCACHE_DIR=/ccache

ENV DEBIAN_FRONTEND=noninteractive
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
RUN apt-get update && \
    apt-get -y install ca-certificates && \
    apt-get -y install --no-install-recommends \
      mercurial \
      libgbm-dev \
      libxvmc-dev \
      libsdl2-dev \
      autoconf \
      golang-go \
      cmake \
      spirv-headers \
      ccache \
      weston \
      check \
      linux-image-amd64 \
      git \
      procps \
      systemd \
      dbus \
      strace \
      systemd-coredump \
      time \
      busybox \
      kbd && \
    apt-get -y build-dep --no-install-recommends \
      qemu \
      mesa \
      virglrenderer \
      libepoxy \
      libsdl2 \
      piglit && \
    apt-get clean

# Enable ccache only now to avoid growing the layers too much
ENV PATH="/usr/lib/ccache:$PATH"

ARG CI_COMMIT_SHA=HEAD
WORKDIR /virglrenderer
RUN git clone https://gitlab.freedesktop.org/tomeu/virglrenderer.git . && \
    ccache -s && \
    ls -l /ccache && \
    git checkout ${CI_COMMIT_SHA} && \
    git log --oneline -n 1 && \
    ./autogen.sh --prefix=/usr/local && \
    make -j$(nproc) install && \
    ccache -s && \
    ls -l /ccache && \
    rm -rf /virglrenderer
WORKDIR /

COPY weston.service /usr/lib/systemd/system/.

