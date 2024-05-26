shell=$(basename $(ps -p $$ | awk 'NR>1  {print $4}' | sed 's/-//g'))
supported_shell=0

case $shell in
"zsh")
  supported_shell=1
  ;;
"bash")
  supported_shell=1
  ;;
*) ;;
esac

if [ $supported_shell -eq 1 ]; then
  . "${DEVBOX_GLOBAL_ROOT}/${shell}/.${shell}rc"
fi
