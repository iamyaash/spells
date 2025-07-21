---
date: '2025-07-21T19:48:46+05:30'
draft: false
title: 'Package Management'
summary: 'Essential package management and real world examples that cover all fundamental operations for managing RPM/DEB packages.'
tags:
- package
- linux
- rpm
- deb
- dnf
- apt
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowBreadCrumbs: true
    ShowToc: true
    TocOpen: true    
---
# Linux Package Management
When managing software pacakge on Linux systems, it's important to understand the distinction between **low-level and high-level package management** tools. 
### Low-Level Tool: Direct Package Operations
This commands interacts directly with RPM package files, allowing users to perform basic package operations **independent of online repositories or additional dependency handling**.

**Key Characteristics**:
- No automatic dependency resolution.
- Operates solely on local `.rpm` files or installed packages.
- Suitable for advanced users or situations requiring precise control.

### High-Level Tool: Handling Repositories and Dependency Management
These tools build on top of basic capabilities of `rpm`/`dpkg` and add robust package management features.
**Key Characteristcs**:
- Keeps logs (**transaction history**)of installs, removals, and updates, enabling rollback when needed.
- Search, enable or disable software repositories as software sources.
- Update all or specific packages with a single command, pulling updates from repositories.
- Detect and resolve package repositories, fetching any required additional packages from configured repositories.
- Automatically download from repositories instead of using local packages.

# Install a Pacakge 
## Using Local Package Tool
1. **`rpm` Package Manager**

**`rpm`** tool is used for handling package operations using an `.rpm` file
```sh
sudo rpm -i dummy-1.0.0-1.x86_64.rpm
```
- `dummy`: The software **package name**.
- `1.0.0`: **Version** of packaged software.
- `1`: The number of times this software version has been packaged; _increments each time for packaging or rebuiding changes_. (_first packaging/build iteration of this version_)
- `x86_64`: The **hardware architecture**.

2. **`dpkg` Package Manager**

**`dpkg`** tool is used for handling package operations in Debian based distros.
```sh
sudo foo_1.0-1_amd64.deb
```
## Using Package Manager
Package managers such as `dnf` or `yum` automatically pulling packages from repositories to install.
```sh
sudo dnf install dummy #for rpm-based
sudo apt install dummy #for deb-based
```
- `dnf/apt install package_name` is enough to download and install the package.
> They automatically resolve and install dependencies by pulling packages from online repositories, in case it needs to install dependencies. 

# Upgrade a Package
## Using Local Package Tool
**1. `rpm` Package Manager**

Upgrade to a new version (or) _install the package if not present_.
```sh
rpm -Uvh dummy-1.1.0-1.x86_64.rpm
```
- Ensure you have the same package name with different versions.
2. **`dpkg` Package Manager**

Use `-i` flag to _install, overwriting, and upgrading_ package.
```sh
dpkg -i foo_1.1.0-1_amd64.deb
```

## Using Package Manager
```sh
sudo dnf update
sudo apt update
```
It updates the existing package in the system with the updated one, and it also handles dependencies automatically. Especially, there's no need to reboot to apply the changes across the system.

# Remove a Pacakge

## Using Local Package Tool
**1.`rpm` Package Manager**
```sh
sudo rpm -e package_name
```
- Erase (_remove_) package by name.
- If multiple matches exist, use `--allmatches`.

**2. `dpkg` Package Manger**
```sh
sudo dpkg -r package_name
```
- Removes a package, but **leaves configuration files**.
```sh
sudo dpkg -P package_name
# or 
sudo dpkg --purge package_name
```
- Purges the pacakge and **removes configuration files** as well.

## Using Package Manager
```sh
#rpm
sudo dnf remove package_name
# deb
sudo apt remove pacakge_name
sudo apt purge package_name
```

# Query a Package
## Using Local Package Tool

| RPM Command            | DEB Command                              | Purpose                                                                    |
|------------------------|------------------------------------------|----------------------------------------------------------------------------|
| `rpm -q foo`           | `dpkg -s foo` or `dpkg-query -W foo`     | Query if a package is installed                                            |
| `rpm -qa`              | `dpkg -l` or `dpkg-query -W`             | List all installed packages                                                |
| `rpm -ql foo`          | `dpkg -L foo`                            | List all files from installed package                                      |
| `rpm -qc foo`          | `dpkg -L foo \| grep /etc`               | Show configuration files of installed package (by convention under `/etc`) |
| `rpm -qd foo`          | `dpkg -L foo \| grep /doc`               | Show documentation files (typically in `/usr/share/doc`)                   |
| `rpm -qf /usr/bin/foo` | `dpkg -S /usr/bin/foo`                   | Find which package owns a file                                             |
| `rpm -qpi foo.rpm`     | `dpkg-deb -I foo.deb`                    | Show information about the DEB file                                        |
| `rpm -qpl foo.rpm`     | `dpkg-deb -c foo.deb`                    | List the available files in DEB file                                       |
| `rpm -qR foo`          | `dpkg -s foo` or `apt-cache depends foo` | List dependencies of package                                               |

**Notes:**
- The `apt-cache depends foo` command is often used for querying dependencies in APT-based systems.
- Configuration files and documentation location conventions may vary by package, but are usually under `/etc` and `/usr/share/doc` respectively.
- Both `dpkg` and `dpkg-query` can be used for querying the DEB database; `apt` and `apt-cache` are higher-level tools.

