#-----------------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------------
set -gx PATH ~/.local/bin/ "$PATH"
set -gx PATH ~/go/bin/ "$PATH"
set -gx PATH "$PATH" ~/Utils/tools/
# set -gx PYTHONSTARTUP ~/.pythonstart
set -gx GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
set -gx fish_greeting ''
set -gx SUDO_PROMPT '[sudo] %p 🗝 : '
set -gx CHEZMOI "$HOME"/.local/share/chezmoi
set -gx BAT_THEME base16-256

#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------
# load grc alias before 
if test -e /etc/grc-rs.fish
    source /etc/grc-rs.fish
else if test -e /etc/grc.fish
    source /etc/grc.fish
end

# ls vs exa
if type -q eza
    set -g __fish_eza_flags "--icons --git --time-style relative"
    alias ls "eza --group-directories-first  $__fish_eza_flags"
    alias ll "eza -lghmaa --group-directories-first -s Name $__fish_eza_flags"
    # directory doesn't have size
    alias ll_size "eza -lghmaa --group-directories-first -s size $__fish_eza_flags"
    alias ll_mod "eza -lghmaa -s modified $__fish_eza_flags"
    alias tree "eza -Thlg --color=always --level=3 --total-size $__fish_eza_flags"
end

if type -q incus
    alias ils "incus list -c ns46 -f compact"
end

# network
alias ipinfo "curl ipinfo.io"
alias ipconfig "ip --color addr"
alias ipname "host (hostname)"
alias scan-arp "arp-scan -I (ip route show default|cut -d\" \" -f 5) -l -D -r 3 -x"
alias htelnet "rlwrap nc "

# tools 
alias météo "curl http://v2.wttr.in/Brest,France"
alias arch-updated "grep -iE 'installed|upgraded' /var/log/pacman.log"
alias docker-prune "docker system prune --volumes -af && docker buildx prune"
alias kc "clone-in-kitty --type=os-window"
alias kssh "kitten ssh"

if type -q bat
    alias less bat
    alias cat "bat -pp"
end

if type -q batcat
    alias less batcat
    alias cat "batcat -pp"
end

if type -q micro
    set -gx SVN_EDITOR micro
    set -gx EDITOR micro
    set -gx MICRO_TRUECOLOR 1
end

if type -q helix
    alias vim helix
    alias vi helix
    alias hx helix
    set -gx SVN_EDITOR helix
    set -gx EDITOR helix
end

if test -e ~/.local/bin/hx
    alias helix hx
    alias vim hx
    alias vi hx
    set -gx SVN_EDITOR hx
    set -gx EDITOR hx
end

if type -q duf
    alias df "duf -hide special"
end

if type -q zoxide
    zoxide init --cmd cd fish | source
end

if type -q pipx
    function pipx-activate
        set -l __path "$HOME/.local/share/pipx/venvs/"
        set __result (command ls -C1 $__path|fzf)
        if test "x$__result" != x
            source $__path/$__result/bin/activate.fish
        end
    end
end

if type -q tmuxp
    function tmuxp-activate
        set -l __files "$(tmuxp ls)"
        if test "x$argv[1]" != x
            set __result (echo $__files|fzf -q $argv[1])
        else
            set __result (echo $__files|fzf)
        end

        if test "x$__result" != x
            tmuxp load $__result
        end
    end
end

if type -q zellij
    source ~/.config/fish/functions/zellij.fish
    function zz
        command zellij run --name "$argv" -c -- fish -c "$argv"
    end
    function zf
        command zellij run --name "$argv" -fc --width 60% --height 60% -- fish -c "$argv"
    end
end

# LXC container
alias _lxc-attach "sudo lxc-attach --clear-env --keep-var HOME --keep-var TERM -n"
alias _lxc-ls "sudo lxc-ls -f"
alias _lxc-start "sudo lxc-start -n"
alias _lxc-stop "sudo lxc-stop -n"
alias _lxc-destroy "sudo lxc-destroy -n"

alias ff /usr/local/bin/file-explorer

abbr py ipython

if status is-interactive && type -q fzf
    # if type -q fzf_key_bindings
    # load fzf key (Ctrl-T Ctrl-R Alt-C)
    # fzf_key_bindings
    # end
    set -gx FZF_DEFAULT_OPTS "--height 70% --border --exact"
    alias vs "source (cat ~/.venv_list |fzf --layout=reverse-list)/bin/activate.fish"
    alias lls "lxc-ls -f|fzf --layout=reverse-list"
    # alias lattach "lxc-attach -n (lxc-ls -f|grep RUNNING|fzf --layout=reverse-list|cut -f 1 -d' ') su jkx"
    alias lstart "lxc-start -n (lxc-ls -f|grep STOPPED|fzf --layout=reverse-list|cut -f 1 -d' ')"
    alias lstop "lxc-stop  -n (lxc-ls -f|grep RUNNING|fzf --layout=reverse-list|cut -f 1 -d' ')"
