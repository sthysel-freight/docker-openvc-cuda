FROM nvidia/cuda:10.0-devel
MAINTAINER sthysel@gmail.com

# these are expensive and a RPITFA, so put them first and
# in their own layer

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  cmake-curses-gui \
  gfortran \
  git \
  libatlas-base-dev \
  libavcodec-dev \
  libavformat-dev \
  libgtk-3-dev \
  libjpeg-dev \
  libpng-dev \
  libswscale-dev \
  libtiff-dev \
  libv4l-dev \
  libx264-dev \
  libxvidcore-dev \
  pkg-config \
  unzip \
  yasm \
  wget
#  && rm -rf /var/lib/apt/lists/*

# install python
ENV PYTHON_VERSION=python3.6
RUN apt-get install -y \
  python3-pip \
  ${PYTHON_VERSION}-dev

RUN pip3 install numpy

WORKDIR /

ENV OPENCV_VERSION="4.0.1"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
  && unzip ${OPENCV_VERSION}.zip \
  && mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
  && cd /opencv-${OPENCV_VERSION}/cmake_binary \
  && cmake \
  -D BUILD_TIFF=ON \
  -D BUILD_opencv_java=OFF \
  -D WITH_CUDA=ON \
  -D WITH_OPENGL=ON \
  -D WITH_OPENCL=ON \
  -D WITH_IPP=ON \
  -D WITH_TBB=ON \
  -D WITH_EIGEN=ON \
  -D WITH_V4L=ON \
  -D BUILD_TESTS=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=$(${PYTHON_VERSION} -c "import sys; print(sys.prefix)") \
  -D PYTHON_EXECUTABLE=$(which ${PYTHON_VERSION}) \
  -D PYTHON_INCLUDE_DIR=$(${PYTHON_VERSION} -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -D PYTHON_PACKAGES_PATH=$(${PYTHON_VERSION} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
  ..

WORKDIR /opencv-${OPENCV_VERSION}/cmake_binary
RUN  make -j4

RUN rm /${OPENCV_VERSION}.zip \
&& rm -r /opencv-${OPENCV_VERSION}
RUN ln -s \
  /usr/local/python/cv2/${PYTHON_VERSION}/cv2.cpython-37m-x86_64-linux-gnu.so \
  /usr/local/lib/${PYTHON_VERSION}/site-packages/cv2.so

# ARG OPENCV_VERSION=4.0.1
# ARG TARGET_PATH=/target/
# ARG BUILD_PATH=/build/

# RUN mkdir /src/
# RUN mkdir -p /src/opencv/build/
# COPY ./opencv/* /src/opencv/
# COPY ./opencv_contrib/* /src/opencv_contrib/

