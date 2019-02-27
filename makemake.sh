#!/bin/bash

OPENCV_CONTRIB=./opencv_contrib
OPENCV_SRC=./opencv
PYTHON_BIN=python
INSTALL_DIR=./target/
BUILD_DIR=./build
ARCH_BIN=6.2

# current CUDA cannot handle modern gcc
CXX=g++-7
GCC=gcc-7

function clean() {
    echo "Cleaning out ${BUILD_DIR}"
    rm -fr ${BUILD_DIR}
    mkdir ${BUILD_DIR}
}

# things to note
# at the time this was made CUDA 10 cannot be built with newer compilers, hence
# the COMPILER directives.
# with CUDA on the extra modules must also be available, but codecs off as that
# is not longer available in CUDA...

function makemake() {
    cmake \
        -D CMAKE_CXX_COMPILER=${CXX} \
        -D CMAKE_C_COMPILER=${GCC} \
        -D CMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
        -D BUILD_TIFF=ON \
        -D BUILD_OPENCV_JAVA=OFF \
        -D WITH_CUDA=ON \
        -D BUILD_OPENCV_CUDACODEC=OFF \
        -D BUILD_opencv_cudacodec=Off \
        -D OPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB}/modules/ \
        -D CUDA_ARCH_BIN=${ARCH_BIN} \
        -D CUDA_ARCH_PTX="" \
        -D CUDA_FAST_MATH=ON \
        -D ENABLE_FAST_MATH=ON \
        -D WITH_OPENGL=ON \
        -D WITH_OPENCL=ON \
        -D WITH_IPP=ON \
        -D WITH_TBB=ON \
        -D WITH_EIGEN=ON \
        -D WITH_V4L=ON \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=$(${PYTHON_BIN} -c "import sys; print(sys.prefix)") \
        -D PYTHON_EXECUTABLE=$(which ${PYTHON_BIN}) \
        -D PYTHON_INCLUDE_DIR=$(${PYTHON_BIN} -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON_PACKAGES_PATH=$(${PYTHON_BIN} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        -S ${OPENCV_SRC} \
        -B ${BUILD_DIR}
}

function build() {
    cd ${BUILD_DIR}
    make -j $(nproc)
}

clean
makemake
build

