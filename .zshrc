# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

source $NVM_DIR/nvm.sh

#zmodload zsh/zprof

skip_global_compinit=1
ZSH_DISABLE_COMPFIX=true
DISABLE_UNTRACKED_FILES_DIRTY="true"
DEFAULT_USER=jonlucadecaro
HYPHEN_INSENSITIVE="true"
MENU_COMPLETE="true"
DISABLE_UPDATE_PROMPT="true"
ZSH_THEME="powerlevel10k/powerlevel10k"

alias k=kubectl

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    docker
    osx
    virtualenv
    kubectl
    wd
    helm
    zsh-syntax-highlighting
    zsh-autosuggestions
)



alias emacs=emacs-nox
export TERM="xterm-256color"

# Customise the Powerlevel9k prompts
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon context custom_start vcs newline dir dir_writable history time newline status 
)

#https://github.com/bhilburn/powerlevel9k/blob/master/README.md
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

POWERLEVEL9K_KUBECONTEXT_FOREGROUND="black"
POWERLEVEL9K_KUBECONTEXT_BACKGROUND="magenta"
KUBE_PS1_SYMBOL_USE_IMG=false
KUBE_PS1_PREFIX=" "
KUBE_PS1_SUFFIX=" "
KUBE_PS1_SEPARATOR=" "
KUBE_PS1_SYMBOL_COLOR=19
#https://jonasjacek.github.io/colors/
KUBE_PS1_CTX_COLOR=231
KUBE_PS1_NS_COLOR=black

POWERLEVEL9K_OS_ICON_BACKGROUND=069
POWERLEVEL9K_OS_ICON_FOREGROUND=231
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

POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_MODE='nerdfont-complete'

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

alias kns=kubens
alias kctx=kubectx
source $ZSH/oh-my-zsh.sh

alias python=python3
alias pip=pip3

fpath=($fpath ~/.zsh/completion)


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh