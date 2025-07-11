---
date: '2025-07-04T00:10:18+05:30'
draft: false
title: 'Packaging: Build Your First Debian Package!'
summary: 'Create a simple "Hello World" C program, prepare necessary Debian packaging files (debian/) build the .deb pacakge, install it to test and remvoe it.'
tags:
- package
- deb
- linux
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowBreadCrumbs: true
    ShowToc: true
    TocOpen: true    
---

## Step 1: Prepare a Simple Program

**Create `hello.c`:**

```c
// hello.c
#include <stdio.h>

int main() {
    printf("Hello, RPM World!\n");
    return 0;
}
````
**Compile it:**

```sh
gcc -o hello hello.c
```

This generates an executable named `hello`.

---

## Step 2: Install Packaging Tools
On Debian based distributions:
```sh
sudo apt update -y && sudo apt upgrade -y 
sudo apt install build-essential devscripts dh-make
```

**Explanation:**
- `build-essential`: Include `gcc` and `make`.
- `devscripts`: Provides helpful tools like `debuild`.
- `dh-make`: Initializes Debian packaging files.

## Step 3: Prepare Source Directory 

Create a folder `<package-name>-<version>` and move the source code into it:
```sh
mkdir hello-1.0/
mv hello.c hello-1.0 && cd hello-1.0/
```
> Ensure that you follow the naming conventions of the directory.

## Step 4: Initialize Debian Package Directory
Run this command to create Debian packaging directory within the `hello-1.0/`:
```sh
dh_make --createorig -s -y -p hello-1.0
```

**Explanation**:
- `--createorig`: Creates original tarball(`.orig.tar.gz`) in directory above the current directory.
- `-s`: Single binary package.
- `-y`: Assume "yes" for prompts.
- `-p hello_1.0`: Package name and version/

> This create 

## Step 5: Modify `debian/` Files
A `debian/` folder is created when executing `dh_make` command:
```sh
cd debian
rm *.ex #.ex are example files and can be removed
```

**Edit `control` file**
```sh
nano control
```
```control
Source: hello-1.0
Section: utils
Priority: optional
Maintainer: Yashwanth Rathakrishnan <iamyaash@unknown>
Rules-Requires-Root: no
Build-Depends:
 debhelper-compat (= 13), gcc
Standards-Version: 4.6.2
#Vcs-Browser: https://salsa.debian.org/debian/hello-1.0
#Vcs-Git: https://salsa.debian.org/debian/hello-1.0.git

Package: hello-1.0
Architecture: any
Depends:
 ${shlibs:Depends},
 ${misc:Depends},
Description: Simple Hello World Program in C
 A simple beginner program that display "Hello World" text.
```


**Edit `rules`**
```sh
#!/usr/bin/make -f

%:
    dh $@
