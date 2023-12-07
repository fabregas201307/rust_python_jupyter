# Use a base image with Jupyter and Rust
FROM jupyter/base-notebook:latest

USER root

# Install wget and additional dependencies
RUN apt-get update && \
    apt-get install -y \
        wget \
        build-essential \
        libzmq3-dev \
        pkg-config \
        libssl-dev

# Install Rust
RUN wget https://sh.rustup.rs -O rustup-init.sh && \
    sh rustup-init.sh -y --no-modify-path && \
    rm rustup-init.sh
ENV PATH="/home/jovyan/.cargo/bin:${PATH}"

# Install Jupyter kernel for Rust
RUN cargo install evcxr_jupyter
RUN evcxr_jupyter --install

USER $NB_UID

# Set ownership of the Jupyter runtime directory
RUN fix-permissions /home/jovyan/.local/share/jupyter/runtime

# Expose Jupyter notebook port
EXPOSE 8888

# Start Jupyter notebook
CMD ["start-notebook.sh", "--NotebookApp.token=''"]