end

function yy
    if not type -q yazi
        echo "Please install yazi"
        return
    end

    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

if type -q btm
    alias top "btm -b"
end

function select
    read --local --array --null arr
    echo $arr[$argv]
end

function sub-domains
    curl --silent https://sonar.omnisint.io/subdomains/$argv
end

function lattach
    set -l line (lxc-ls -f | grep -v NAME | fzf --layout=reverse-list| awk '{print $1, $2}')
    set -l name (string split ' ' $line|select 1)
    set -l state (string split ' ' $line|select 2)

    if test $state = STOPPED
        echo "LXC starting $name"
        lxc-start -n $name
    end
    if test $name != ''
        lxc-attach -n $name
    end
end

function _lattach
    force_sudo
    set -l line (sudo lxc-ls -f | grep -v NAME | fzf --layout=reverse-list| awk '{print $1, $2}')
    set -l name (string split ' ' $line|select 1)
    set -l state (string split ' ' $line|select 2)

    if test $state = STOPPED
        echo "LXC starting $name"
        sudo lxc-start -n $name
    end
    if test $name != ''
        sudo lxc-attach -n $name --clear-env --keep-var HOME --keep-var TERM $argv
    end
end

function force_sudo
    sudo ps aux >/dev/null
end

alias prompt_1 "set -g __fish_prompt_func fish_prompt_1"
alias prompt_2 "set -g __fish_prompt_func fish_prompt_2"

#-----------------------------------------------------------------------------
# fish config
#-----------------------------------------------------------------------------
set -g __fish_prompt_color_host_bg 308
set -g __fish_prompt_color_host_fg eee
set -g fish_prompt_pwd_dir_length 8
set -g __fish_git_prompt_showcolorhints 0
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream informative

#-----------------------------------------------------------------------------
# functions 
#-----------------------------------------------------------------------------
function svn-diff
    if type -q colordiff
        svn diff $argv | colordiff | bat
    else
        svn diff $argv | less
    end
end

function svn-status
    if type -q colorsvn
        colorsvn status -uq
    else
        svn status -uq
    end
end

function svn-delta
    if type -q delta
        svn diff $argv | delta
    else
        svn-diff $argv
    end
end

function gg
    if type -q lazygit
        lazygit $argv
    else
        git diff $argv | bat
    end
end

function os_icon
    if test -f /etc/os-release
        set -l os_info (cat /etc/os-release | grep '^NAME=')
        set -l os_name (echo $os_info | sed 's/NAME=//' | tr -d '"')

        switch $os_name
            case '*Manjaro*'
                echo -n "󱘊"
            case '*Arch*'
                echo -n ""
            case '*Alpine*'
                echo -n ""
            case '*Debian*'
                echo -n ""
            case '*Ubuntu*'
                echo -n ""
            case '*Fedora*'
                echo -n ""
            case '*CentOS*'
                echo -n ""
            case '*Red Hat*'
                echo -n ""
            case '*'
                echo -n ""
        end
    else
        switch (uname)
            case Darwin
                echo -n ""
            case FreeBSD
                echo -n ""
            case NetBSD
                echo -n ""
            case '*'
                echo -n ""
        end
    end
end

function fish_prompt_1
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname -s)
    end
    if not set -q __fish_prompt_icon
        set -g __fish_prompt_icon (os_icon)
    end
    #set_color -o 08b
    #echo -n ""
    set_color -o eee
    set_color -b 08b
    echo -n " $__fish_prompt_icon $USER "
    set_color -o 08b
    set_color -b $__fish_prompt_color_host_bg
    echo -n " "
    set_color -o $__fish_prompt_color_host_fg
    set_color -b $__fish_prompt_color_host_bg
    #if test -n "$SSH_TTY"
    #    echo -n "@"
    #end
    echo -n "$__fish_prompt_hostname "
    set_color -o $__fish_prompt_color_host_bg
    set_color -b 555
    echo -n ""
    set_color -o $__fish_prompt_color_host_fg
    set_color -b 555
    set_color -o eee
    echo -n " "(prompt_pwd)""
    echo -n ""(fish_git_prompt)""
    echo -n " "
    set_color normal
    set_color -o 555
    echo -n ">"
    set_color normal
    echo -n " "
end

function fish_prompt_2
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname -s)
    end
    set_color -o ccc
    echo -n "$USER"
    set_color -o 555
    echo -n " > "
    set_color -o $__fish_prompt_color_host_bg
    echo -n $__fish_prompt_hostname
    set_color -o 555
    echo -n " > "
    set_color -o ccc
    echo -n (prompt_pwd)
    set_color -o 555
    echo -n " >>"
    set_color normal
    echo -n " "
