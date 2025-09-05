---
date: '2025-09-05T14:50:04+05:30'
draft: false
title: 'Docker: Using Bind Mounts (Volume Mount)'
summary: 'A short guide on mounting a local directory inside a container.'
tags:
- docker
- docker container
cover:
    image: posts/docker/img/docker-logo.png
    alt: docker-logo
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---

---

# Mounting At Runtime Into A Container
```sh
docker run --name <container_name> -v <absolute_local_path>:<absolute_container_path>
```
- `run --name <container_name>`: Name of the running container
- `-v <local-path>:<container-path>`: Local directory path (_left-side_) & Container directory path (_right-side_)

---

# Mounting At Startup Time Into A Container 
```sh
docker run -it --rm -v local/path:container/path image:tag
```
- `-i`(interactive): Keeps `STDIN` open so you can interact with the container even if not attached. 
	- _It allows you to send input to the container_.
- `-t`(tty): Allocates a pseudo-TTY terminal inside the container. 
	- This makes the container's console more readable and interactive, _like a normal terminal sessions_.
- `--rm`: Automatically removes the container when it exits.
	- _Prevents stopped containers from running in the background, and cleans up after the container stop running_.
- `-v local/path:/container/path`: Bind mounts a directory or file form the host machine to the container's file system at runtime.
	- **Changes made locally will be reflected immediately in the container, since it's was mounted not copied**.
- `image:tag`: Name of the Docker image and it's respective tag.
---