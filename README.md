# Yaash's Documentation

A personal collection of scripts, tools, and technical notes. This site serves as a central repository for runnable code snippets, documented commands, and practical technical knowledge.

Built with [Hugo](https://gohugo.io/) and the [PaperModPlus](https://codeberg.org/clforge/PaperModPlus) theme.

## Getting Started

### Prerequisites

- [Hugo](https://gohugo.io/installation/) (Extended version recommended)
- [Git](https://git-scm.com/)

### Installation

1. **Clone the repository:**
   ```sh
   git clone --recursive https://codeberg.org/clforge/docs.git
   cd docs
   ```

2. **Setup Submodules (if not cloned recursively):**
   If you cloned without `--recursive`, run:
   ```sh
   git submodule update --init --recursive
   ```

3. **Initialize Environment:**
   Run the setup script to prepare the environment:
   ```sh
   ./scripts/after-clone.sh
   ```

## Content Management

### Adding New Content

Use the provided script to create a new post with the correct metadata:
```sh
./scripts/new-content.sh
```
This script will prompt for a location (e.g., `linux/my-new-post.md`) and automatically inject required parameters like author and TOC settings.

### Previewing Locally

To run the Hugo development server:
```sh
hugo server -D
```
The site will be available at `http://localhost:1313/`.

## Project Structure

- `content/`: Markdown files containing the documentation and notes.
- `scripts/`: Helper scripts for environment setup and content creation.
- `static/`: Static assets like images and files.
- `hugo.yaml`: Hugo configuration file.
- `.forgejo/workflows/`: CI/CD configuration for automatic deployment.

## Scripts Overview

| Script | Description |
|--------|-------------|
| `scripts/after-clone.sh` | Performs initial setup after cloning the repo. |
| `scripts/new-content.sh` | Interactive script to create new posts in `content/posts/`. |
| `scripts/theme-sync.sh` | Synchronizes the Hugo theme (Optional). |

> **Note:** Do not execute the scripts from within the `scripts/` directory itself. Always run them from the project root.

---
Live site: [docs.yaasharc.me](https://docs.yaasharc.me/)
