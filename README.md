# Dotfiles

This repo contains my configuration files. The main goal is to share my
configuration with others.

This repo is an automatic extract from my [chezmoi](https://www.chezmoi.io/)
repo (private). You can check out `archive.py` to figure out how I do this.

My main shell for years is [Fish](https://fishshell.com/). I don't use extra
plugins for the look and feel. The prompt is made by myself that's all. I mainly
use Zellij to replace Tmux or screen, but I prefer to use Tmux in docker images.
Tmux, Zellij are also plugins free. In fact, I use chezmoi to replicate this
config on all my devices (servers etc), so I don't want to install extra stuffs.
I use `git sparse-ckout` to checkout only the needed files with `chezmoi`.

Most config files try to load a local config, for device specific configuration.
Fish prompt color can be different from one host to another, so  Fish load
`local.fish` file if present that override the default configuration.
Same for Hyprland or Kitty.

The repos also contains special configs for every day use. `git` or `ssh` with
additional support.


## Porn
I'm currently using
- [Hyprland](https://hyprland.org/)
- [Waybar](https://github.com/Alexays/Waybar)
- [Rofi](https://github.com/lbonn/rofi)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [Zellij](https://zellij.dev/)
- [Helix Editor](https://helix-editor.com/)

You can find below some screenshots

### Desktop
 ![Desktop](./shots/desk.png)

### Rofi
 ![Rofi](./shots/rofi.png)

### Tmux
 ![Tmux](./shots/tmux.png)

### Zellij + Helix Editor
 ![Zellij](./shots/helix-zellij.png)
