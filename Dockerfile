# CUDA 12.4 + Ubuntu 22.04
FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip \
    git ffmpeg \
    tmux \
    libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev \
    build-essential cmake ninja-build \
    curl wget ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python || true

WORKDIR /workspace

RUN python3 -m pip install --upgrade pip setuptools wheel \
 && python3 -m pip install hatchling editables \
 && python3 -m pip install jupyterlab notebook

RUN python3 -m pip install \
    "torch==2.5.1+cu121" \
    "torchvision==0.20.1+cu121" \
    --index-url https://download.pytorch.org/whl/cu121

# -----------------------------
# DEPTH-ANYTHING-3 + [gs]
# -----------------------------
RUN git clone https://github.com/ByteDance-Seed/Depth-Anything-3.git /workspace/Depth-Anything-3

WORKDIR /workspace/Depth-Anything-3

RUN python3 -m pip install --no-build-isolation -e ".[gs]"

ENV MODEL_DIR="depth-anything/DA3NESTED-GIANT-LARGE" \
    GALLERY_DIR="/workspace/gallery" \
    HF_HOME="/workspace/.cache/huggingface"

RUN mkdir -p /workspace/gallery

WORKDIR /workspace

EXPOSE 8888

CMD ["/bin/bash"]
