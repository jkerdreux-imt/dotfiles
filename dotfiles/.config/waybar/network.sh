#!/bin/bash

# Obtenir l'interface de routage par défaut
INTERFACE=$(ip route | grep default | awk '{print $5}')

# Obtenir l'adresse IP de cette interface
IP=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# Afficher le résultat au format JSON pour Waybar
echo "{\"text\": \"$IP\", \"tooltip\": \"Interface: $INTERFACE\"}"
