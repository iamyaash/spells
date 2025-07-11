---
date: '2025-07-02T20:25:25+05:30'
draft: false
title: 'Packaging: Conceptual Differences Between RPM and DEB'
summary: 'Philosophies, design goals, and build process of "Red Hat Package Manager" and "Debian Package".'
tags:
- package
- rpm
- deb
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowBreadCrumbs: true
    ShowToc: true
    TocOpen: true
    
---

# Philosophies and Design Goals
## RPM - Red Hat Package Manager
Originally developed by Red Hat, now widely being used in Fedora, CentOS, RHEL, openSUSE, etc.

### Philosophy
Strong focus on scalability, larger enterprise environments, and fine-grained control over packaging and system policies.

The core design goals and philosophy of RPM include:
- **Ease of Maintainance** (_Independent Pacakge Operations_): 

RPM enables independent install/remove/upgrade of packages, simplifying the system maintainance.

- **Upgradability**(_Upgrade without restart_): 

RPM allows upgrading in-place without having a full system restart. It also preserves the user configuration, while updating.

- **Scalablity**(_Enterprise-Friendly features_): 

RPM is more enterprise-friendly with it's robust features, such as fine-grained package management, system verification and upgradability.

- **Powerful Querying**(_Database usage for package information_): 

RPM stores information about the installed packages within a dedicated database on your machine, specifically `/var/lib/rpm/` directory. The **_database contains metadata about each installed packages, such as name, version, config, description, and so on_.** It helps easy querying to get information from database rather than scanning the actual files.

- **Pristine Sources**(_Separated instructions for easier maintainanace_): 

Maintains the _changes and build instructions separated, for easier maintainance and higher software quality of upstream sources_.

- **System Verification**(_Verify Package Authenticity & Integrity_): 

RPM can verify package integrity using the checksum or GPG keys, notifying the user of inconsistencies and preserving modified configuration files during reinstallation.

- **Fine-Grained Control**(_Detailed control over package_): 

It provides detailed control over packaging, installation, and system policies, which is essential for enterprises and multi-user environment.

### Defining Build Instructions
A single `.spec` file is at the heart of every RPM pacakge. It serves as the blueprint for building, installing and packaging software.
1. **Centralized Instructions**

The `.spec` file contains **all the metadata, scripts, and build instructions** required to create an RPM package. Such as:
- Package name, version, description, summary, and release.
- License and upstream source information.
- Build dependencies and runtime dependencies.
- Detailed build and install scripts(_using shell commands_).
- File lists specifying which files go into the package.
- Pre- and post-install scripts (_for setup or cleanup tasks_).

2. **Human-Readable and Editable**
The `.spec` file is a plain text file, making it easy for packagers to review and modify.

**Example**
```spec
Name:           example
Version:        1.0
Release:        1%{?dist}
Summary:        Summary of the example package

License:        MIT
Source0:        https://example.com/example-1.0.tar.gz

BuildRequires:  gcc, make, 
Required:       python3, openssl

%description
This is an example RPM pacakge.

%prep
%setup -q

%build
make %{?_smp_mflags}

%install
make install DESTDIR=%{buildroot}

%files
/usr/bin/example

%changelog
* Thu Jul 03 2025 John Doe <jdoe@example.com> - 1.0-1
- Initial package
```

> In simple terms, one `.spec` file is used to define build instructions. It contains all metadata, scripts, build instruction in one place.

### Dependency Declaration Style
RPM uses a declaration approach for handling dependencies, all specified directly within `.spec` file.
Explicitly lists `Requires`, `BuildRequires`, `Conflicts`, etc., inside **`.spec`** file.

**Key Tags**
- `Requires`: Lists pacakges that must be **present for the RPM to work on at runtime**.
- `BuildRequires`: Lists pacakges **needed only during the build process**, not at runtime.
- `Conflicts`: Specifies packages that **cannot be installed at the same time as this pacakge**.
- `Obsoleted`: Indicates that **this package replaces another package**.
- `Provides`: This package gives you the features (_not just a file_). In simple terms, it does the job and other packages depends on it.

### Package Scripts
RPM packages include special scripts that run at certain points during installation or removal. All these scripts are written inside **`.spec`** file.

```spec
%pre
echo "It runs before the package is installed"
echo "Preparing to install..."

%post
echo "It runs after the packaage is installed"
echo "Installation complete!"

%preun
echo "Preparing to remove..."
echo "Runs before the pacakge is uninstalled"

%postun
echo "Removal complete!"
echo "Runs after the pacakge is uninstalled"
```

### Packaging Tools
The main tool used to build RPM packages from `.spec` files and source code is **`rpmbuild`**.
```sh
rpmbuild -qa myPacakge.spec
```
**Installing And Querying Packages**
- **`rpm`**
The low-level tool for installing, querying, and managing RPM packages directly.
    - Install Package 
    ```sh
    rpm -ivh myPacakge.rpm
    ```
    - Query Package
    ```sh
    rpm -q myPackage
    ```
