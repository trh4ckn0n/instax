#!/bin/bash

set -e

echo "[*] Installation des dépendances nécessaires..."

# Update package index
sudo apt update

# Install required packages
sudo apt install -y curl tor openssl coreutils fzf

echo "[✓] curl, tor, openssl, coreutils et fzf installés."

# Start tor service
echo "[*] Démarrage de Tor..."
sudo systemctl start tor || sudo service tor start

# Check tor status
sleep 3
if curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org | grep -q "Congratulations"; then
    echo "[✓] Connexion Tor confirmée."
else
    echo "[!] Échec de la connexion Tor. Veuillez vérifier manuellement."
fi

echo "[*] Création des dossiers..."
mkdir -p sessions
touch passwords.lst

echo "[✓] Installation terminée."
echo "Lancez maintenant : ./instabrute_max.sh"
