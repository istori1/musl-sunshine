#! /bin/sh

# Work in /run/build
mkdir -p /run/build
cd /run/build

# Add build tools (samurai is ninja-build)
apk add bash \
build-base \
clang17 \
cmake \
git \
make \
mold \
nasm \
npm \
pkgconf \
samurai \
vala \
--no-interactive

# Use mold linker
export LDFLAGS=-fuse-ld=mold

# Use Clang/LLVM compiler
export CC=clang && export CXX=clang++

# Add dependencies
apk add boost-dev \
curl-dev \
gobject-introspection-dev \
gtk+3.0-dev \
intel-media-sdk-dev \
libayatana-appindicator-dev \
libcap-dev \
libdbusmenu-gtk3-dev \
libdrm-dev \
libevdev-dev \
libnotify-dev \
libva-dev \
libvdpau-dev \
libx11-dev \
miniupnpc-dev \
numactl-dev \
openssl-dev \
opus-dev \
pulseaudio-dev \
wayland-dev \
--no-interactive

# Sunshine build-deps, src build
git clone -b master --depth 1 --recurse-submodules https://github.com/LizardByte/build-deps.git

# Sunshine nightly, src build
git clone -b nightly --depth 1 --recurse-submodules https://github.com/LizardByte/Sunshine.git

#####################
# Remove deps
rm -r /run/build/Sunshine/third-party/build-deps/ffmpeg/linux-x86_64
#####################
# patches
# cd /run/build/build-deps/ffmpeg_patches
#####################
# x264
cd /run/build/build-deps/ffmpeg_sources/x264
./configure \
--disable-asm \
--disable-cli \
--enable-static \
--prefix=/run/build/Sunshine/third-party/build-deps/ffmpeg/linux-x86_64 \
make -j$(nproc)
make install
#####################
# x265
cd /run/build/build-deps/ffmpeg_sources/x265_git
cd source
mkdir build && cd build
cmake -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/run/build/Sunshine/third-party/build-deps/ffmpeg/linux-x86_64 \
-DENABLE_ASSEMBLY=0 \
-DENABLE_CLI=OFF \
-DENABLE_HDR10_PLUS=1 \
-DENABLE_SHARED=OFF \
-DSTATIC_LINK_CRT=ON \
.. 
ninja
cmake --install .
#####################
# svt-av1
cd /run/build/build-deps/ffmpeg_sources/SVT-AV1
mkdir build && cd build
cmake -G Ninja \
-DBUILD_APPS=OFF \
-DBUILD_DEC=OFF \
-DBUILD_SHARED_LIBS=OFF \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/run/build/Sunshine/third-party/build-deps/ffmpeg/linux-x86_64 \
-DCOMPILE_C_ONLY=ON \
-DENABLE_AVX512=ON \
.. 
ninja
cmake --install .
#####################
# ffmpeg
cd /run/build/build-deps/ffmpeg_sources/ffmpeg
./configure \
--disable-programs \
--enable-avcodec \
--enable-encoder=h264_v4l2m2m \
--enable-encoder=h264_vaapi,hevc_vaapi,av1_vaapi \
--enable-encoder=libsvtav1 \
--enable-encoder=libx264,libx265 \
--enable-gpl \
--enable-libsvtav1 \
--enable-libx264 \
--enable-libx265 \
--enable-static \
--enable-swscale \
--enable-v4l2_m2m \
--enable-vaapi \
--extra-cflags="-I/run/build/Sunshine/third-party/build-deps/ffmpeg/linux-x86_64/include" \
--extra-ldflags="-fuse-ld=mold -L/run/build/Sunshine/third-party/build-deps/ffmpeg/linux-x86_64/lib" \
--extra-libs="-lpthread -lm" \
--pkg-config-flags="--static" \
--pkg-config=pkg-config \
--prefix=/run/build/Sunshine/third-party/build-deps/ffmpeg/linux-x86_64 \
make -j$(nproc)
make install
#####################
#sunshine
cd /run/build/Sunshine
mkdir build && cd build
cmake -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr \
-DSUNSHINE_ASSETS_DIR=share/sunshine \
-DSUNSHINE_EXECUTABLE_PATH=/usr/bin/sunshine \
-DSYSTEMD_USER_UNIT_INSTALL_DIR=share/sunshine \
-DTESTS_ENABLE_PYTHON_TESTS=OFF \
-DUDEV_RULES_INSTALL_DIR=share/sunshine \
..
ninja
cmake --install .
#####################
