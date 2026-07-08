#-----------------------------------------------------------------------------
# Environnement
#-----------------------------------------------------------------------------
set -gx PATH ~/.local/bin/ ~/go/bin/ ~/Utils/tools/ "$PATH"
# set -gx PYTHONSTARTUP ~/.pythonstart
set -gx GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
set -gx fish_greeting ''
set -gx SUDO_PROMPT '[sudo] %p 🗝 : '
set -gx CHEZMOI "$HOME"/.local/share/chezmoi
# set -gx BAT_THEME base16-256
# bat --list-themes | fzf --preview="bat --theme={} --color=always ~/.config/fish/config.fish"
set -gx BAT_THEME DarkNeon

#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------
# load grc alias before 
if type -q rgrc
    rgrc --aliases | source
else if test -e /etc/grc-rs.fish
    source /etc/grc-rs.fish
else if test -e /etc/grc.fish
    source /etc/grc.fish
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
alias kc "clone-in-kitty --type=os-window"

# -- Alternatives -- replace default commands w/ alternate
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

if set -q KITTY_WINDOW_ID; and set -q KITTY_PID
    alias ssh "kitten ssh"
end

if type -q bat; or type -q batcat
    set -l _bat_cmd (type -q bat; and echo bat; or echo batcat)
    alias less $_bat_cmd
    alias cat "$_bat_cmd -pp"
end

if test -e ~/.local/bin/hx
    alias vim hx
    alias vi hx
    set -gx EDITOR hx
    set -gx SVN_EDITOR hx
else if type -q helix
    alias vim helix
    alias vi helix
    alias hx helix
    set -gx EDITOR helix
    set -gx SVN_EDITOR helix
else if type -q micro
    set -gx EDITOR micro
    set -gx SVN_EDITOR micro
    set -gx MICRO_TRUECOLOR 1
end

if type -q duf
    alias df "duf -hide special"
end

if type -q btm
    alias top "btm -b"
end

if type -q zellij
    function zz
        command zellij run --name "$argv" -c -- fish -c "$argv"
    end
    function zf
        command zellij run --name "$argv" -fc --width 60% --height 60% -- fish -c "$argv"
    end
end

# SVN
function svn-status
    if type -q colorsvn
        colorsvn status -uq
    else
        svn status -uq
    end
end

function svn-diff
    if type -q delta
        svn diff $argv | delta
    else if type -q colordiff
        svn diff $argv | colordiff | bat
    else
        svn diff $argv | less
    end
end

function svn-delta
    if type -q delta
        svn diff $argv | delta
    else
        svn-diff $argv
    end
end

# Git
function gg
    if type -q lazygit
        lazygit $argv
    else
        git diff $argv | bat
    end
end

#-----------------------------------------------------------------------------
# Prompt
#-----------------------------------------------------------------------------
alias prompt_1 "set -g __fish_prompt_func fish_prompt_1"
alias prompt_2 "set -g __fish_prompt_func fish_prompt_2"

set -g __fish_prompt_color_host_bg 308
set -g __fish_prompt_color_host_fg eee
set -g fish_prompt_pwd_dir_length 8
set -g __fish_git_prompt_showcolorhints 0
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream informative

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
    # set_color -o 08b
    # echo -n ""
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
# Startups
#-----------------------------------------------------------------------------
if status is-interactive && type -q zoxide
    zoxide init --cmd cd fish | source
end

if status is-interactive && type -q fzf
    if type -q fzf_configure_bindings
        fzf_configure_bindings --git_log=\e\cd
    end
    set -gx FZF_DEFAULT_OPTS "--height 70% --border --exact"
    alias vs "source (cat ~/.venv_list |fzf --layout=reverse-list)/bin/activate.fish"
end

#-----------------------------------------------------------------------------
# Fish config files
#-----------------------------------------------------------------------------
function fish_config_update
    set -l tmp_file /tmp/config.fish
    curl -sfL "https://seafile.enstb.org/f/cc10c6fc2ad746e9bfe6/?dl=1" >$tmp_file
    if test -e $tmp_file
        cp $tmp_file ~/.config/fish/config.fish
        rm $tmp_file
    end
end

set -g fish_local_config ~/.config/fish/local.fish
if test -e $fish_local_config
    source $fish_local_config
end

set -g fish_jkx_config ~/.config/fish/functions/jkx.fish
if test -e $fish_jkx_config
    source $fish_jkx_config
end
