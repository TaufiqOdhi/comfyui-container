FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

# Set working directory
WORKDIR /workspace

# Install essential system packages (Git is required to clone ComfyUI)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone the ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Install ComfyUI's specific Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Launch ComfyUI and ensure it binds to 0.0.0.0 so you can access it via browser
CMD ["python", "main.py", "--listen", "0.0.0.0"]
