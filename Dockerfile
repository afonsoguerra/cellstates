# Use miniconda as base image
FROM continuumio/miniconda3

# Set working directory
WORKDIR /opt/cellstates

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    libomp-dev \
    git \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the source code
COPY . /opt/cellstates/

# Add conda-forge channel and create environment
RUN conda config --add channels conda-forge \
    && conda config --set channel_priority strict

# Create conda environment and install dependencies
RUN conda create -n cellstates-env -y python=3.8 \
    && . /opt/conda/etc/profile.d/conda.sh \
    && conda activate cellstates-env \
    && conda install -y -c conda-forge \
        numpy \
        pandas \
        matplotlib \
        scipy \
        cython \
        ete3 \
    && conda clean -afy \
    && rm -rf /opt/conda/pkgs/*

# Install cellstates
RUN . /opt/conda/etc/profile.d/conda.sh \
    && conda activate cellstates-env \
    && CC=gcc python setup.py build_ext \
    && python setup.py install

# Set up entry point script
RUN echo '#!/bin/bash\n\
. /opt/conda/etc/profile.d/conda.sh\n\
conda activate cellstates-env\n\
exec "$@"' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Set the entry point
ENTRYPOINT ["/entrypoint.sh"]

# Default command (can be overridden)
CMD ["python", "./scripts/run_cellstates.py", "--help"]

# Add labels
LABEL maintainer="Pascal Grobecker <pascal.grobecker@unibas.ch>" \
      description="Container for cellstates - Analysis of UMI-based single-cell RNA-seq data" \
      version="0.1"
