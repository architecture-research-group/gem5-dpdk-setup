# A script to prepare `d6515` machines in CloudLab for DPDK experiments
# with Mellanox ConnectX-5 NICs.

cd; sudo apt update

# Install dependencies.
sudo apt install -y cmake
sudo apt install -y meson
sudo apt install -y ninja-build
sudo apt install -y rdma-core
sudo apt install -y libibverbs-dev
sudo apt install -y libevent-dev
sudo apt install -y libgflags-dev

# Get DPDK.
wget https://fast.dpdk.org/rel/dpdk-20.11.3.tar.gz
tar -xvf dpdk-20.11.3.tar.gz

# Build DPDK.
cd dpdk-stable-20.11.3
meson setup build
cd build
ninja
sudo ninja install
