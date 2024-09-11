#!/bin/bash

# Atualiza a lista de pacotes
sudo apt-get update

# Verifica se o pacote rtl8812au-dkms está instalado
if dpkg -l | grep -q rtl8812au-dkms; then
    echo "Pacote rtl8812au-dkms encontrado. Removendo..."
    sudo apt-get remove -y rtl8812au-dkms
else
    echo "Pacote rtl8812au-dkms não encontrado. Continuando a instalação..."
fi

# Instala o mokutil e verifica o estado do Secure Boot
sudo apt-get install -y mokutil && mokutil --sb-state

# Instala pacotes necessários
sudo apt-get install -y git linux-headers-generic build-essential dkms

# Clona o repositório do driver RTL8192EU
git clone https://github.com/clnhub/rtl8192eu-linux.git

# Navega para o diretório do repositório clonado
cd rtl8192eu-linux/

# Adiciona o módulo ao DKMS
sudo dkms add .

# Instala o módulo com DKMS
sudo dkms install rtl8192eu/1.0

# Cria uma regra de blacklist para o módulo rtl8xxxu
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/rtl8xxxu.conf

echo "Instalação do driver da TPLink concluída!"
