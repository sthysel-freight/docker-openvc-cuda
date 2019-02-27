# Docker build and run environmet for OpenCV and CUDA

Current versions: OpenCV 4.0.1 and CUDA 10 

This repo and build scripts is good for building CUDA-enabled OpenCV.

## Build environment

Build in a Python 3.6+ virtualenv with the latest cmake installed.

``` zsh
$ python -m venv ocvfactory
$ source ./ocvfactory/bin/activate
$ pip install -r requirements.txt
```

# Docker

``` zsh
$ docker build -t opencv-cuda . 
```
