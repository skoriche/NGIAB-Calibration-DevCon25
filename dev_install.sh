#!/bin/sh

# Check if uv is installed
if ! command -v uv >/dev/null 2>&1; then
    echo "UV is not installed on your system."
    echo "UV is a fast Python package installer and resolver."
    echo ""
    printf "Would you like to install UV now? (y/n): "
    read -r response
    
    case "$response" in
        [Yy]|[Yy][Ee][Ss])
            echo "Installing UV..."
            curl -LsSf https://astral.sh/uv/install.sh | sh
            
            # Source the UV environment to make uv available in current session
            if [ -f "$HOME/.local/bin/env" ]; then
                . "$HOME/.local/bin/env"
            else
                # Add UV to PATH for this session
                export PATH="$HOME/.local/bin:$PATH"
            fi
            
            # Verify installation
            if command -v uv >/dev/null 2>&1; then
                echo "UV has been successfully installed!"
            else
                echo "UV installation completed but not immediately available in current session."
                echo "Please restart your shell or run: source $HOME/.local/bin/env"
                echo "Then re-run this script."
                exit 1
            fi
            ;;
        *)
            echo "UV installation cancelled. This script requires UV to function properly."
            echo "You can install UV later by running: curl -LsSf https://astral.sh/uv/install.sh | sh"
            exit 1
            ;;
    esac
else
    echo "UV is already installed. Version: $(uv --version)"
fi

# check for a virtual env and create one if it's missing
# running uv venv when there is alread a .venv will overwrite it
if [ ! -d ".venv" ]; then
	uv venv
fi

# download the code locally
git submodule init
git submodule update
# install the local code
uv pip install -e tools/NGIAB_data_preprocess
uv pip install -e tools/ngiab-cal
# building nextgen in a box
docker build -t my_ngiab tools/NGIAB-CloudInfra/docker/ && \
# change the ngen-cal base image by editing tools/ngen-cal/Dockerfile or running the command below
sed -i 's/awiciroh\/ciroh-ngen-image/my_ngiab/' tools/ngen-cal/Dockerfile && \
# Optionally patch the preprocessors --run command (this workshop won't use it)
sed -i 's/awiciroh\/ciroh-ngen-image:latest /my_ngiab /g' tools/NGIAB_data_preprocess/modules/ngiab_data_cli/__main__.py && \
## build ngen-cal image
docker build -t ngiab_cal tools/ngen-cal/ && \
# patch ngiab-cal --run to use your image
sed -i 's/^DOCKER.*/DOCKER_IMAGE_NAME = "ngiab_cal"/g' tools/ngiab-cal/src/ngiab_cal/__main__.py
