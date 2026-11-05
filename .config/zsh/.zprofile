export PATH="$HOME/.local/bin:$HOME/.local/bin/statusbar:$PATH"

# Só o TTY1 abre o X; SSH e outros TTYs ficam no shell.
if [ -z "$DISPLAY" ] && [ "${XDG_VTNR:-0}" = 1 ]; then
  exec startx
fi
