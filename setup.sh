#! /bin/sh

# Use mold linker
xbps-install -Su mold -y
export LDFLAGS=-fuse-ld=mold

# Add dependencies
xbps-install -Su git patch cmake ninja clang pkgconf nodejs libnuma-devel boost-devel openssl-devel libcurl-devel libevdev-devel libX11-devel wayland-devel libva-devel libdrm-devel libcap-devel opus-devel pulseaudio-devel miniupnpc-devel libnotify-devel libayatana-appindicator-devel -y

# Work in /opt/src
mkdir -p /opt/src
cd /opt/src

# TODO Sunshine build-deps, src build

# Sunshine, src build
git clone -b patch-7 --depth 1 --recurse-submodules https://github.com/istori1/Sunshine.git

 # Remove deps
#rm -r /opt/src/Sunshine/third-party/build-deps

 # Apply patch
cd Sunshine
wget https://raw.githubusercontent.com/flathub/dev.lizardbyte.app.Sunshine/0232e605e725b2da4d151ebf88bc6171a3d0ae28/patches/remove-mfx.patch
patch -p1 -i remove-mfx.patch

mkdir build && cd build && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DSUNSHINE_ASSETS_DIR=share/sunshine -DSUNSHINE_EXECUTABLE_PATH=/usr/bin/sunshine -DTESTS_ENABLE_PYTHON_TESTS=OFF -DSYSTEMD_USER_UNIT_INSTALL_DIR=share/sunshine .. && ninja && cmake --install .
