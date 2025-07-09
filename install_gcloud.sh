#!/bin/bash

set -e  # Encerra o script em caso de erro

# Atualiza pacotes e instala dependências
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl

# Adiciona a chave GPG do Google Cloud
curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Adiciona o repositório do Google Cloud SDK
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null

# Instala o Google Cloud CLI
sudo apt-get update -y
sudo apt-get install -y google-cloud-cli

# Inicia configuração
gcloud init

