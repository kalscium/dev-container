FROM ubuntu:latest

# Rust toolchains
ENV RUST_TOOLCHAIN="nightly-x86_64-unknown-linux-gnu"
ENV RUST_TARGET_WIN="x86_64-pc-windows-gnu"
ENV SHELL="/usr/bin/zsh"

# Create my user
RUN useradd -m greenchild
RUN usermod -aG sudo greenchild
RUN echo 'greenchild ALL=(ALL) NOPASSWORD:ALL' >> /etc/sudoers

# Get the required packages from apt
RUN apt-get update -y
RUN apt-get install -y zsh python3 python3-pip tmux software-properties-common curl
# Build dependencies
RUN apt-get update -y
RUN apt-get install -y mingw-w64 gcc libclang-dev llvm-dev gcc-arm-none-eabi

# Install helix
RUN add-apt-repository ppa:maveonair/helix-editor
RUN apt-get update -y 
RUN apt install helix

# Install rust
RUN su greenchild -c "curl https://sh.rustup.rs -sSf | bash -s -- -y --default-toolchain $RUST_TOOLCHAIN --target $RUST_TARGET_WIN --component rust-src rustfmt clippy cargo rustc rust-std rust-docs rust-analyzer"

# Setup home dir
RUN mkdir /home/greenchild/project
COPY zshrc /home/greenchild/.zshrc
COPY helix /home/greenchild/.config/helix
COPY tmux.conf /home/greenchild/.tmux.conf
WORKDIR /home/greenchild/project

CMD su greenchild -c "SHELL='/usr/bin/zsh' tmux new-session -ds dev && tmux attach-session -t dev"
