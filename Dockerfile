FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt update && apt install wget build-essential checkinstall libreadline-gplv2-dev \
        libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev \
        libffi-dev zlib1g-dev python3-openssl ffmpeg libsm6 libxext6 -y

RUN cd /opt && wget https://www.python.org/ftp/python/3.8.7/Python-3.8.7.tgz && \
    tar xzf Python-3.8.7.tgz && cd Python-3.8.7 && ./configure --enable-optimizations --with-ensurepip=install --with-ssl && \
    make altinstall && \
    cd .. && rm -r Python-3.8.7 && rm Python-3.8.7.tgz
    

WORKDIR /home

COPY deep-floor-plan-recognition .

RUN python3.8 -m pip install --upgrade pip && python3.8 -m pip install -r requirements/requirements_demo.txt
