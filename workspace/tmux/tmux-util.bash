tmux-cheatsheet() {
    cat <<EOF
    [Detach Current Session]  <CTRL+b> (this is the default tmux prefix key), Release <CTRL+b>, and Press d.
    [Detach Current Session]  > tmux detach
    [Attach Named Session]    > tmux attach -t tms1
    [New Named Session]       > tmux new -s tms1
    [List Sessions]           > tmux ls
EOF
}