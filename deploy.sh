#!/bin/bash
APP_DIR="/home/debian/service2"
GIT_USER="ricardo_vargas_campos"
GIT_TOKEN="${GITLAB_TOKEN_FROM_CI}"
REPO_URL="https://${GIT_USER}:${GIT_TOKEN}@gitlab.com/practica-iac/service2.git"

# 1. Instalar dependencias
sudo apt-get update -y
sudo apt-get install -y git curl

# 2. Instalar Node.js (versión LTS)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 3. Clonar/actualizar repositorio
if [ ! -d "$APP_DIR" ]; then
  git clone "$REPO_URL" "$APP_DIR"
else
  cd "$APP_DIR"
  git reset --hard HEAD
  git clean -fd
  git pull origin main
fi

# 4. Instalar dependencias y PM2 global
cd "$APP_DIR"
npm install
sudo npm install -g pm2

# 5. Configurar la aplicación
pm2 delete service2 2>/dev/null || true

# Usando el archivo index.js directamente
pm2 start index.js --name "service2" -- \
  --port=3000 \
  --host=0.0.0.0

# 6. Configurar inicio automático
pm2 save
sudo pm2 startup systemd -u debian --hp /home/debian

echo "✅ Despliegue completado! La app está corriendo en:"
echo "http://$(curl -s ifconfig.me):3000"