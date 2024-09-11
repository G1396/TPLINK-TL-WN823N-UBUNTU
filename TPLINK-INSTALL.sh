#!/bin/bash

# Updates the package list
sudo apt-get update

# Verifies that the rtl8812au-dkms package is installed
if dpkg -l | grep -q rtl8812au-dkms; then
    echo "Package rtl8812au-dkms found. Removing..."
    sudo apt-get remove -y rtl8812au-dkms
else
    echo "Package rtl8812au-dkms not found. Continuing installation..."
fi

# Install mokutil and check the status of Secure Boot
sudo apt-get install -y mokutil && mokutil --sb-state

# Install necessary packages
sudo apt-get install -y git linux-headers-generic build-essential dkms

# Clones the RTL8192EU driver repository
git clone https://github.com/clnhub/rtl8192eu-linux.git

# Navigates to the directory of the cloned repository
cd rtl8192eu-linux/

# Adds module to DKMS
sudo dkms add .

# Install the module with DKMS
sudo dkms install rtl8192eu/1.0

# Creates a blacklist rule for the rtl8xxxu module
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/rtl8xxxu.conf

echo "TPLink driver installation completed!"
