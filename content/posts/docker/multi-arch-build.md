---
date: '2025-08-05T22:56:12+05:30'
draft: false
title: 'Docker: Build Multi-Architecture Container Images'
summary: 'A short guide to building and running container images for multiple architectures with instruction emulation.'
tags:
- docker
- docker container
- docker images
cover:
    image: posts/docker/img/docker-logo.png
    alt: docker-logo
params:
    author: "Yashwanth Rathakrishnan"
    ShowToc: true
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---
# Overview
In general, building Docker images for any architecture involves creating container images that can run on different CPU architectures (like `amd64`, `arm64`, `arm32`, etc.). To build a Docker image for any architecture, you can use Docker `buildx` with cross-compilation support.

Ensure QEMU is installed before proceeding:
```sh
sudo dnf install qemu-user-static
```

# Architecture Syntax
Docker architecture syntax generally follows this format,
```sh
os/arch/variant
```
- `os` is the operating system, let's use `linux`
- `arch` is the CPU architecture, such as:
    - `amd64` (x86_64)
    - `386` (x86)
    - `arm64` (64-bit ARM)
    - `arm/v7` (32-bit ARM)

Common example of architectures:
- `linux/amd64` - 64-bit Intel/AMD Linux
- `linux/386` - 32-bit Intel/AMD Linux
- `linux/arm64` - 64-bit ARM Linux (i,e Raspberry Pi)
- `linux/arm/v7` - ARM 32-bit Linux

# Build the Image
- **Build for a single architecture; Raspberry Pi Zero 2 W (i.e, _32-bit ARM_)**
```sh
docker buildx build --platform linux/arm/v7 --tag name:tag .
```
- **Build for multiple architectures; Desktop (x86_64), RPi 5 (arm64) and RPi Zero 2W**
```sh
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --tag name:tag .
```
- Load the image to local Docker directly
```sh
docker buildx build --platform linux/arm/v7 --output=type=docker --tag name:tag .
```
> Note: Using`--output=type=docker` loads the image into your local Docker directly (no push to registry).
- Push the image to a registry
```sh
docker buildx build --platform linux/arm/v7 --tag name:tag --push .
```
> Note: If you want to push an image to a registry, use `--platform` with `--push` instead, skipping `--output`.