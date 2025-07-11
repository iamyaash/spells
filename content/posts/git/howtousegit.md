---
title : 'Git Basics: Essential Commands'
date : 2025-03-29T19:37:21+05:30
draft : false
tags : ["git", "script", "docs"]
summary : "A quick reference guide to the most essential Git commands for everyday use, including initializing repositories, making commits, branching, and working with remotes."
cover:
    image : "posts/git/git.png"
    alt : "git-screenshot"
    responsiveImages: false

params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
---

## Setting up **`git`** in your device

```bash
git config --global user.name <your-username>
```
```bash
git config --global user.email <your-email>
```
```bash
git config --global user.signingKey <keyID>
```

1. - **`--global`**: The configuration applies to all repositories for the current user.
    - **`--local`**: The configuration applies only to the current repository.
    - **`--system`**: The configuration applies to all users on the system.
2. - **`user.name`** & **`user.email`** define the author's identity for commits.
3. - **`user.signingKey`** specifies the GPG key ID used for signing commits and tags.

**To display all the current configurations**: 
```bash
git config --list
```
**To display the specific configurations**:
```bash
git config --global user.name
git config --global user.email
```
### Enable commit signing:
```bash
git config --global commit.gpgSign true
```
After enabling this, every commit will be **automatically signed without needing the `-S` flag**.

### Disable commit signing:
```sh
git config --global --unset commit.gpgSign
```
---

### General Use Cases:

1. **Staging the changes**:
```sh
git add filename.ext
```
- `-A` will select all the changes in the current directory. (_Not a good practice, unless you know what you are doing_)
- `-i` for interactive picking the changes. (_Useful for handling large changes_)

2. **Committing the changes**:
```sh
git commit -S -am "commit message"
```
- `-S` - Signs the commit with your GPG key.
- `-a` - Stages all modified and deleted tracked files (_but not new files_).
- `-m` - Allows entering the commit message inline.

3. **Pushing the Changes**:
```sh
git push <remote> <branch>
```
- `<remote>` - The name of the remote repository (e.g., `origin`).
```sh
# find the remote repository name by
git remote -v
```
- `<branch`> - The name of the branch to push (e.g., `main` or `feature-branch`).
```sh
# find the available or current branch by
git branch
```

4. **Show the commits**:
```sh
git log --oneline --decorate --graph
```
- `--oneline` - shows the commit in single line without any verbose output.
- `--decorate` - use pretty printing (_with colors!_)
- `--graph` - displays the commit messages in graph format. (_easily understandable_)
