# bump the zoxide score of all project directories
find "${GHQ_ROOT:?}" -mindepth 2 -maxdepth 3 -exec zoxide add {} \;
