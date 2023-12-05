# Use a base image with Jupyter and Rust
FROM jupyter/base-notebook:latest

USER root

# Install additional dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libzmq3-dev \
        pkg-config \
        libssl-dev

# # Install Rust
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# ENV PATH="/home/jovyan/.cargo/bin:${PATH}"

# Install Rust
RUN wget https://sh.rustup.rs -O rustup-init.sh && \
    sh rustup-init.sh -y --no-modify-path && \
    rm rustup-init.sh
ENV PATH="/home/jovyan/.cargo/bin:${PATH}"


# Install Jupyter kernel for Rust
RUN cargo install evcxr_jupyter
RUN evcxr_jupyter --install

USER $NB_UID
# USER jovyan
# Expose Jupyter notebook port
EXPOSE 8888

# Start Jupyter notebook
CMD ["start-notebook.sh", "--NotebookApp.token=''"]
