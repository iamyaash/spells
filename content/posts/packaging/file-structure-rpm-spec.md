---
date: '2025-07-05T12:39:02+05:30'
draft: false
title: 'Packaging: RPM Spec File Deep Dive'
summary: 'Detailed explanation of RPM package file structure.'
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

# RPM Spec File: Complete Syntax & Options Guide
An RPM `.spec` file is a recipe for building, installing and packaging software. It's divided into sections, each with specific purposes.
## Header Tags (_metadata_)
| Tag           | Purpose                                    | Example                               |
|---------------|--------------------------------------------|---------------------------------------|
| Name          | Name of the package                        | `Name: hello`                         |
| Version       | Upstream version                           | `Version: 1.0`                        |
| Release       | Package release (increment on changes)     | `Release: 1%{?dist}`                  |
| Summary       | Short description                          | `Summary: Simple hello world program` |
| License       | License type                               | `License: MIT`                        |
| URL           | Project website                            | `URL: https://example.com`            |
| Source0       | Main source file (_tarball, etc_)          | `Source0: hello-1.0.tar.gz`           |
| Patch0        | Patch file                                 | `Patch0: fix-type.patch`              |
| BuildRequires | Build-time dependencies                    | `BuildRequires: glibc`                |
| Requires      | Runtime dependencies                       | `Requires: glibc`                     |
| Group         | Pacakge group (_legacy; rarely needed_)    | `Group: Development/Tools`            |
| Provides      | Virtual provides                           | `Provides: hello-binary`              |
| Obsoletes     | Old pacakge gets replaces with the current | `Obsoletes: old-hello`                |
| Conflicts     | Raises conflicts and can't be installed    | `Conflicts: hello-beta`               |


##  `%description` Section
A longer, multi-line description of your package.
```sh
%description
A simple hello world program writter in C programming language for demonstration purposes.
```

## `%prep` Section
Prepare sources, unpack files, apply patches, etc.

**Common Macros**:
- `%setup` - Unpacks source tarball
    - `-q` = quite mode; less output
    - `-n <dirLocation>` = unpacks source into custom directory
    - `-c` = Create directory before unpacking
    - `-a <number>` = Unpack additional sources (`Source0`, etc.)
- `%patch` - Apply patches

**Example**:
```spec
%prep
%setup -q
%patch0 -p1
```

## `%build` Section
Build/Compile the software.

**Common Macros**:
- `%{optflags}` = Compiler optimization flags; _distro-recommended flags_.
- `%configure` = Runs `./configure` with standard options.
- `%make_build` = Runs `make` with parallel jobs.

**Example**:
```spec
%build
%make_install
```

## `%install` Section
Install files into a temporary buildroot.

**Common Macros**:
- `%{buildroot}` = Path to the temporary install root.
- `%make_install` = Runs `make install DESTDIR=%{buildroot}`

**Example**:
```sh
%install
%make_install
# or the manual installation would look like,
%install
mkdir -p %{buildroot}/usr/bin
install -m 0755 hello %{buildroot}/usr/bin/hello
```

## `%check` Section
Runs the tests to verify the build is successfull or not.
```sh
%check
make test
#if that's a binary file to test, we do something like
./hello | grep "Hello"
```

## `%clean` Section (Legacy)
```sh
%clean
rm -rf %{buildroot}
```
> Modern RPM tools clean up automatically, so this is mostly obsolete.

## `%files` Section
List all files to include in the pacakge.
**Options & Macros**:
- `%doc <file>`= Marks documentation files.
- `%license <file>` = Marks license files.
- `%config <file>` = Marks config files (_preserved on upgrade_).
- `%attr(mode, user, group) <file>` = Set permissions/ownership.
- `%dir <dir>` = Include a directory (_not contents_).
- `%ghost <file>` = File created at runtime, not in pacakge.

**Example**:
```spec
%files
%doc README.md
%licese LICENSE
%config{noreplace} /etc/hello.conf
/usr/bin/hello
%attr(0755,root,root) /usr/bin/hello
```

## `%changelog` Section
Document package changes.
```spec
* DATE NAME <email> - VERSION-RELEASE
- Change description
```

**Example**:
```spec
%changelog
* Sat Jul 05 2025 Yashwanth Rathakrishnan <iamyaash@example.com> - 1.0-1
- Initial package
```
## Scriptlets
Executes shell code at specific points 
| Scriptlet              | When it runs       |
|------------------------|--------------------|
| `%pre`                 | Before install     |
| `%post`                | After install      |
| `%preun`               | Before uninstall   |
| `%postun`              | After uninstall    |
| `%trigger --<pkgName>` | On package upgrade |

**Example using `%post`**:
```spec
%post
echo "Installation complete!"
```

## Special Macros & Usage

- `%{name}`, `%{version}`, `%{release}`: Expand to package name, version, release
- `%{_bindir}`, `%{_libdir}`, `%{_datadir}`: Standard directories (`/usr/bin`, `/usr/lib`, `/usr/share`)
- `%{_sysconfdir}`: `/etc`
- `%{_mandir}`: `/usr/share/man`
- `%{_docdir}`: `/usr/share/doc`
- `%{?_smp_mflags}`: Parallel make flags (e.g., `-j4`)

## `.spec` File Structure 
```spec
Name:           hello
Version:        1.0
Release:        1%{?dist}
Summary:        Simple Hello World program
License:        MIT
URL:            https://example.com
Source0:        hello-1.0.tar.gz
BuildRequires:  gcc

%description
A simple Hello World program written in C.

%prep
%setup -q

%build
gcc %{optflags} -o hello hello.c

%install
mkdir -p %{buildroot}/usr/bin
install -m 0755 hello %{buildroot}/usr/bin/hello

%check
./hello | grep "Hello"

%files
%doc README.md
%license LICENSE
/usr/bin/hello

%post
echo "Thank you for installing hello!"

%changelog
* Sat Jul 05 2025 Yashwanth Rathakrishnan <you@example.com> - 1.0-1
- Initial package
```

### Tips
- **Macros** make your spec file portable and maintainable.
- **Always use** `%{buildroot}` in `%install` to avoid polluting the real system.
- **Use** `%doc`, `%license`, and `%config` to properly classify files.
- **Scriptlets** should be used sparingly and only when necessary.
- **Test your RPM** with `rpmbuild -ba <specfile>` and install with `rpm -i <rpmfile>`.
