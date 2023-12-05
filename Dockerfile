# Use a base image with Jupyter and Rust
FROM jupyter/base-notebook:latest

USER root

# Install curl
RUN apt-get update && \
    apt-get install -y curl
    
# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/jovyan/.cargo/bin:${PATH}"

# Install Jupyter kernel for Rust
RUN cargo install evcxr_jupyter
RUN evcxr_jupyter --install

USER $NB_UID

# Expose Jupyter notebook port
EXPOSE 8888

# Start Jupyter notebook
CMD ["start-notebook.sh", "--NotebookApp.token=''"]
