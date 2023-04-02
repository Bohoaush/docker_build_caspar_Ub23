# Using official Ubuntu 22.04 image as a base
FROM ubuntu:jammy
# Updating package database
RUN apt update
# Installing dependencies
RUN apt install -y git cmake build-essential g++ libglew-dev libfreeimage-dev libtbb-dev libsndfile1-dev libopenal-dev libjpeg-dev libfreetype6-dev libxcursor-dev libxinerama-dev libxi-dev libsfml-dev libvpx-dev libwebp-dev liblzma-dev libmp3lame-dev libopus-dev libtheora-dev libx264-dev libx265-dev libbz2-dev libcrypto++-dev librtmp-dev libgmp-dev libxcb-shm0-dev libass-dev libgconf2-dev libopencore-amrwb-dev libsnappy-dev libopenjp2-7-dev libshine-dev libspeex-dev libtwolame-dev libvo-amrwbenc-dev libwavpack-dev libxvidcore-dev libsoxr-dev libxv-dev libxml2-dev libopenmpt-dev libbluray-dev libasound-dev libsdl2-dev libxtst-dev libatspi2.0-0 libatk-bridge2.0-dev libxcomposite-dev libboost-all-dev libavcodec-dev libavformat-dev libavdevice-dev libavutil-dev libswscale-dev libpostproc-dev libswresample-dev libnss3 libcups2 libxdamage1 wget
# Preparing CEF
WORKDIR /opt/
RUN wget https://cdn-fastly.obsproject.com/downloads/cef_binary_5060_linux64.tar.bz2
RUN tar -xvjf cef_binary_5060_linux64.tar.bz2
RUN mv cef_binary_5060_linux64 cef
RUN mkdir -p build/cef
WORKDIR /opt/build/cef/
RUN cmake ../../cef
RUN make CXX_FLAGS="-Wno-attributes" -j 6
RUN cp libcef_dll_wrapper/libcef_dll_wrapper.a ../../cef/Release/
RUN strip ../../cef/Release/libcef.so
# Preparing CasparCG server
WORKDIR /opt/
RUN git clone https://github.com/CasparCG/server
WORKDIR /opt/server/src/
RUN sed -i "s/Boost 1.66/Boost 1.74/g" CMakeModules/Bootstrap_Linux.cmake
RUN sed -i "s/Boost_USE_RELEASE_LIBS OFF/Boost_USE_RELEASE_LIBS ON/g" CMakeModules/Bootstrap_Linux.cmake
RUN mkdir /opt/build/server
WORKDIR /opt/build/server/
RUN cmake /opt/server/src
RUN sed -i 's/cd \/opt\/build\/server\/shell && \/usr\/bin\/cmake -E copy_directory \/opt\/cef\/Release\/swiftshader/\#cd \/opt\/build\/server\/shell && \/usr\/bin\/cmake -E copy_directory \/opt\/cef\/Release\/swiftshader/g' shell/CMakeFiles/casparcg.dir/build.make
RUN make -j 6
