# spells

# Setup Guide (post `git clone`)
## `hugo-scripts`

Head inside your hugo site directory:
```sh
cd {hugo-site}
```
```sh
# add hugo-scripts as a submodule
git submodule add --depth=1 https://codeberg.org/clforge/hugo-scripts.git scripts/

# Sync submodules config (safety)
git submodule sync --recursive

# Initialize and update submodules
git submodule update --init --recursive
```

## Script Execution
Make sure to stay on the parent directory of your `{hugo-site}`.
1. Clean setup
```sh
./scripts/after-clone.sh 
```
2. Theme Synchronization (Optional)
```sh
./scripts/theme-sync.sh 
```
> Note: **Do not execute the scripts** from within the `scripts/`
