---
date: '2025-09-06T18:55:00+05:30'
draft: false
title: 'Docker: Persistent Storage Using Volumes'
tags:
- docker
- docker container
cover:
    image: posts/docker/img/docker-logo.png
    alt: docker-logo
author: "Yashwanth Rathakrishnan"
ShowReadingTime: true
ShowCodeCopyButtons: true
---

# What are Docker Volumes?
Docker volumes are a mechanism for persisting data independently of the container lifecycle. Since, the data in a container will be deleted once the container is stopped, using Docker volumes ensures the data is stored permenently. 
- Volumes are managed by Docker and stored on the host (mostly under `/var/lib/docker/volumes`). 
- Most importantly, it allows the data to be stored, retained and shared between container, suriving container restarts and removals.
- It preferrable to use for stateful applications like databases or file servers where data persistence matters.

## Creating and Using Volumes
- Volumes can be created implicitly by Docker when referenced or explicitly using:
	```sh
	docker volume create <volume_name>
	```
- Start a container and mount a volume:
	```sh
	docker run -it -v <volume_name>:/path/in/container <image:tag>
	```
## Volume Content Persistence and Sharing
- Files written/modified inside the container at the mount point path persist on the volume.
- When a new container mounts the same volume, it can process the previously stored data.
- Volumes can be mounted `read-write` (_default_) or `read-only` with `:ro` option:
```sh
docker run -it -v <volume_name>:/container/path/:ro <image:tag>
```

## Inspecting and Managing Volumes
- List volumes:
	```sh
	docker volume ls
	```
- Inspect a volume for details like mount point:
	```sh
	docker volume inspect <volume_name>
	```
- Remove a Volume(_only when inactive/not being by any containers_)
	```sh
	docker volume rm <volume_name>
	```

# Thoughts
If you read this posts about [**Bind Mounts**](https://iamyaash.github.io/spells/posts/docker/mount-volume/), using Volumes over Bind Mount is a benefit because:
- Volumes provide better data management via Docker CLI (_create, inspect remove_)
- They are **portable and flexible**, supporting various storage backend beyond local host paths.
- More suitable for production and complex setups than bind mounts.
- Most importantly, it provides data storage isolation as modifying the data inside volume won't damage the internal system storage.