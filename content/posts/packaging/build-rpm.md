---
date: '2025-07-03T14:13:41+05:30'
draft: false
title: 'Packaging: Build Your First RPM Package!'
summary: 'Create a simple "Hello World" C program, write a .spec file, build an RPM package with rpmbuild, install it to test, and then remove it.'
tags:
- package
- rpm
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

## Step 2: Install RPM Build Tools

On Fedora (or any RPM-based system):

```sh
sudo dnf install rpm-build rpmdevtools gcc
```

**Explanation:**

* `rpm-build`: Main tool to build RPMs.
* `rpmdevtools`: Provides helper scripts (like `rpmdev-setuptree`).
* `gcc`: C compiler.

**Set up your RPM build environment:**

```sh
rpmdev-setuptree
```

This creates a directory structure in your home directory:

```
~/rpmbuild/
├── BUILD
├── RPMS
├── SOURCES
├── SPECS
├── SRPMS
```

**Explanation:**

* `SOURCES`: Where you put your source tarballs.
* `SPECS`: Where you keep spec files.
* `RPMS`: Built RPM packages go here.

---

## Step 3: Prepare the Source Tarball

Move your `hello.c` file into a folder named `hello-1.0/`:

```sh
mkdir hello-1.0
mv hello.c hello-1.0/
```

Create a tarball from that folder:

```sh
tar czvf hello-1.0.tar.gz hello-1.0
```

Move it to `SOURCES`:

```sh
mv hello-1.0.tar.gz ~/rpmbuild/SOURCES/
```

**Explanation:**
RPM expects your source code to be in a tarball named `<name>-<version>.tar.gz`, containing a directory with the same name. This matches what `%setup` in the spec file expects.

---

## Step 4: Create the Spec File

Create a **`.spec`** file, add the following:

```sh
touch ~/rpmbuild/SPECS/hello.spec
```
```spec
Name:           hello
Version:        1.0
Release:        1%{?dist}
Summary:        Simple Hello World program

License:        MIT
URL:            http://example.com/
Source0:        hello-1.0.tar.gz

BuildRequires:  gcc

%description
A simple Hello World program packaged as an RPM example.

%prep
%setup -q

%build
gcc %{optflags} -o hello hello.c

%install
mkdir -p %{buildroot}/usr/bin
install -m 0755 hello %{buildroot}/usr/bin/hello

%files
/usr/bin/hello

%changelog
* Tue Jul 01 2025 Yashwanth Rathakrishnan <you@example.com> - 1.0-1
- Initial package
```

**Explanation (important!):**

* `%prep`: Prepares the source (unpacks tarball).
* `%build`: Compiles the program.
* `%install`: Copies files to a temporary install location (`%{buildroot}`), simulating how they will be installed.
* `%files`: Lists which files get included in the final RPM.
* `%changelog`: Package history.

---

## Step 5: Build the RPM

```sh
cd ~/rpmbuild/SPECS
rpmbuild -ba hello.spec
```

**Explanation:**

* `-ba`: Build both binary and source RPM.

The resulting RPM will be inside:

```
~/rpmbuild/RPMS/<architecture>/
```
### What is RPM?
RPM is a typical package that makes the package installation, upgrade and removal easier by handling dependencies automatically and ensuring files are placed in the correct locations. It _contains, compiled software(binaries), metadata, configuration files, scripts and so on_. It contains all the files that an RPM package should have.

### What is Source RPM?
A **Source RPM is often called SRPM**, is a special type of RPM pcakge, that contains the _original source code(**tarball**), the spec file(**build instructions**), any patches or additional files needed for building the package.

---

## Step 6: Install, Test, and Remove

**Install the `.rpm`:**

```sh
sudo rpm -ivh ~/rpmbuild/RPMS/x86_64/hello-1.0-1.fc42.x86_64.rpm
```
- `-i` = install; Tell `rpm` to install a new package.
- `-v` = verbose; Shows detailed output while installing, so you can see what's happening.
- `-h` = Prints a progress bar with `#` symbols as the package installs.

**Test:**

```sh
hello
```

Output should be:

```
Hello, RPM World!
```

**Uninstall it:**

```sh
sudo rpm -e hello
```

Check:

```sh
hello
# bash: /usr/bin/hello: No such file or directory
```

> Write program ➜ Package sources ➜ Write `.spec` ➜ Build ➜ Install ➜ Test ➜ Remove


# Extract Content Of An RPM Package

**Method 1**: Use `rpm2cpio` + `cpio`
```sh
rpm2cpio packageName | cpio -idmv
```
- `rpm2cpio packageName`: converts RPM to a `cpio` archive stream.
- `cpio -idmv`: extract files
    - `i`: extract
    - `d`: create directories as needed
    - `m`: preserve modification times
    - `v`: verbose output

**Method 2**: Use `mc` (_Midnight Commander_)
```sh
sudo dnf install mc #it doesn't come pre-built in any distro
```
```sh
mc #execute this, navigate to the rpm file
```