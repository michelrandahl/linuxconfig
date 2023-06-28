#!/bin/env bash

# Get the branch names associated with each worktree and the directory
info=$(git worktree list --porcelain | grep -e '^worktree\|^HEAD')

# For each worktree, print the directory, branch name, and the date of the latest commit
while read -r directory && read -r branch
do
  # Extract the directory and branch name from the output
  directory=${directory#worktree }
  branch=${branch#HEAD }

  # Fetch the date of the latest commit in the branch
  creation_date=$(git log --pretty=format:"%ai" $branch | head -n 1)
  
  # Print the directory, branch name, and its creation date
  #echo "Directory: $directory, Branch: $branch, Creation Date: $creation_date"
  echo -e "$creation_date \t $directory"

done < <(echo "$info")
