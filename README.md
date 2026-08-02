# ComfyUI Container

A Docker-based setup for running [ComfyUI](https://github.com/comfyanonymous/ComfyUI) — a node-based GUI for Stable Diffusion and other generative AI models — with NVIDIA GPU support.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (v20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2.0+)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) — required for GPU passthrough
- An NVIDIA GPU with compatible drivers installed on the host

### Verifying Your Setup

```bash
# Check Docker is installed
docker --version

# Check Docker Compose is installed
docker compose version

# Check NVIDIA Container Toolkit is working
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

## Directory Structure

```
.
├── Dockerfile              # Container image definition (PyTorch 2.5.1 + CUDA 12.4)
├── docker-compose.yml      # Service orchestration with GPU and volume config
├── comfy_models/           # AI model checkpoints (mounted to /workspace/models)
├── comfy_nodes/            # Custom node extensions (mounted to /workspace/custom_nodes)
└── comfy_output/           # Generated images and outputs (mounted to /workspace/output)
```

| Directory | Container Path | Description |
|-----------|---------------|-------------|
| `comfy_models/` | `/workspace/models` | Place model checkpoints here (e.g. Stable Diffusion, LoRA, VAE). |
| `comfy_nodes/` | `/workspace/custom_nodes` | Custom node extensions (e.g. ComfyUI-Manager). |
| `comfy_output/` | `/workspace/output` | All generated images and outputs are saved here. |

> **Note:** `comfy_models/`, `comfy_nodes/`, and `comfy_output/` are gitignored. Their contents persist on your host machine across container rebuilds.

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/TaufiqOdhi/comfyui-container.git
cd comfyui-container
```

### 2. Build and Start the Container

```bash
docker compose up -d --build
```

### 3. Access ComfyUI

Open your browser and navigate to:

```
http://localhost:8188
```

### Managing the Container

```bash
# Stop the container
docker compose down

# Restart the container
docker compose restart

# View logs
docker compose logs -f comfyui

# Rebuild after Dockerfile changes
docker compose up -d --build
```

## Post-Installation

### Installing ComfyUI-Manager

[ComfyUI-Manager](https://github.com/ltdrdata/ComfyUI-Manager) lets you browse, install, and update custom nodes directly from the ComfyUI interface. To install it, clone the repository into the `comfy_nodes/` directory:

```bash
cd comfy_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
```

Then restart the container to load the manager:

```bash
docker compose restart
```

After restarting, click the **Manager** button in the ComfyUI interface to access it.

Through the Manager you can:

- Browse and install custom nodes from the community
- Install missing nodes required by imported workflows
- Update installed custom nodes

### Downloading Models

Models need to be placed in the appropriate subdirectories under `comfy_models/`. You can either download them manually or use ComfyUI-Manager's model installer.

Common model directories:

```
comfy_models/
├── checkpoints/    # Main model files (e.g. SD 1.5, SDXL, Flux)
├── clip/           # CLIP text encoder models
├── controlnet/     # ControlNet models
├── loras/          # LoRA fine-tune weights
├── unet/           # UNet / diffusion models
├── upscale_models/ # Upscaler models (e.g. RealESRGAN)
└── vae/            # VAE models
```

> **Tip:** You can download models from [Hugging Face](https://huggingface.co/) or [CivitAI](https://civitai.com/) and place them in the corresponding subdirectory.

### Installing Custom Nodes Manually

To install a custom node pack manually, clone it into the `comfy_nodes/` directory on your host:

```bash
cd comfy_nodes
git clone https://github.com/<author>/<node-repo>.git
```

Then restart the container to load the new nodes:

```bash
docker compose restart
```

Some custom nodes require additional Python packages. If a node fails to load, exec into the container and install its dependencies:

```bash
docker exec -it comfyui bash
cd /workspace/custom_nodes/<node-repo>
pip install -r requirements.txt
```

## Optional Configuration
### Antigravity CLI
Install the Antigravity CLI using these command inside running container:
```
curl -fsSL https://antigravity.google/cli/install.sh | bash
```
Post Installation Antigravity CLI, add PATH for `agy` command:
```
echo 'export PATH="/home/comfyui/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```