end

function fish_prompt
    set -g __last_status $status
    if not set -q __fish_prompt_func
        if test "$TERM" = xterm-256color -o "$TERM" = tmux-256color
            set -g __fish_prompt_func fish_prompt_1
        else
            set -g __fish_prompt_func fish_prompt_2
        end
    end
    $__fish_prompt_func
end

function fish_right_prompt --description 'Write out the right prompt'
    if test $__last_status -ne 0
        set_color -b B02
        set_color -o eee
        echo -n " " $__last_status " "
        set_color normal
        echo -n " "
    end
    if test $CMD_DURATION
        # Show duration of the last command in seconds
        #set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.1fs", $1 / $2}')
        set duration (math $CMD_DURATION/1000)
        if test $duration -gt 1.0
            printf "%.1fs" $duration
        end
    end
end

function fish_config_update
    set -l tmp_file /tmp/config.fish
    curl -sfL "https://seafile.enstb.org/f/cc10c6fc2ad746e9bfe6/?dl=1" >$tmp_file
    if test -e $tmp_file
        cp $tmp_file ~/.config/fish/config.fish
        rm $tmp_file
    end
end

function kp --description "Kill processes"
    set -l __kp__pid (ps -ef | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:process]'" | awk '{print $2}')
    set -l __kp__kc $argv[1]

    if test "x$__kp__pid" != x
        if test "x$argv[1]" != x
            echo $__kp__pid | xargs kill $argv[1]
        else
            echo $__kp__pid | xargs kill -9
        end
        kp
    end
end

function autossh-tmux --description "Auto SSH to a tmux session"
    set -l __autossh_host $argv[1]
    if test "x$__autossh_host" != x
        set -l __autossh_port (shuf -i 30000-40000 -n 1)
        #echo "$__autossh_host => $__autossh_port"
        autossh -M $__autossh_port -t $__autossh_host "tmux attach||tmux new"
    else
        echo "usage: autossh-tmux host"
    end
end

function ssh_tmux
    ssh -t $argv "tmux attach || tmux new"
end

function proxy-on --description "Enable HTTP Proxy"
    set -gx http_proxy 'http://cache.home:3128/'
    set -gx https_proxy 'http://cache.home:3128/'
end

function proxy-off --description "Enable HTTP Proxy"
    set -e http_proxy
    set -e https_proxy
end

function hl --description "Prints a line with text and fills the screen"
    set_color -o 4fa
    echo -n "= $argv[1] "
    set length (echo -s "$argv[1]" | wc -c)
    set remaining_space (math $COLUMNS-$length- 3)

    for i in (seq 0 $remaining_space)
        echo -n "="
    end
    echo "" # Newline
    set_color normal
end

function venv --description "Create and activate a new virtual environment"
    set -l __venv_name $argv[1]
    # no argument
    if test -z "$__venv_name"
        # are we in a venv
        if test -e bin/activate.fish
            set __venv_name "."
        else
            set __venv_name ".venv"
        end
    end
    # deactivate current venv
    if test -n "$VIRTUAL_ENV"
        hl "Exit venv: $VIRTUAL_ENV"
        deactivate
    end
    # create new venv if not exist
    if not test -e $__venv_name
        hl "New venv:  "(pwd)"/$__venv_name"
        python3 -m venv $__venv_name --upgrade-deps
        source $__venv_name/bin/activate.fish
    end
    hl "Load venv: "(pwd)"/$__venv_name"
    source $__venv_name/bin/activate.fish
end

function venv_exit --description "Deactivate the current virtual environment"
    if test -n "$VIRTUAL_ENV"
        hl "Exit venv: $VIRTUAL_ENV"
        deactivate
    end
end

alias vv venv
alias vd venv_exit

# TODO: remove this
function lazy_install --description "Install LazyVim"
    set -l __conf_dir ~/.config/nvim
    if not test -e $__conf_dir
        git clone https://github.com/LazyVim/starter $__conf_dir
        rm -rf $__conf_dir/.git
    else
        echo "$__conf_dir found.. not installing"
    end
end

#-----------------------------------------------------------------------------
# keybinding
#-----------------------------------------------------------------------------
# by default fish use alt+up/down to recall history elements. overide it w/
# ctrl+up/down to avoid zellij issues
bind \e\[1\;5A history-token-search-backward
bind \e\[1\;5B history-token-search-forward
# ctrl/alt/k = kitty clone
bind \e\cK kc

#-----------------------------------------------------------------------------
# Load local files
#-----------------------------------------------------------------------------
set -g fish_local_config ~/.config/fish/local.fish
if test -e $fish_local_config
    source $fish_local_config
end
