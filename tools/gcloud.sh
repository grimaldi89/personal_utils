#!/bin/bash

set -e  # Exit if any command fails

echo "🔎 Checking if gcloud CLI is already installed..."
if command -v gcloud &> /dev/null; then
  echo "✅ gcloud is already installed. Updating..."
  sudo apt-get install -y google-cloud-cli
  echo "✅ gcloud CLI has been updated."
  exit 0
fi

echo "📦 gcloud not found. Installing dependencies..."

sudo apt-get install -y apt-transport-https ca-certificates gnupg curl

echo "🔐 Adding Google Cloud's GPG key..."
curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo "➕ Adding Google Cloud SDK repository..."
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null

echo "🚀 Installing Google Cloud CLI..."

sudo apt-get install -y google-cloud-cli

echo "⚙️ Running gcloud init..."
gcloud init
