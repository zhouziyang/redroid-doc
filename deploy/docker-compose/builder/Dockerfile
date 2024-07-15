FROM debian:bullseye-slim

RUN apt update && apt install -y \
    libcap2 \
    libelf1 \
    libexpat1 \
 && rm -rf /var/lib/apt/lists/*
