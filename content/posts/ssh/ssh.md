+++
title = ' Generate SSH Keys'
date = 2025-03-29T20:07:55+05:30
draft = false
tags = [ "docs" ]

+++

## Adding  New `ssh` Key

1. Create `.ssh` key:
```sh
ssh-keygen -t rsa -b 4096 -C "email"
```
> Save it the keys in a specific directory location

2. Add the key to `ssh` agent
```sh
ssh-add /home/user/.ssh/ssh-filename
```

3. Verify the key has been added
```sh
ssh-add -l
```
Output:

```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/home/username/.ssh/id_rsa): /home/username/.ssh/temp   
Enter passphrase for "/home/username/.ssh/temp" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/username/.ssh/temp
Your public key has been saved in /home/username/.ssh/temp.pub
The key fingerprint is:
SHA256:zUJ0dU9gncA7rVf6+C5BsMmBVdHmCMUqzkEGWpu6QWM temp@gmail.com
The key's randomart image is:
+---[RSA 4096]----+
|        +..++=O=o|
|       + ++ ++.++|
|      E +o . Bo+.|
|     o + oo =oo.o|
|      o Sooo .o..|
|       o .o  .o. |
|      .       .+ |
|              o .|
|               +o|
+----[SHA256]-----+'
username@fedora:~$ ssh-add /home/username/.ssh/temp
Identity added: /home/username/.ssh/temp (temp@gmail.com)
username@fedora:~$ ssh-add -l
4096 SHA256:<keys> <email> (RSA)
4096 SHA256:<keys> <email> (RSA)
3072 SHA256:<keys> <email> (RSA)
4096 SHA256:<keys> <email> (RSA)
```
