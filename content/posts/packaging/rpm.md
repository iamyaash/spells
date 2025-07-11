---
date: '2025-07-02T21:09:21+05:30'
draft: true
title: 'Packaging: RPM - Red Hat Package Manager'
tags:
- package
- rpm
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowBreadCrumbs: true
    ShowToc: true
    TocOpen: true
    
---

# RPM Packaging
RPM is a package management system that run on Fedora based distributions, such as RHEL, CentOS, openSUSE, etc. RPM is supported in the previously mentioned systems and you can use it to _distribute, manage and update_ software that you create.

## Advantages
- Easier installation, removal, upgrade and verify packages with standard package management tools such `dnf`, `yum`  or `PackageKit`.
- It mostly uses _metadata_ to provide descriptions for the software, instructions for installation, and other parameters.
- Package software sources, patches and complete build instructions into source and binary packages.
- Digitally sign the package using GPG (_GNU Privacy Guard_) keys and verify the authenticity and integrity of the package.
- A database is used to store information about the installed package, we can use it to query and verify the packages.

# How to Prepare Software for RPM Package
To do so, we need to understand the basic concepts on,
- **_what is source code?_**, and 
- **_how programs are made?_**

## What is Source Code
A source code is a human readable programming language that will be compiled into machine code. In simple terms, the source code is human readable instructions to computer.

A source code is expressed by programming language, in which all the programming language are not the same.

## How Programs are Made?
When a source code gets converted into machine code, it's called a Program. There are several ways of doing it:
- The program that is **_natively compiled_**.
- The program that is **_intepreted by interpreter_**.
- The program that is **_interpreted by byte compiling_**.

### Natively Compiled
A source code written in a programming language is compiled into machine code with a resulting binary executable file. **Such software can be standalone**. 

Meaning, if the source code is compiled in a __x86_64__ processor, it won't run on 32-bit processor. In simple terms, the software is dependent on the architecture, and not the processor(`x86_64`, `x86`, `arm` `arm64`).

**RPM packages that are built this way are architecture specific**.

### Interpreted Code
Programming languages such as **Python** or **Bash**, do not compile to machine code. Their program's source code is executed line-by-line, without any transformations, by a language interpreter or language virtual machine.

Software written in interpreted languages is **architecture-specific**. Hence, they are not bound to the architecture and can run on any machine.

**RPM packages that are built this way are not architecture specific**.

#### Raw Interpreted
They do not need to be compiled and the interpreter executes the instructions directly. They don't need any language translator or language virtual machine.
#### Byte Compiled
They need to be compiled into byte-code, which is then executed by the language virtual machine.