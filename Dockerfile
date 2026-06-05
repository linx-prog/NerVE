FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3-pip \
    curl xz-utils \
    libx11-6 libxrender1 libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://mirror.clarkson.edu/blender/release/Blender3.6/blender-3.6.9-linux-x64.tar.xz \
    | tar -xJ -C /opt \
    && ln -s /opt/blender-3.6.9-linux-x64/blender /usr/local/bin/blender

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

RUN pip install --upgrade pip

# Install PyTorch first
RUN pip install torch==1.12.1+cu113 \
                torchvision==0.13.1+cu113 \
                torchaudio==0.12.1 \
    --extra-index-url https://download.pytorch.org/whl/cu113

# Install your dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

WORKDIR /workspace

CMD ["bash"]