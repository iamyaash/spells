+++
date = '2025-03-07T21:45:47+05:30'
draft = false
title = 'Instant Page Deploy Hugo: holy'
tags = [ "docs", "setup", "script","hugo" ]

+++

I noticed that I'm keep deploying many pages on Github and still looking at the documentation. So I decided to make a short documentation how to do it fast (keeping me from looking at the documentation)

1. **Create a `hugo` site in a specific directory you want**:
```sh
hugo new site sitename
```
> Replace the `sitename` with the actual sitename you want to create.
- Head inside the directory(_`hugo site`_)
```sh
cd sitename
git init
```
- Download a theme (_we're using `holy` theme here_)
```sh
git submodule add https://github.com/serkodev/holy.git themes/holy
echo "theme = 'holy'" >> hugo.toml
```
- Let's test it locally!
```sh
hugo server
```
2. [**Create a GitHub Repository**](https://github.com/new)
3. **Head inside the Repository on GitHub** 
    - Goto `Settings > Pages`
    - Change the _`Source`_ settings to "**`GitHub Actions`**"
4. Create a file named `hugo.yaml` inside `.github/workflows`
```sh
mkdir -p .github/workflows
touch .github/workflows/hugo.yaml
```
5. Copy and paste the text into `YAML` file
```yml
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
      HUGO_VERSION: 0.144.2
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

6. Head inside the root directory of your `sitename`
```sh
hugo
git add -A
git commit -m "deploying the sitename"
git push origin main
```