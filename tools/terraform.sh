#!/bin/bash

set -e

echo "🔐 Adding HashiCorp GPG key and repository..."

# Dependências
sudo apt-get install -y gnupg software-properties-common curl

# Baixa e armazena a chave
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Verifica fingerprint
echo "🔎 GPG Fingerprint:"
gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

# Determina a codename do Ubuntu (ex: focal, jammy)
UBUNTU_CODENAME=$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)

# Adiciona repositório
echo "💾 Adding HashiCorp APT repository for $UBUNTU_CODENAME..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $UBUNTU_CODENAME main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

# Atualiza repositórios e instala terraform
echo "⬇️ Installing Terraform..."
sudo apt-get update -y
sudo apt-get install -y terraform

echo "✅ Terraform installed successfully."
