FROM python:3.7.17-slim

COPY floorplan-recognition-website /home

WORKDIR /home

RUN apt update && apt install curl build-essential ffmpeg libsm6 libxext6 -y && \
	curl https://sh.rustup.rs -sSf | sh && pip install --upgrade pip pip setuptools wheel && pip install -r requirements.txt
