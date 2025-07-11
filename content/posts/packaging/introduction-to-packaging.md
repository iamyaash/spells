---
date: '2025-07-02T11:16:35+05:30'
draft: false
title: 'Packaging: Introduction to Packaging in Linux'
summary: "Provides an overview of what is a package and what is inside a package in Linux? Covers the essential and introduction part of packaging only."
tags:
- package
- introduction
- rpm
- deb
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowBreadCrumbs: true
    ShowToc: true
    TocOpen: true
    
---

# Why Do We Need To Package Software At All?

## _Easier Software Installation_

The simple answer is to make software installation easier. Because, without packages you've to _download source code, figure out the dependencies manually, compile it yourself, copy files to the right places (like `/usr/bin`, `/usr/share`) and so on_. 

Things get really complicated without a package. That's why we put everything into one package which takes care of installing the software without requiring much manual work.

In simple terms, a package bundles all the above mentioned manual tasks and let's you install the software with just **one command**.
```sh
sudo dnf install appName #if it's an RPM based distro
sudo apt install appName #if it's a DEB based distro
```

## _Handling Dependencies Automatically_
A package contains information on **_what other dependencies and the exact version it requies_** to run the software properly. 

Since the package bundles this information, package managers(`dnf`,`apt`) can check and install the necessary dependencies automatically, so you don't end up with a _"works on my machine"_ scenario

## _Standardize Software Across System_
Packaging follow strict guidelines, so all the package file structures are consistent and files go to standard locations. Making it easy for developers and maintainers to knowing where to look for thinig and for security teams to audit and patch easily.

All of this is possible because packages follows the certain standards and guidelines, which makes it easier for others to work on them.

It's not necessarily the same across all packaging types. For example, we'll focus on `.rpm` here, but `rpm` has its own guidelines, and `deb` has its own as well. Although the method of packaging is similar in principle, they are not exactly the same.

## Enabling Safer Updates and Removals
Packaging allows you to _update or remove softwares cleanly, without leaving junk beihind_.

A package **includes a file list to install**, along with uninstallation scripts (_ known as post/pre uninstall scripts_).

It also manages **versioning and checksums to ensure files are properly tracked and verified**.

It allows us to safely upgrade or completely remove software, keeping the system clean and consistent.

## Support System Security And Integrity
Packages can be signed using GPG keys, so you know they come from a trusted source and have not been tampered with. 

Basically, you can verify the package's signature using the developer's public key to ensure that it actually comes from the developer and has not been modified.

> Imagine building a PC from scratch, you would have to gather individual parts and components. A package is like buying a pre-build PC, so you can just "_plug and play_"

# What Is Inside A Package 
## RPM- Red Hat Package Manager
![package-layout](https://iamyaash.github.io/spells/posts/packaging/rpm-package-layout.png)
### 1. Payload (the actual files)
This is what finally gets installed on your system:
- Binaries: `/usr/bin/appName`
- Libraries: `/usr/lib/libappName.so`
- Configuration Files: `/etc/appName/config.conf`
- Documentation: `/etc/share/doc/appName`

### 2. Metadata
It includes information about the package itself:
- Name (e.g: `appName`)
- Version (`8.2.4`)
- Release (packager's iteration, eg: `1.fc40`)
- Architecture `arm`, `arm64`, `x86_64`
- Summary and detailed description
- License
- Maintainer Information

### 3. Dependency Information
Lists what other packages are required for the software to run properly:
```sh
#examples
Requires: python3 >= 3.8
Conflicts: oldlib < 2.0
```

### 4. Scripts (Optional)
Special scripts that run automatically when installing or removing the package:
- **Pre-install**(_preint_) - runs before install
- **Post-install**(_postint_) - runs after install
- **Pre-remove**(_prerm_) - runs before removal
- **Post-remove**(_postrm_) - runs after removal

For `.rpm` packages, these are usually defined as `%pre`. `%post`. `%preun`, and `%postrun`.

Example uses:
- Creating system users or groups
- Creating directories and necessary files
- Seting up permissions
- Starting or enabling services

### 5. Checksums & Signatures
- Every file include a checksum to ensure it isn't corrupted or have been tampered with.
- Packages can be signed using GPG keys, that helps verifying the authenticity and integrity of the package.

### 6. Changelog (Optional)
Contains information about what changes have been made in each version of the package.

It helps track added features, changes, fixes, and other updates. This is useful for both users and maintainers to understand the package’s evolution and history.

## Debian Package Manager
![debian-package](https://iamyaash.github.io/spells/posts/packaging/deb-package-layout.png)
A `.deb` package is basically an **ar archive** (_Unix archive format_), which internally contains:
```sh
debian-binary
control.tar.{gz|xz|zst}
data.tar.{gz|xz|zst}r
```

### 1. `debian-binary`
A plain text file, almost always contains the version of the pacakging format(_describes the version of the packaging format, not the software itself_):
```sh
2.0
```
It mostly used by the tool to know how to unpack and handle the package.

### 2. `control.tar.gz` (or `.xz` `.zst`)
This archive contains all **metadata and control script**:
- **control file**: Basic metada (_name, version, architecture, dependencies_)
- **postinst, preinst, postrm, prerm**: Pre/post install/remove scripts.
- **conffiles**: List configuration files that should be preserved on upgrades.
- **md5sums**: Checksums of installed files for integrity checks.


### 3. `data.tar.gz` (or `.xz`, `zst`)
This archive contains the **actual payload**:
- All binaries, libraries, documentations, configurations, because they are going to be ones that will appear in the final system after installation.

**Example Layout**:
```sh
/usr/bin/appName
/usr/share/doc/appName/README
/etc/appName/config.conf
```