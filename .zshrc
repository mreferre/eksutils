# If you come from bash you might have to change your $PATH.
#export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

source $NVM_DIR/nvm.sh

#zmodload zsh/zprof

skip_global_compinit=1
ZSH_DISABLE_COMPFIX=true
DISABLE_UNTRACKED_FILES_DIRTY="true"
DEFAULT_USER=jonlucadecaro
ZSH_THEME="powerlevel9k/powerlevel9k"
HYPHEN_INSENSITIVE="true"
MENU_COMPLETE="true"
DISABLE_UPDATE_PROMPT="true"
#source ~/bin/sandboxd/sandboxd

ZSH_THEME="powerlevel9k/powerlevel9k"

alias k=kubectl

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
#  docker
#  docker-compose
#  docker-machine
#  emacs
#  go
  osx
#  python
#  tmux
  virtualenv
  kubectl
#  kube-ps1
  wd
#  iterm2
  helm
  zsh-syntax-highlighting
  zsh-autosuggestions
)



alias emacs=emacs-nox
export TERM="xterm-256color"

# Customise the Powerlevel9k prompts
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
#    os_icon context custom_start kubecontext vcs virtualenv newline dir newline status
    os_icon context custom_start vcs virtualenv newline dir newline status
#    os_icon context custom_start vcs newline dir newline status
)



# The output of the kube_ps1 function is text, so it can be used
# directly as a custom p9k segment
#POWERLEVEL9K_CUSTOM_KUBE_PS1_BACKGROUND="magenta"
#POWERLEVEL9K_CUSTOM_KUBE_PS1='kube_ps1'

POWERLEVEL9K_KUBECONTEXT_FOREGROUND="black"
POWERLEVEL9K_KUBECONTEXT_BACKGROUND="magenta"
#POWERLEVEL9K_KUBECONTEXT_BACKGROUND="#ff8fcd"


#KUBE_PS1_BG_COLOR=
KUBE_PS1_SYMBOL_USE_IMG=false
#http://nerdfonts.com/#cheat-sheet

# to see available colors:
# for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"

KUBE_PS1_PREFIX=" "
KUBE_PS1_SUFFIX=" "
KUBE_PS1_SEPARATOR=" "
KUBE_PS1_SYMBOL_COLOR=19
#https://jonasjacek.github.io/colors/
KUBE_PS1_CTX_COLOR=231
KUBE_PS1_NS_COLOR=black


POWERLEVEL9K_OS_ICON_BACKGROUND=069
POWERLEVEL9K_OS_ICON_FOREGROUND=231
#POWERLEVEL9K_OS_ICON="echo -n '\uF302'"
#POWERLEVEL9K_OS_ICON_BACKGROUND=069
#POWERLEVEL9K_OS_ICON_FOREGROUND=015

#https://www.nerdfonts.com/cheat-sheet
#POWERLEVEL9K_CUSTOM_APPLE_ICON="echo -n '\uF302'"
#POWERLEVEL9K_CUSTOM_APPLE_ICON_BACKGROUND=069
#POWERLEVEL9K_CUSTOM_APPLE_ICON_FOREGROUND=015


#https://github.com/Powerlevel9k/powerlevel9k/blob/next/segments/context/README.md
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=075
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=015
POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND=197
POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND=015
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=197
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=015
POWERLEVEL9K_CONTEXT_REMOTE_BACKGROUND=202
POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=015


# Add the custom start
POWERLEVEL9K_CUSTOM_START="echo -n '\uE62E'"
POWERLEVEL9K_CUSTOM_START_FOREGROUND="black"
POWERLEVEL9K_CUSTOM_START_BACKGROUND="cyan"


#https://github.com/bhilburn/powerlevel9k/blob/master/README.md
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(battery time )
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(dir_writable time )
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_MODE='nerdfont-complete'
#source  ~/powerlevel9k/powerlevel9k.zsh-theme

#a pas l'air de marcher en dessous :()
# Set a color for iTerm2 tab title background using rgb values
function title_background_color {
    echo -ne "\033]6;1;bg;red;brightness;$ITERM2_TITLE_BACKGROUND_RED\a"
    echo -ne "\033]6;1;bg;green;brightness;$ITERM2_TITLE_BACKGROUND_GREEN\a"
    echo -ne "\033]6;1;bg;blue;brightness;$ITERM2_TITLE_BACKGROUND_BLUE\a"
}
ITERM2_TITLE_BACKGROUND_RED="18"
ITERM2_TITLE_BACKGROUND_GREEN="26"
ITERM2_TITLE_BACKGROUND_BLUE="33"
title_background_color
# Set iTerm2 tab title text
function title_text {
    echo -ne "\033]0;"$*"\007"
}
title_text freeCodeCamp

#I don't want to share history between terminals
setopt no_share_history
unsetopt share_history


alias mydotfiles='git --git-dir=$HOME/.mydotfiles.git/ --work-tree=$HOME'

alias kns=kubens
alias kctx=kubectx

alias vpn='sshuttle --dns -r sallamand@vdi -x 10.0.3.0/0'

alias kpause='docker pause kind-control-plane kind-worker kind-worker2'
alias kunpause='docker unpause kind-control-plane kind-worker kind-worker2'

source $ZSH/oh-my-zsh.sh

alias python=python3
alias pip=pip3

fpath=($fpath ~/.zsh/completion)


