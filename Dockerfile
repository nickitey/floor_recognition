FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV HOME="/usr/floor-detection-core"
ENV PATH="/usr/local/cmake-3.12.4-Linux-x86_64/bin:${PATH}"
ENV PYTHONPATH="/usr/local/bin/python3.9/site-packages:/usr/local/bin/python3.7/site-packages"

WORKDIR ${HOME}

COPY floor-detection/ .

RUN apt update && apt install wget build-essential checkinstall libreadline-gplv2-dev \
        libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev \
        libffi-dev zlib1g-dev python3-openssl -y
    #     libffi-dev zlib1g-dev python3-openssl -y && \
    # wget https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1w/openssl-1.1.1w.tar.gz && \
    # tar -zxf openssl-1.1.1w.tar.gz && cd openssl-1.1.1w && ./config && make install && cd .. && \
    # rm -r openssl-1.1.1w

RUN cd /usr/local && \
    wget https://cmake.org/files/v3.12/cmake-3.12.4-Linux-x86_64.tar.gz && \
    tar -zxvf cmake-3.12.4-Linux-x86_64.tar.gz
    

# RUN cd /opt && wget https://www.python.org/ftp/python/3.9.21/Python-3.9.21.tgz && \
# tar xzf Python-3.9.21.tgz && cd Python-3.9.21 && ./configure --enable-optimizations --with-ensurepip=install --with-ssl && \
# make altinstall && \
# cd .. && rm -r Python-3.9.21 && rm Python-3.9.21.tgz

RUN cd /opt && wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz && \
    tar xzf Python-3.7.3.tgz && cd Python-3.7.3 && ./configure --enable-optimizations --with-ensurepip=install --with-ssl && \
    make altinstall && \
    cd .. && rm -r Python-3.7.3 && rm Python-3.7.3.tgz

# RUN wget https://bootstrap.pypa.io/pip/3.6/get-pip.py && \
#     python3.6 get-pip.py && \
#     python3.6 -m pip uninstall -r ./scripts/old_versions.txt && \
#     python3.6 -m pip install --force-reinstall -r ./scripts/requirements.txt && \
#     python3.6 -m pip install mxnet-cu90 nvidia-tensorrt && \
#     cd Mask_RCNN && python3.6 setup.py install && cd ..

# RUN cd /opt && wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz && \
#     tar xzf Python-3.9.16.tgz && cd Python-3.9.16 && ./configure --enable-optimizations && \
#     make altinstall && \
#     apt purge build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev \
#         libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev -y && \
#     cd .. && rm -r Python-3.9.16 && cd ${HOME}

# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub && \
#     apt-key add 3bf863cc.pub && \
#     dpkg -i ./CUDA/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb && \
#     dpkg -i ./CUDA/libcudnn7_7.0.5.15-1+cuda9.0_amd64.deb && \
#     dpkg -i ./CUDA/libcudnn7-dev_7.0.5.15-1+cuda9.0_amd64.deb && \
#     dpkg -i ./CUDA/libnccl2_2.1.4-1+cuda9.0_amd64.deb && \
#     dpkg -i ./CUDA/libnccl-dev_2.1.4-1+cuda9.0_amd64.deb && \
#     apt update && \
#     apt install cuda=9.0.176-1 libcudnn7-dev libnccl-dev libleptonica-dev \
#         tesseract-ocr libtesseract-dev -y && \
#     rm -r ./CUDA

RUN cd ${HOME} && apt update && \
    python3.7 -m pip install --upgrade pip && \
    python3.7 -m pip uninstall -r ./scripts/old_versions.txt && \
    python3.7 -m pip install -r ./scripts/requirements3.7.txt && \
    # python3.7 -m pip install nvidia-tensorrt && \
    cd Mask_RCNN && python3.7 setup.py install && cd ..

# RUN cd ${HOME} && apt update && \
#     python3.9 -m pip install --upgrade pip && \
#     python3.9 -m pip uninstall -r ./scripts/old_versions.txt && \
#     python3.9 -m pip install -r ./scripts/requirements.txt && \
#     # cd Mask_RCNN && python3.9 setup.py install && cd .. && \
#     python3.9 -m pip install tensorflow[and-cuda]