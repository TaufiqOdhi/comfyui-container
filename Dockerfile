FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

# Install essential system packages (Git is required to clone ComfyUI)
RUN apt update && \
	apt install -y \
	git \
	curl \
	wget \
	vim && \
	rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash comfyui

# Switch to the non-root user
USER comfyui

# Set working directory inside the user's home
WORKDIR /home/comfyui/workspace

# Clone the ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Install ComfyUI's specific Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Launch ComfyUI and ensure it binds to 0.0.0.0 so you can access it via browser
CMD ["python", "main.py", "--listen", "0.0.0.0", "--enable-manager"]
