#!/bin/sh

swayidle -w \
  timeout 300 '~/.config/hypr/lock.sh' \
  timeout 600 'hyprctl dispatch dpms off' \
  before-sleep '~/.config/hypr/lock.sh' \
  after-resume 'hyprctl dispatch dpms on'
