FROM ubuntu:latest

# Rust toolchains
ENV RUST_TOOLCHAIN="rust-nightly"
ENV RUST_COMPONENTS="clippy-preview,cargo,rustc,rust-docs,rust-analyzer-preview"
ENV SHELL="/usr/bin/zsh"
ENV RUSTC_WRAPPER="sccache"

# Get the required packages from apt
RUN apt-get update -y
RUN apt-get install -y zsh python3 python3-pip tmux software-properties-common curl git file
# Build dependencies
RUN apt-get update -y
RUN apt-get install -y mingw-w64 gcc musl musl-tools libclang-dev llvm-dev clang libc6-dev gcc-arm-none-eabi pkg-config libssl-dev libx11-dev libasound2-dev libudev-dev libxkbcommon-x11-0 libwayland-dev libxkbcommon-dev mesa-vulkan-drivers

# Install helix
RUN add-apt-repository ppa:maveonair/helix-editor
RUN apt-get update -y 
RUN apt install helix

WORKDIR /tmp

# Install rust (linux)
RUN curl https://static.rust-lang.org/dist/$RUST_TOOLCHAIN-x86_64-unknown-linux-gnu.tar.xz -o $RUST_TOOLCHAIN-x86_64-unknown-linux-gnu.tar.xz
RUN tar -xf $RUST_TOOLCHAIN-x86_64-unknown-linux-gnu.tar.xz
RUN $RUST_TOOLCHAIN-x86_64-unknown-linux-gnu/install.sh --components=$RUST_COMPONENTS,rust-std-x86_64-unknown-linux-gnu

# Install rust (linux musl)
RUN curl https://static.rust-lang.org/dist/$RUST_TOOLCHAIN-x86_64-unknown-linux-musl.tar.xz -o $RUST_TOOLCHAIN-x86_64-unknown-linux-musl.tar.xz
RUN tar -xf $RUST_TOOLCHAIN-x86_64-unknown-linux-musl.tar.xz
RUN $RUST_TOOLCHAIN-x86_64-unknown-linux-musl/install.sh --components=rust-std-x86_64-unknown-linux-musl

# Install rust (mingw gnu)
RUN curl https://static.rust-lang.org/dist/$RUST_TOOLCHAIN-x86_64-pc-windows-gnu.tar.xz -o $RUST_TOOLCHAIN-x86_64-pc-windows-gnu.tar.xz
RUN tar -xf $RUST_TOOLCHAIN-x86_64-pc-windows-gnu.tar.xz
RUN $RUST_TOOLCHAIN-x86_64-pc-windows-gnu/install.sh --components=rust-std-x86_64-pc-windows-gnu

# Install bacon, taplo, sccache and bat
RUN RUSTC_WRAPPER="" cargo install bacon taplo-cli sccache bat just
# Install pros-cli (for vexv5 dev)
RUN pip install pros-cli --break-system-packages

# Move the installed cargo/bin binaries and set perms
RUN chmod -R a+rx /root/.cargo/bin
RUN mv /root/.cargo/bin/* /usr/local/bin

# Cleanup
RUN rm -rf /tmp/rust*
WORKDIR /

# Startup command
CMD zsh
