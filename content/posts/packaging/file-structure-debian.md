---
date: '2025-07-05T22:29:13+05:30'
draft: false
title: 'Packaging: Debian File Deep Dive'
summary: 'Detailed explanation of Debian packaging file structure.'
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
# Debian Package File Structure
A Debian pacakge (`.deb`) is an archive that contains all the files necessary to install a software applicaiton on a Debian-based system. It includes executable files, libraries, documentation and metadata about the package.

## Internal Structure of a Debian Package
A `.deb` pacakge is essentially a `tar` archive that contains three main files:
- `debian-binary`: A text file contains the version of standard packaging format. (as of now, it's `2.0`)
- `control.tar.gz`: It contains the metadata, and other maintainer scripts. In simple terms, it contains all the information about the pacakge but the main source.
- `data.tar.gz`: It contains the actual files of the softwarte to be installed in a Debian based system.

# Structure of `debian/` Directory
```sh
iamyaash@pi5:~/testBuild/hello-1.0/debian $ ll
total 96K
-rw-r--r-- 1 iamyaash iamyaash  186 Jul  6 14:45 changelog
-rw-r--r-- 1 iamyaash iamyaash  528 Jul  6 14:45 control
-rw-r--r-- 1 iamyaash iamyaash 1.9K Jul  6 14:45 copyright
-rw-r--r-- 1 iamyaash iamyaash  138 Jul  6 14:45 hello-1.0.cron.d.ex
-rw-r--r-- 1 iamyaash iamyaash  537 Jul  6 14:45 hello-1.0.doc-base.ex
-rw-r--r-- 1 iamyaash iamyaash   28 Jul  6 14:45 hello-1.0-docs.docs
-rw-r--r-- 1 iamyaash iamyaash 1.6K Jul  6 14:45 manpage.1.ex
-rw-r--r-- 1 iamyaash iamyaash 3.8K Jul  6 14:45 manpage.md.ex
-rw-r--r-- 1 iamyaash iamyaash 4.6K Jul  6 14:45 manpage.sgml.ex
-rw-r--r-- 1 iamyaash iamyaash  11K Jul  6 14:45 manpage.xml.ex
-rw-r--r-- 1 iamyaash iamyaash  962 Jul  6 14:45 postinst.ex
-rw-r--r-- 1 iamyaash iamyaash  935 Jul  6 14:45 postrm.ex
-rw-r--r-- 1 iamyaash iamyaash  695 Jul  6 14:45 preinst.ex
-rw-r--r-- 1 iamyaash iamyaash  882 Jul  6 14:45 prerm.ex
-rw-r--r-- 1 iamyaash iamyaash  176 Jul  6 14:45 README.Debian
-rw-r--r-- 1 iamyaash iamyaash  261 Jul  6 14:45 README.source
-rwxr-xr-x 1 iamyaash iamyaash  690 Jul  6 14:45 rules
-rw-r--r-- 1 iamyaash iamyaash  538 Jul  6 14:45 salsa-ci.yml.ex
drwxr-xr-x 2 iamyaash iamyaash 4.0K Jul  6 14:45 source
drwxr-xr-x 2 iamyaash iamyaash 4.0K Jul  6 14:45 upstream
-rw-r--r-- 1 iamyaash iamyaash 1.2K Jul  6 14:45 watch.ex
```
The `*.ex` files are for example, you can take a look at it understand what to do next. But we can delete them `rm *.ex`.

## `control`
The `control` file is the heart of Debian package's metadata. It tells the package manager everything it needs to know about the package. Such as package name, version, license, description, summary and etc.

**An example of `control` file in Debian**
```control
Package: appName
Version: 8.8.80
License: unknown
Vendor: Yashwanth Rathakrishnan
Architecture: amd64
Maintainer: Yashwanth Rathakrishnan
Depends: libgtk-3-0, libnotify4, libnss3, libxss1, libxtst6, xdg-utils, libatspi2.0-0, libuuid1, libsecret-1-0
Recommends: libappindicator3-1
Section: default
Priority: optional
Homepage: https://sample.com
Description: 
  A sample description that starts with a single on first line.
```

## `rules`
The `rules` file is a **makefile** that tells the Debian packaging tools *how to build, install and clean up your package*. 

*It's a required part of the `debian/` directory in a source package.

```rules
#!/usr/bin/make -f

%:
	dh $@
```
- `#!/usr/bin/make -f` tells the system to use `make` to read the file.
- `%` is a pattern rule that matches any target.
- `dh $@` calls the `dh` tool with the target name. (`build`, `install`, `clean`..)

```rules
#!/usr/bin/make -f

build:
	./configure
	make

install:
	mkdir -p $(DESTDIR)/usr/bin
	cp mybinary $(DESTDIR)/usr/bin/

clean:
	rm -rf build/

binary:
	dh_testdir
	dh_testroot
	dh_install
	dh_clean
```
- `build`: As the name suggests, this target is responsible for building the software. In this case, it compiles the software.
- `install`: Copies files to the staging area (`$DESTDIR`); _set by the packaging tools_.
- `clean`: Cleans up the build artifacts.
- `binary`: Runs `debhelper` commands to finalize the package.

_If you need to customize, you can override specific steps:_
```sh
rules
#!/usr/bin/make -f

override_dh_auto_build:
    gcc -o hello hello.c

%:
    dh $@
```

## `copyright`
It's a required file in every Debian package. It documents the **copyright holders**  and **licensing terms** for the software and any files in contains. This file ensures users and redistributors know their legal righs and obligations regarding the package.

```copyright
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: mypackage
Source: https://github.com/aperson/myproject

Files: *
Copyright: 2025 Yashwanth Rathakrishnan <yashwanth@example.com>
License: GPL-3+

License: GPL-3+
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 .
 On Debian systems, the complete text of the GNU General Public License
 version 3 can be found in "/usr/share/common-licenses/GPL-3".
```

## `<pkgName>-<version>-docs.docs`
This file lists the documentation files to be installed into the package's documentation directory. Usually , it's `/usr/share/doc/<package-name>/`.

**Usage examples**:
```sh
README
CHANGELOG
docs/usr-guide.txt
```

## `README.Debian`
This file provides information specific to the Debian packaging of the software. It's **meant for the end-users and maintainers** to _understand Debian-specific changes, configurations or issues_.

## `README.source`
Describes the source package layout, any special source modifications, or non-standard packaging practices.
**Common Contents**:
- How the source package is structured.
- Any patches applied to the upstream source.
- How to regenerate files or apply patches.

## `source/`
This directory contains metadata about the source package format and options. Mostly, it contains a file named `format`, which specified the source package format.
```sh
3.0 (quilt)
```

## `upstream/`
This directory is used to store information and metadata about the upstream source. Mostly, it contains files named `metadata` and `changelog`.
