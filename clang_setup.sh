#! /bin/sh

# Use mold linker
apk add mold --no-interactive
export LDFLAGS=-fuse-ld=mold

# Use Clang/LLVM compiler
apk add clang17 --no-interactive
export CC=clang && export CXX=clang++

# Add build tools
apk add git cmake pkgconf npm vala ninja-build ninja-is-really-ninja

# Add dependencies
apk add numactl-dev boost-dev openssl-dev curl-dev libevdev-dev libx11-dev wayland-dev libva-dev libdrm-dev libcap-dev libnotify-dev gtk+3.0-dev gobject-introspection-dev opus-dev pulseaudio-dev libdbusmenu-gtk3-dev miniupnpc-dev libayatana-appindicator-dev libvdpau-dev intel-media-sdk-dev --no-interactive

# Work in /opt/src
mkdir -p /opt/src
cd /opt/src

# TODO Sunshine build-deps, src build

# Sunshine, src build
git clone -b nightly --depth 1 --recurse-submodules https://github.com/LizardByte/Sunshine.git

 # Remove deps
#rm -r /opt/src/Sunshine/third-party/build-deps

 # Apply patch
cd Sunshine
# wget https://raw.githubusercontent.com/flathub/dev.lizardbyte.app.Sunshine/0232e605e725b2da4d151ebf88bc6171a3d0ae28/patches/remove-mfx.patch
# patch -p1 -i remove-mfx.patch

mkdir build && cd build && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DSUNSHINE_ASSETS_DIR=share/sunshine -DSUNSHINE_EXECUTABLE_PATH=/usr/bin/sunshine -DTESTS_ENABLE_PYTHON_TESTS=OFF -DSYSTEMD_USER_UNIT_INSTALL_DIR=share/sunshine -DUDEV_RULES_INSTALL_DIR=share/sunshine .. && ninja && cmake --install .
