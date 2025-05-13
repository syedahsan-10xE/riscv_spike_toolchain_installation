#!/bin/bash

# RISC-V 32-bit Toolchain Installer (with Zicsr and Zifencei extensions)
set -e  # Exit if any command fails

# Configuration
INSTALL_DIR="$HOME/riscv32"
NUM_CORES=$(nproc)

echo "=== Setting up RISC-V 32-bit Toolchain ==="
echo "Target Architecture: rv32imac_zicsr_zifencei"
echo

# Step 1: Install dependencies
echo "[1/4] Installing required packages..."
sudo apt update && sudo apt install -y \
  autoconf automake autotools-dev build-essential bison flex \
  libexpat-dev libgmp-dev libglib2.0-dev libmpc-dev libmpfr-dev \
  libtool libusb-1.0-0-dev patchutils python3 python3-pip \
  texinfo gawk gperf zlib1g-dev curl git bc


# Step 2: Prepare environment
echo
echo "[2/4] Creating install directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
export RISCV="$INSTALL_DIR"
export PATH="$RISCV/bin:$PATH"

# Step 3: Clone and build the toolchain
echo
echo "[3/4] Cloning and building the RISC-V GNU toolchain..."
git clone --depth=1 https://github.com/riscv-collab/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
./configure --prefix="$INSTALL_DIR" \
    --with-arch=rv32imac_zicsr_zifencei \
    --with-abi=ilp32
make -j"$NUM_CORES"
cd ..

# Step 4: Build the Spike simulator and Proxy Kernel
echo
echo "[4/4] Building Spike (RISC-V simulator) and PK (Proxy Kernel)..."

# Clone and build Spike (ISA simulator)
git clone --depth=1 https://github.com/riscv-software-src/riscv-isa-sim.git
cd riscv-isa-sim
mkdir build && cd build
../configure --prefix="$INSTALL_DIR"
make -j"$NUM_CORES"
make install
cd ../..

# Clone and build Proxy Kernel (for bare-metal apps)
git clone --depth=1 https://github.com/riscv-software-src/riscv-pk.git
cd riscv-pk
mkdir build && cd build
../configure --prefix="$INSTALL_DIR" \
    --host=riscv32-unknown-elf \
    --with-arch=rv32imac_zicsr_zifencei
make -j"$NUM_CORES"
make install
cd ../..

# Update shell environment (if not already added)
if ! grep -q "export RISCV=$INSTALL_DIR" ~/.bashrc; then
    echo "export RISCV=$INSTALL_DIR" >> ~/.bashrc
    echo "export PATH=\$RISCV/bin:\$PATH" >> ~/.bashrc
fi

echo
echo "=== ✅ RISC-V 32-bit Toolchain Installation Complete! ==="
echo "Installed to: $INSTALL_DIR"
echo
echo "👉 To start using it, run:"
echo "   source ~/.bashrc"
echo
echo "👉 To test it, try:"
echo "   riscv32-unknown-elf-gcc --version"
