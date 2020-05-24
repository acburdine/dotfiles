function tm -a name -d "attach to existing tmux session or create new"
  if tmux has-session -t $name 2>/dev/null
    tmux attach -t $name
  else
    tmux new -s $name
  end
end
