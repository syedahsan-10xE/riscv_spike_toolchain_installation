# riscv32_spike_toolchain_installation
Installing RISC-V 32-bit Toolchain
Steps:1
Download the Installation Script:
i.e latest_rv32_install.sh

Steps:2
Make the Script Executable:
chmod +x latest_rv32_install.sh

Steps:3
Run the Script:
./latest_rv32_install.sh

(if got any error try to clean any previous broken toolchain already install rm -rf <path of previous install toolchain>)

Steps:4
After installation, run:
source ~/.bashrc

Verify the Installation:
riscv32-unknown-elf-gcc --version
spike --version or spike --help


# riscv64_spike_toolchain_installation
Installing RISC-V 64-bit Toolchain
Steps:1
Download the Installation Script:
i.e latest_rv64_install.sh

Steps:2
Make the Script Executable:
chmod +x latest_rv64_install.sh

Steps:3
Run the Script:
./latest_rv64_install.sh

(if got any error try to clean any previous broken toolchain already install rm -rf <path of previous install toolchain>)

Steps:4
After installation, run:
source ~/.bashrc

Verify the Installation:
riscv64-unknown-elf-gcc --version
spike --version or spike --help