## Using Package Manager
```sh
#for queries on package dependencies and repo info
#RPM based
sudo dnf info package_name

#Debian based
sudo apt show package_name
sudo apt-cache depends
sudo apt-cache rdepends
```

# Verifying a Pacakge

## RPM-based Systems
| Command                  | Purpose                                                        |
|--------------------------|----------------------------------------------------------------|
| `rpm -V foo`             | Verify files by package against RPM database                   |
| `rpm -Va`                | Verify all installed packages                                  |
| `rpm -Vf /path/to/file`  | Verify package that owns the given file                        |
| `rpm -Vp foo.rpm`        | Verify package integrity against `.rpm` file (_not installed_) |
| `rpm --checksig foo.rpm` | **Check GPG/MD5** signature and integrity; *prior to install*  |
| `rpm -K path/to/file`    | **Check GPG/MD5** signature and integrity; *prior to install*  |

- `rpm --checksig` verifies the authenticity and integrity of RPM file before installation
- `rpm -V` checks that files installed match what's recorded in RPM database.
- `rpm -Vp` can verify a package file against itself; _doesn't require installation_.
## Debian-based Systems
| Command                     | Purpose                                                                                    |
|-----------------------------|--------------------------------------------------------------------------------------------|
| `debsums foo`               | Verify installed files for a package; _uses md5sums_                                       |
| `dpkg -V foo`               | Verify installed files for a package; _slower, as it compares file checksums, permissions_ |
| `dpkg-sig --verify foo.deb` | Verify PGP/GPG signature of a `.deb` file; _not installed, package file authenticity_      |

- `debsums` is the most common tool for verifying checksums of installed files.
- `dpkg-sig --verify` checks signatures for package files.

# Clean-Up and Maintenance
| RPM (`dnf`)      | DEB (`apt`)      | Purpose                                       |
|------------------|------------------|-----------------------------------------------|
| `dnf autoremove` | `apt autoremove` | Remove orphaned (unused) packages             |
| `dnf clean all`  | `apt clean`      | Clear cached package files to free disk space |
|                  | `apt autoclean`  | Similar to `apt clean` but like `autoremove`  |

# Transaction Management 
### **Rollback and History (dnf/yum)**

| Purpose                                   | Command                     | Description                                                                 |
|--------------------------------------------|-----------------------------|-----------------------------------------------------------------------------|
| **View transaction history**               | `dnf history`               | Lists all past package install, update, and remove operations (transactions) |
| **Undo a past transaction**                | `dnf history undo `     | Reverts a specific transaction, restoring the system to its previous state   |
| **Rollback to a previous state**           | `dnf history rollback ` | Rolls back the system to the state immediately after the given transaction   |

#### **Why this is useful:**
- Transaction history lets you **track all changes** made to your system by `dnf` or `yum`.
- `undo` and `rollback` allow you to **reverse package updates or removals easily**, which is very helpful when troubleshooting or recovering from a problematic change.

#### **Example Workflow:**
1. **See transaction history:**
    ```sh
    sudo dnf history list
    ```
2. **If you spot a problematic update (e.g., with ID 25), undo just that transaction:**
    ```sh
    sudo dnf history undo 25
    ```
3. **Or, to roll back all changes up to just after transaction 22:**
    ```sh
    sudo dnf history rollback 22
    ```

> **Note:**  
> - Transactions are listed with unique IDs.
> - `yum` (on older systems) supports similar commands: `yum history`, `yum history undo`, `yum history rollback`.

# Miscellaneous Operations

These are the questions, that I got when I started experimenting with package managements, so let me write this in my own terms.

1. What would you do if you get any error such as "package is already installed", but you want to reinstall it anyway?
- Use `--replacepkgs` to _Install the packages even if some of them are already installed on this system_
- Use `--replacefiles` to _Install the packages even if they replace files from other, already installed, packages._
- Use `--force` to aggressively install the package, which combines `--replacepkgs` and `--replacefiles`.

```sh
sudo rpm -ivh --replacepkgs hayase-6.4.13-1.fc42.x86_64.rpm 
sudo rpm -ivh --replacefiles hayase-6.4.13-1.fc42.x86_64.rpm # replace files
#or aggrevise reinstall
sudo rpm -ivh --force hayase-6.4.13-1.fc42.x86_64.rpm 
```
For `dnf`:
```sh
sudo dnf reinstall package
```

2. How do you resolve a broken package dependency?

In Debian:
```sh
sudo apt-get install -f
#or
sudo apt --fix-broken install
```
In RPM:
```sh
#to fix broken dependencies
sudo dnf check #check for problems in package database
sudo dnf check-upgrade
#to fix issues
sudo dnf distro-sync
```

3. Manage Package Repositories 

**In RPM based**:
This follows a different approach by installing a `.rpm` file:

Terminal command:
```sh
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```
- After the installation, the repository will be added under `/etc/yum.repos.d` and you verify it by using `ll /etc/yum.repos.d`.

**In Debian based**:
This is the traditional way of adding a new package repositories to Debian Linux.

- The available repositories are listed in `sources.list` under `/etc/apt`.

Open the file in editor of your choice:
```sh
sudo nvim /etc/apt/source.list
```
Now we can add the repository here, by following this syntax:
```
deb [repo URL] [distribution] [component(s)]
```

Lastly, update to make the changes take effect:
```sh
sudo apt update
```