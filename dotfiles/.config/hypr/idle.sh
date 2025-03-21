#!/bin/sh

swayidle -w \
  timeout 300 '~/.config/hypr/lock.sh' \
  before-sleep '~/.config/hypr/lock.sh' \
  after-resume 'hyprctl dispatch dpms on'  
