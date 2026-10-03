# Create any defined XDG dirs (unset ones expand to nothing; no forks unless one is missing)
for d in $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_STATE_HOME; do
  [[ -d $d ]] || mkdir -p -- "$d"
done

# # Bump the zoxide score of all project directories
# [ -z "${GHQ_ROOT}" ] || find "${GHQ_ROOT}/github.com" -mindepth 2 -maxdepth 2 -type d -not -name ".*" -exec zoxide add {} \;
