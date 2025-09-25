#! /bin/bash

echo -e "\033[34mChanging directory into themes/PaperModPlus/\033[0m"
cd themes/PaperModPlus
pwd

# fetch data
echo -e "\033[33mFetching changes from remote repository...\033[0m"
git fetch upstream

# pull data
echo -e "\033[33mPulling changes from remote repository...\033[0m"
git pull upstream main

# push changes to the blog site

cd ..
cd ..
pwd
echo -e "\033[35mAdding theme changes...\033[0m"
git add themes/*
git commit -s -m "theme synchronization"
echo -e "\033[35mPushing changes to the site...\033[0m"
git push origin main
