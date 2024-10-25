Bootstrap: docker
From: continuumio/miniconda3

%files
    . /opt/cellstates

%environment
    export LC_ALL=C
    export PATH=/opt/conda/bin:$PATH

%post
    # Install system dependencies
    apt-get update && apt-get install -y \
        build-essential \
        gcc \
        g++ \
        libomp-dev \
        git \
        wget \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

    # Create conda environment with required dependencies
    conda create -n cellstates-env -y python=3.8
    . /opt/conda/etc/profile.d/conda.sh
    conda activate cellstates-env

    # Install required Python packages
    conda install -y \
        numpy \
        pandas \
        matplotlib \
        scipy \
        cython \
        ete3

    # Install cellstates
    cd /opt/cellstates
    CC=gcc python setup.py build_ext
    python setup.py install

    # Clean up
    conda clean -afy
    rm -rf /opt/conda/pkgs/*

%runscript
    . /opt/conda/etc/profile.d/conda.sh
    conda activate cellstates-env
    python "$@"

%help
    This container provides the cellstates package for analysis of UMI-based single-cell RNA-seq data.
    
    Usage:
    # To run the basic analysis:
    singularity run cellstates.sif ./scripts/run_cellstates.py data.tsv

    # To start a Python shell with cellstates available:
    singularity shell cellstates.sif

    For more information, visit: https://github.com/pascalg/cellstates
