#! /bin/bash

echo "Downloading PaperMod themes to the themes/ directory"
# Remove existing submodule files and Git data
rm -rf themes/PaperMod
rm -rf .git/modules/themes/PaperMod

# Remove the submodule entry from the index (if exists)
git rm --cached -f themes/PaperMod

echo "Adding PaperMod themes to the themes/ directory"
git submodule add --depth=1 https://github.com/iamyaash/PaperModPlus.git themes/PaperModPlus

# Sync submodules config (safety)
git submodule sync --recursive

# Initialize and update submodules
git submodule update --init --recursive

echo "Done."