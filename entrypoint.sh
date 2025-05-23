#!/bin/bash

echo "🔐 Baixando variáveis do Parameter Store..."

aws ssm get-parameters \
    --names "/hellospring/POSTGRES_DB" "/hellospring/POSTGRES_PASSWORD" "/hellospring/POSTGRES_USER" \
    --with-decryption \
    --query "Parameters[*].{Name:Name,Value:Value}" \
    --output text > raw_env.txt

echo "📦 Convertendo para .env"

cat raw_env.txt | while read -r line; do
  name=$(echo "$line" | awk '{print $1}' | awk -F '/' '{print $NF}')
  value=$(echo "$line" | awk '{print $2}')
  echo "$name=$value"
done > .env

echo "🚀 Subindo containers com docker-compose..."
docker compose up --build -d
