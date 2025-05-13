#!/bin/bash

# RISC-V 64-bit Toolchain Installer (default architecture: rv64gc)
set -e  # Exit immediately if a command fails

# Configuration
INSTALL_DIR="$HOME/riscv64"  # Where the toolchain will be installed
NUM_CORES=$(nproc)  # Number of CPU cores to use for compilation

echo "=== Installing RISC-V 64-bit Toolchain ==="
echo "Target architecture: rv64gc (default)"
echo

# Step 1: Install dependencies
echo "[1/4] Installing required dependencies..."
sudo apt update
sudo apt install -y git build-essential autoconf automake libtool \
    pkg-config libmpc-dev libmpfr-dev libgmp-dev gawk bison flex \
    texinfo gperf libusb-1.0-0-dev device-tree-compiler zlib1g-dev

echo
# Step 2: Prepare the installation environment
echo "[2/4] Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
export RISCV64="$INSTALL_DIR"
export PATH="$RISCV64/bin:$PATH"

echo
# Step 3: Clone and build the RISC-V toolchain
echo "[3/4] Cloning and building the RISC-V GNU toolchain..."
git clone --depth=1 https://github.com/riscv-collab/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
./configure --prefix="$RISCV64"  # Configure the toolchain
make -j"$NUM_CORES"  # Build with parallel jobs (faster)
cd ..

echo
# Step 4: Build Spike (RISC-V ISA simulator) and Proxy Kernel (PK)
echo "[4/4] Cloning and building Spike (RISC-V ISA simulator)..."
git clone --depth=1 https://github.com/riscv-software-src/riscv-isa-sim.git
cd riscv-isa-sim
mkdir build && cd build
../configure --prefix="$RISCV64"
make -j"$NUM_CORES"
make install
cd ../..

echo
echo "Building Proxy Kernel (PK) for bare-metal apps..."
git clone --depth=1 https://github.com/riscv-software-src/riscv-pk.git
cd riscv-pk
mkdir build && cd build
../configure --prefix="$RISCV64" --host=riscv64-unknown-elf
make -j"$NUM_CORES"
make install
cd ../..

# Add the toolchain to ~/.bashrc (if it's not already there)
echo
echo "=== Finalizing installation... ==="
if ! grep -q 'export RISCV64=' ~/.bashrc; then
    echo "export RISCV64=$INSTALL_DIR" >> ~/.bashrc
    echo "export PATH=\$RISCV64/bin:\$PATH" >> ~/.bashrc
fi

# Completion message
echo
echo "=== ✅ Installation Complete! ==="
echo "The RISC-V 64-bit toolchain has been successfully installed at:"
echo "  $RISCV64"
echo
echo "👉 To activate the toolchain, run:"
echo "    source ~/.bashrc"
echo
echo "👉 To test the installation, try running:"
echo "    riscv64-unknown-elf-gcc --version"
