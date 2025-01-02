
alias gt='git log --graph --oneline --all'
alias gr='cd $(git rev-parse --show-toplevel)' # cd to git root
alias py='python'
alias py3='python3'
alias psi='python setup.py install'
alias psiq='python setup.py install 2&>1 > /dev/null || echo $?'
alias ccc="clear && printf '\e[3J'"
alias gcr='git commit --reuse-message=HEAD'
alias gpc='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gpp='git add -u && git commit --reuse-message=HEAD && git push origin $(git rev-parse --abbrev-ref HEAD)'
alias be='bundle exec'
alias gch='git checkout'
alias pc='percent'
alias pcd='percent_diff'
alias pe='pyenv'
alias peg='pyenv global'
alias d='docker'
alias gbrecent='git branch --sort=-committerdate | head'
alias m='make'
alias gdc="git diff -- . ':(exclude)*.mod' ':(exclude)*.sum'" # git diff clever

ZSH_THEME="supo"
plugins=(git)

# set app roots
export NVM_ROOT="$HOME/.nvm"
export PYENV_ROOT="$HOME/.pyenv"
export RVM_ROOT="$HOME/.rvm"
export GOROOT="/usr/local/go"
export WORKDIR="$HOME/Desktop/p/"
export GIT_EDITOR="code --wait" # wait needed for rebase
export VSCODE_FOLDER="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# modify path
export PATH=$RVM_ROOT/bin:$PYENV_ROOT/bin:$PATH:$GOROOT/bin:$VSCODE_FOLDER

# zsh plugins
source ~/.oh-my-zsh/oh-my-zsh.sh
source ~/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/zsh-lazyload/zsh-lazyload.zsh

# funcs
function pv() {
    echo $(python -c 'import sys; import platform; print("%s - %s" % (sys.executable, platform.python_version()))')
}

function rv() {
    ruby -e "puts RbConfig::CONFIG.values_at('bindir', 'BASERUBY').join('/')"
}

function nv() {
    where node && node -v
}

# E.g: echo "foo bar baz\nfoobar" | hi foo
function hi()
{
    egrep --color "$1|$"
}

function percent()
{
    echo %$(echo "(100 * $2) / $1" | bc)
}

function percent_diff()
{
    result=$(python <<EOF
print(100*abs($1-$2)/$1)
EOF
)
    echo %$result
}

function truncate_docker_logs()
{
    # the idea is nsenter runs in the same namespace with the docker VM and can
    # $1 is containerID which can be retrieved via docker ps --no-trunc
    # actually see the host filesystem that logs are saved
    # For more info: https://github.com/justincormack/nsenter1
    docker run -it --rm --privileged --platform=linux/aarch64 --pid=host alpine:edge nsenter -t 1 -m -u -n -i sh -c "cd /var/lib/docker/containers/$1/; ls -alh | grep $1; echo Truncating logs...; truncate -s 0 $1-json.log; ls -alh | grep $1"
}

function docker_vm_shell()
{
    # On MacOS, Docker runs on a Linux VM. This container runs with the same
    # namespace of the VM and access the Linux host.
    docker run -it --rm --privileged --platform=linux/aarch64 --pid=host alpine:edge nsenter -t 1 -m -u -n -i sh
}

# lazyloaded commands to improve zsh startup time
lazyload nvm -- '[ -s "$NVM_ROOT/nvm.sh" ] && \. "$NVM_ROOT/nvm.sh"  # This loads nvm
    [ -s "$NVM_ROOT/bash_completion" ] && \. "$NVM_ROOT/bash_completion"  # This loads nvm bash_completion'

lazyload rvm -- 'export PATH=$RVM_ROOT/bin:$PATH
    source $RVM_ROOT/scripts/rvm'

lazyload pyenv -- 'export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init --path)"'

lazyload goenv -- 'export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    eval "$(goenv init -)"'

# ctrl+delete/backspace (del prev. word)
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word

cd $WORKDIR