```
```sh
chmod +x rules
```

**Create `debian/install` file and add**:
```sh
nvim debian/install
```
```sh
hello /usr/bin #copies hello to /usr/bin directory
```

## Step 6: Build the Package
Go back to one directory from `debian/` (_one level above `debian/`_)"
```sh
cd ..
debuild -us -uc
```

## Step 7: Install and Test
The packages are built and stored one level above the `*/debian/`:
```sh
iamyaash@pi5:~/testBuild/hello-1.0 $ ll
total 8.0K
drwxr-xr-x 6 iamyaash iamyaash 4.0K Jul  4 14:13 debian
-rw-r--r-- 1 iamyaash iamyaash   91 Jul  4 12:04 hello.c
iamyaash@pi5:~/testBuild/hello-1.0 $ ll ..
total 36K
drwxr-xr-x 3 iamyaash iamyaash 4.0K Jul  4 12:13 hello-1.0
-rw-r--r-- 1 iamyaash iamyaash 3.1K Jul  4 14:13 hello-1.0_1.0-1_arm64.build
-rw-r--r-- 1 iamyaash iamyaash 5.2K Jul  4 14:13 hello-1.0_1.0-1_arm64.buildinfo
-rw-r--r-- 1 iamyaash iamyaash 1.8K Jul  4 14:13 hello-1.0_1.0-1_arm64.changes
-rw-r--r-- 1 iamyaash iamyaash 2.3K Jul  4 14:13 hello-1.0_1.0-1_arm64.deb
-rw-r--r-- 1 iamyaash iamyaash 2.4K Jul  4 14:13 hello-1.0_1.0-1.debian.tar.xz
-rw-r--r-- 1 iamyaash iamyaash  786 Jul  4 14:13 hello-1.0_1.0-1.dsc
-rw-r--r-- 1 iamyaash iamyaash  292 Jul  4 12:13 hello-1.0_1.0.orig.tar.xz
```

**Install the `.deb` package**:
```sh
sudo dpkg -i hello-1.0_1.0-1_arm64.deb
```
**Run**:
```sh
hello
```
**Remove/Uninstall**:
```sh
dpkg -r hello-1.0
```


## Directory Structure (_For Reference_)
```sh
iamyaash@pi5:~/testBuild $ ll -R .
.:
total 40K
drwxr-xr-x 3 iamyaash iamyaash 4.0K Jul  4 14:30 hello-1.0
-rw-r--r-- 1 iamyaash iamyaash 3.4K Jul  4 14:32 hello-1.0_1.0-1_arm64.build
-rw-r--r-- 1 iamyaash iamyaash 5.5K Jul  4 14:32 hello-1.0_1.0-1_arm64.buildinfo
-rw-r--r-- 1 iamyaash iamyaash 2.0K Jul  4 14:32 hello-1.0_1.0-1_arm64.changes
-rw-r--r-- 1 iamyaash iamyaash 3.9K Jul  4 14:32 hello-1.0_1.0-1_arm64.deb
-rw-r--r-- 1 iamyaash iamyaash 2.5K Jul  4 14:32 hello-1.0_1.0-1.debian.tar.xz
-rw-r--r-- 1 iamyaash iamyaash  789 Jul  4 14:32 hello-1.0_1.0-1.dsc
-rw-r--r-- 1 iamyaash iamyaash 2.4K Jul  4 14:30 hello-1.0_1.0.orig.tar.xz
-rw-r--r-- 1 iamyaash iamyaash 2.3K Jul  4 14:32 hello-1.0-dbgsym_1.0-1_arm64.deb

./hello-1.0:
total 24K
drwxr-xr-x 6 iamyaash iamyaash 4.0K Jul  4 14:32 debian
-rwxr-xr-x 1 iamyaash iamyaash  69K Jul  4 14:28 hello
-rw-r--r-- 1 iamyaash iamyaash   91 Jul  4 12:04 hello.c

./hello-1.0/debian:
total 56K
-rw-r--r-- 1 iamyaash iamyaash  186 Jul  4 14:30 changelog
-rw-r--r-- 1 iamyaash iamyaash  503 Jul  4 14:31 control
-rw-r--r-- 1 iamyaash iamyaash 1.9K Jul  4 14:30 copyright
-rw-r--r-- 1 iamyaash iamyaash   10 Jul  4 14:32 debhelper-build-stamp
-rw-r--r-- 1 iamyaash iamyaash  150 Jul  4 14:32 files
drwxr-xr-x 4 iamyaash iamyaash 4.0K Jul  4 14:32 hello-1.0
-rw-r--r-- 1 iamyaash iamyaash   28 Jul  4 14:30 hello-1.0-docs.docs
-rw-r--r-- 1 iamyaash iamyaash   63 Jul  4 14:32 hello-1.0.substvars
-rw-r--r-- 1 iamyaash iamyaash   15 Jul  4 14:32 install
-rw-r--r-- 1 iamyaash iamyaash  176 Jul  4 14:30 README.Debian
-rw-r--r-- 1 iamyaash iamyaash  261 Jul  4 14:30 README.source
-rwxr-xr-x 1 iamyaash iamyaash  690 Jul  4 14:30 rules
drwxr-xr-x 2 iamyaash iamyaash 4.0K Jul  4 14:30 source
drwxr-xr-x 2 iamyaash iamyaash 4.0K Jul  4 14:30 upstream
```

# Extract Contents Of Debian Pacakge
I think the only way to easily extract the debian package is by using `ar`. You can use `mc` in case you want to take a look inside the package.
```sh
ar x packageName.deb
```
> `ar` is pre-installed in Debian based distro, and it will extract the contents in current directory.