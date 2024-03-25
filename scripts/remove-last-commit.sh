# Removing the last commit
# To remove the last commit from git, you can simply run git reset --hard HEAD^ If you are removing multiple commits from the top, you can run git reset --hard HEAD~2 to remove the last two commits. You can increase the number to remove even more commits.
# If you want to "uncommit" the commits, but keep the changes around for reworking, remove the "--hard": git reset HEAD^ which will evict the commits from the branch and from the index, but leave the working tree around.
# If you want to save the commits on a new branch name, then run git branch newbranchname before doing the git reset.

# git reset --hard HEAD^
# git reset --hard HEAD~2

