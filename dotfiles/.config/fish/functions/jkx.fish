#-----------------------------------------------------------------------------
# Tools
#-----------------------------------------------------------------------------
function hl --description "Prints a line with text and fills the screen"
    set -l text $argv[1]
    set -l remaining_space (math $COLUMNS - (string length "$text") - 3)

    set_color -o 4fa
    echo "= $text "(string repeat $remaining_space "=")
    set_color normal
end

function file-explorer --description "Open file explorer (dolphin)"
    set -l target $argv[1]
    if test -z "$target"
        set target .
    end
    dolphin "$target" >/dev/null 2>&1 &
end

function yazi-cd
    if not type -q yazi
        echo "Please install yazi"
        return
    end
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

alias ff file-explorer
alias yy yazi-cd

#-----------------------------------------------------------------------------
# Python stuffs
#-----------------------------------------------------------------------------
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

alias vv venv
alias vd venv_exit

#-----------------------------------------------------------------------------
# Private
#-----------------------------------------------------------------------------
function proxy-on --description "Enable HTTP Proxy"
    set -gx http_proxy 'http://cache.home:3128/'
    set -gx https_proxy 'http://cache.home:3128/'
end

function proxy-off --description "Disable HTTP Proxy"
    set -e http_proxy
    set -e https_proxy
end

function fj_init_repo
    # Repo name = current directory name
    set REPO_NAME (basename (pwd))
    set OWNER jkx # change this to your Forgejo username or organization
    set REMOTE "ssh://git@git.home/$OWNER/$REPO_NAME.git"

    echo "=== Repo: $REPO_NAME ==="

    # Initialize git if necessary
    if not test -d .git
        echo "Initializing git repository..."
        git init
        git switch -c main
    end

    # Initial commit if necessary
    if not git rev-parse HEAD >/dev/null 2>&1
        echo "Adding files and creating initial commit..."
        git add .
        git commit -m "first commit"
    end

    # Add remote if it doesn't exist
    if not git remote | grep -q origin
        echo "Adding remote $REMOTE..."
        git remote add origin $REMOTE
    end

    # Create the remote repository via Forgejo CLI
    echo "Creating remote repo via Forgejo CLI..."
    # Ignore error if the repo already exists
    fj repo create $REPO_NAME; or echo "Repo $REPO_NAME already exists, skipping creation."

    # Push to remote
    echo "Pushing to origin..."
    git branch -M main
    git push -u origin main

    echo "✅ Repo $REPO_NAME initialized and pushed."
end

#-----------------------------------------------------------------------------
# Miscs
#-----------------------------------------------------------------------------
function check_colors --description 'Display ANSI colors with names and Kitty config variables'
    set -l names black red green yellow blue magenta cyan white
    echo -e "\nColor Test (Background vs Text):"
    echo --------------------------------------------------------

    for i in (seq 1 8)
        set -l color_name $names[$i]
        set -l kitty_index (math $i - 1)

        # Background block using the color name
        set_color -b $color_name
        echo -n "       "
        set_color normal

        # Color Info
        printf "  ANSI %d : %-8s | Kitty: color%-2d | " $kitty_index $color_name $kitty_index

        # Text samples using the color name
        set_color $color_name
        echo -n "Colored Text"
        set_color normal
        echo "  (Default on Background)"
    end

    echo --------------------------------------------------------
    echo "Fix: Adjust 'color4' in kitty.conf if 'blue' is too light."
end

function daily_journal
    set -l DAILY_NOTES "$HOME/git/notes/Journal"
    set -l TODAY (date +%Y-%m-%d)
    set -l YEAR (date "+%Y")
    set -l MONTH (date "+%m-%B")
    set -l DEST_DIR "$DAILY_NOTES/$YEAR/$MONTH"
    set -l FILE_NAME "$TODAY.md"

    # Create the directory if it doesn't exist
    mkdir -p "$DEST_DIR"

    # Full file path
    set -l FILE_PATH "$DEST_DIR/$FILE_NAME"

    # Create the file if it doesn't exist
    if not test -f "$FILE_PATH"
        touch "$FILE_PATH"
        begin
            echo "# $TODAY"
            echo
            echo ---
            echo
            echo TODO:
            echo
            echo - []
            echo - []
            echo - []
            echo
        end >"$FILE_PATH"

        # Export a universal path for today's journal
        set -U DAILY_JOURNAL "$FILE_PATH"
    end
    echo $DAILY_JOURNAL
end
