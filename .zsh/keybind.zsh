# vim key bind
bindkey -v

# Search history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Vim normal mode keybind
bindkey -M vicmd 'H'  beginning-of-line
bindkey -M vicmd 'L'  end-of-line

# Vim insert mode keybind
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^J'  send-break
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  kill-line
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^W'  backward-kill-word

# Fuzzy finder command
bindkey '^L' cd-fzf-ghqlist
bindkey '^O' checkout-fzf-gitbranch
bindkey '^R' buffer-fzf-history
bindkey '^\' ssh-fzf-sshconfig
