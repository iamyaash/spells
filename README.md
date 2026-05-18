# spells

# Setup Guide (post `git clone`)
## `hugo-scripts`

Head inside your hugo site directory:
```sh
cd {hugo-site}
```

1. Add `hugo-scripts` as a submodule
```sh
git submodule add --depth=1 https://codeberg.org/clforge/hugo-scripts.git scripts/
```

2. Synchronize Submodule Configuration (Recommended)
```sh
# Sync submodules config (safety)
git submodule sync --recursive
```

3. Initialize and Update Submodules
```sh
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
