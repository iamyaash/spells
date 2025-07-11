---
date: '2025-05-11T12:45:30+05:30'
draft: false
title: 'Instant Page Deploy Hugo: papermod'
tags : [ "docs", "setup", "script", "hugo" ]
---

# Download the Latest Version of Hugo

1. Visit https://github.com/gohugoio/hugo/releases/latest.
2. Download the compatible version of Hugo for your operating system.
3. Extract the downloaded archive and move the binary file into `/usr/local/bin`.

# 1. Create a Site
```sh
hugo new site sitename --format yaml
# replace sitename with name of your website
```
```sh
cd sitename
```

# 2. Installing PaperMod
> **INSTALL** : Inside the folder of your Hugo site MyFreshWebsite, run:

```sh
git init #initialize git as well
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive # needed when you reclone your repo (submodules may not get cloned automatically)
```

# 3 Configuration

### 3.1 Let's Configure `hugo` to use `PaperMod`
The filename `hugo.yaml` may vary based on the version, so make sure to rename it to `hugo.yaml` if you find any other names. While this might not cause any errors, it will help avoid confusion."

```sh
echo "theme: ["PaperMod"]" >> hugo.yaml
```

### 3.2 Add Search Bar
In `hugo.yaml` add:

```yaml
outputs:
  home:
    - HTML
    - RSS
    - JSON

languages:
  en:
    languageName: "English"
    weight: 1
    menu:
      main:
        - name: Search
          url: search/
          weight: 8
        - name: Tags
          url: tags/
          weight: 10
```

In `contents/` add:
```sh
touch contents/search.md
```
```yaml
echo "---
title: "Search" # in any language you want
layout: "search" # necessary for search
# url: "/archive"
# description: "Description for Search"
summary: "search"
placeholder: "Abrakadabra🪄"
---
" >> contents/search.md
```

### 3.2 Layout of Homepage
Go to this page, choose the layout, and make the changes as mentioned.

[👉 PaperMod Layout](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-features/#regular-mode-default-mode)


# 4. Let's Test & Deploy
```sh
hugo server #i hope it turned out well :)
```
### 4.1 Create GitHub Repository
1. Create a Repository without any templates or `LICENSE` in it.
2. Goto `Settings > Pages`
3. Change `Source` settings to **`GitHub Actions`**

#### 4.2 Create a file named `hugo.yaml` inside `.github/workflows`
```sh
mkdir -p .github/workflows
touch .github/workflows/hugo.yaml
```

### 4.3 Configure the GitHub Workflow
> **Note**: Ensure that `HUGO_VERSION` in workflow matches the version used for building hugo site.
```yaml
# Sample workflow for building and deploying a Hugo site to GitHub Pages
name: Deploy Hugo site to Pages

on:
  # Runs on pushes targeting the default branch
  push:
    branches:
      - main

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

# Default to bash
defaults:
  run:
    shell: bash

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.147.2
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb
      - name: Install Dart Sass
        run: sudo snap install dart-sass
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5
      - name: Install Node.js dependencies
        run: "[[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true"
      - name: Build with Hugo
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
          TZ: America/Los_Angeles
        run: |
          hugo \
            --gc \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

# 5. Deploy **Hugo**!

```sh
hugo
git add -A
git commit -m "deploying hugo + first commit :D"
```
Copy the **remote url** from your repository (prefer copying `ssh` key over `https` key)
```sh
git remote add origin https://github.com/gohugoio/hugo.git
git push origin main
```

There you go!