- **`dnf`**
The modern high-level package manager for RPM-based systems and handles dependencies automatically (_there's no need for manual dependency installation_).
    - Install/Remove Package
    ```sh
    sudo dnf install myPacakge #install
    sudo dnf remove myPackage #uninstall
    ```
- **`yum`**
The older high-level package manager, similar to dnf but got replaced by `dnf`.

### Verification And Signatures
- **GPG Signatures**:
RPM packages can be signed with GPG keys. This ensures the authenticity and integrity of the pacakge. Use this command to verify a package's signature:
```sh
rpm --checksig myPacakge.rpm
```

- **Checksums**:
RPM uses checksums (_such as SHA256_) to ensure that files within the package have not been altered or corrupted.

- **File Verification**: 
RPM allows yout to verify installed files against the package metadata.
```sh
rpm -V myPackage
```

## Debian Package
Designed for Debian distributions, now also used by Ubuntu and it's derivatives.

### Philosophy
Emphasis on simplicity and community-driven maintainance; often aims to make packaging easier and more accessible for volunteers and smaller teams.
Instead of a single spec files like RPM, it uses a `debian/` directory with multiple small files to descrive package behaviour.

- **Simplicity**:
Debian emphasizes simple, understandable packaging processes. The goal is to make it easy for anyone, including volunteers and small teams, to contribute.
- **Community-Driven Maintenance**:
Most Debian packages are maintained by community volunteers, not by a single company. This encourages collaboration, transparency, and wide participation.
- **Accessibility**:
The packaging system is designed so new contributors can easily learn and participate, lowering the barriers to entry.

### Defining Build Instructions
The `debian/` directory contains several small, purpose-specific files that together describs how the package is built, installed, and maintained.
- `control` - list of package metadata and dependencies.
- `rules` - contains build instrucitons.
- `changelog` - list changes and copyright information for the pacakge.
- `install` - specifies which files should be insatlled and where.
- `preinst`, `postinst`, `prerm`, `postrm` - Scripts that run before/after or removal of the package.
- `compat` - Set the compatibility level for the package tool. (replace by `debian/control` in newer versions)
- `source/format` - Specifies the source package format.

**Example**
```sh
debian/
├── changelog
├── compat
├── control
├── copyright
├── install
├── postinst
├── prerm
├── rules
├── source/
│   └── format
```

### Dependency Declaration Style
Dependencies for Debian packages are specified in the `debian/control` file.

**Key Fields**
- `Depends`: List packages that must be installed for this package to work at runtime.
- `Pre-Depends`: List packages that must be installed and configured before this pacakge is unpacked.
- `Conflicts`: List packages that cannot be installed at the same time as this package.
- `Recommends`: Most users will want these installed for full functionality.
- `Suggests`: Useful, but not needed for normal operation.
- `Breaks`: Installing this package may break the listed packages, so the system will prevent them from being installed together.
- `Enhances`: It’s the opposite of `Suggests`: instead of saying “I suggest you install X,” it says “I enhance X.”
- `Provides`: Other packages can depend on ths provided feature, not just the package name.

**Example**
```control
Package: myapp
Version: 1.0
Section: utils
Priority: optional
Architecture: amd64
Depends: libc6 (>= 2.29), python3
Pre-Depends: dpkg (>= 1.15.6~)
Conflicts: oldapp
Description: My example application
 A longer description of my example application.
```

### Package Scripts
Debian uses separate script files in the `debian/` directory for package lifecycle events.
```
debian/
├── preinst     #runs before the package is installed/udgraded
├── postinst    #runs after the package is installed/udgraded
├── prerm       #runs before the package is removed
├── postrm      #runs after the package is removed
```

### Packaging Tools
1. `dpkg-buildpackage`
- The core tool for building Debian packages.
- It processes the source directory(_`debian/`_) and creates `.deb` files.
- It can be run directly for manual control over the build process.

2. `debuild`
- The higher level wrapper aroud `dpkg-buildpackage` and other tools.
- It automates running `dpkg-buildpackage`, checks packages with `lintian`, handles cryptographic signing, and manages build logs.
- Useful for simplifying and automating the build process, especially for uploads to Debian repositories.

**Installing And Managing Packages**:
- `dpkg`
    - The low-level tool for installing, removing, and querying `.deb` pacakges directly.
    ```sh
    dpkg -u myPackage.deb
    ```
- `apt`
    - The high-level package manager for Debian-based systems.
    - Handles dependency resolution, package downloads, and installations from repositories.
    ```sh
    apt install mypackage
    ```

### Verification and Signatures
- **GPG Signatures**:
Debian package and repositories can be signed using GPG keys. This ensures the package or repository comes from a trusted source and hasn't been tampered with.
- **Verification of `.deb` Package**
To verify, we use tools like `dpkg-sig` and `debsig-verify` are used to sign and verify `.deb` package files.
    - Import the public key first, then
    ```sh
    dpkg-sig --verify myPackage.deb
    debsig-verify myPackage.deb
    ```
    - A successfull verification will show a message like `GOODSIG`.
- **APT Resitory Verification**
Packages installed via `apt` are signed! Meaning, all the downloads from `apt` are trusted.

- **Checksums**

> `.deb` signature verification is disabled by default and must be enabled by editing `/etc/dpkg/dpkg.cfg` and setting up the necessary policy files.