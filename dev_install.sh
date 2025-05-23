#!/bin/sh

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print formatted messages
print_header() {
    echo ""
    echo "${BLUE}===================================================${NC}"
    echo "${BLUE}$1${NC}"
    echo "${BLUE}===================================================${NC}"
    echo ""
}

print_success() {
    echo "${GREEN}✓ $1${NC}"
}

print_error() {
    echo "${RED}✗ $1${NC}"
}

print_warning() {
    echo "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo "${BLUE}ℹ $1${NC}"
}

# Check if UV is installed
check_uv_installation() {
    print_header "Checking UV Installation"
    
    if ! command -v uv >/dev/null 2>&1; then
        print_warning "UV is not installed on your system."
        print_info "UV is a fast Python package installer and resolver."
        echo ""
        printf "Would you like to install UV now? (y/n): "
        read -r response
        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                echo ""
                print_info "Installing UV..."
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
                    print_success "UV has been successfully installed!"
                    UV_WAS_INSTALLED=1
                else
                    print_error "UV installation completed but not immediately available in current session."
                    echo "Please restart your shell or run: source $HOME/.local/bin/env"
                    echo "Then re-run this script."
                    exit 1
                fi
                ;;
            *)
                print_error "UV installation cancelled. This script requires UV to function properly."
                echo "You can install UV later by running: curl -LsSf https://astral.sh/uv/install.sh | sh"
                exit 1
                ;;
        esac
    else
        print_success "UV is already installed. Version: $(uv --version)"
    fi
}

# Create virtual environment if needed
setup_virtual_env() {
    print_header "Setting Up Virtual Environment"
    
    if [ ! -d ".venv" ]; then
        print_info "Creating virtual environment..."
        uv venv
        print_success "Virtual environment created"
        VENV_WAS_CREATED=1
    else
        print_success "Virtual environment already exists"
    fi
}

# Download code via git submodules
download_submodules() {
    print_header "Downloading Git Submodules"
    
    print_info "Initializing submodules..."
    git submodule init
    
    print_info "Updating submodules..."
    git submodule update
    
    print_success "Submodules downloaded"
}

# Install local packages
install_local_packages() {
    print_header "Installing Local Packages"
    
    print_info "Installing NGIAB_data_preprocess..."
    uv pip install -e tools/NGIAB_data_preprocess
    
    print_info "Installing ngiab-cal..."
    uv pip install -e tools/ngiab-cal
    
    print_success "Local packages installed"
}

# Build Docker images with confirmation
build_docker_images() {
    print_header "Docker Build Process"
    
    print_warning "The following Docker build process will:"
    echo "  1. Build the NextGen in a Box (NGIAB) Docker image"
    echo "  2. Update configurations to use your local image"
    echo "  3. Build the ngen-cal Docker image"
    echo ""
    print_warning "NOTE: This process may take around 10 minutes if running for the first time!"
    echo ""
    printf "Do you want to proceed with the Docker builds? (y/n): "
    read -r response
    
    case "$response" in
        [Yy]|[Yy][Ee][Ss])
            echo ""
            print_info "Starting Docker build process..."
            
            # Building nextgen in a box
            print_info "Building NextGen in a Box Docker image..."
            if docker build -t my_ngiab tools/NGIAB-CloudInfra/docker/; then
                print_success "NextGen in a Box image built successfully"
            else
                print_error "Failed to build NextGen in a Box image"
                exit 1
            fi
            
            # Change the ngen-cal base image
            print_info "Updating ngen-cal Dockerfile to use local image..."
            sed -i 's/awiciroh\/ciroh-ngen-image/my_ngiab/' tools/ngen-cal/Dockerfile
            print_success "Dockerfile updated"
            
            # Patch the preprocessors --run command
            print_info "Patching preprocessor commands..."
            sed -i 's/awiciroh\/ciroh-ngen-image:latest /my_ngiab /g' tools/NGIAB_data_preprocess/modules/ngiab_data_cli/__main__.py
            print_success "Preprocessor commands patched"
            
            # Build ngen-cal image
            print_info "Building ngen-cal Docker image..."
            if docker build -t ngiab_cal tools/ngen-cal/; then
                print_success "ngen-cal image built successfully"
            else
                print_error "Failed to build ngen-cal image"
                exit 1
            fi
            
            # Patch ngiab-cal --run to use your image
            print_info "Updating ngiab-cal to use local Docker image..."
            sed -i 's/^DOCKER.*/DOCKER_IMAGE_NAME = "ngiab_cal"/g' tools/ngiab-cal/src/ngiab_cal/__main__.py
            print_success "ngiab-cal configuration updated"
            
            DOCKER_WAS_BUILT=1
            
            print_header "Installation Complete!"
            print_success "All components have been successfully installed and configured."
            ;;
        *)
            print_warning "Docker build cancelled."
            print_info "You can run this script again later to complete the Docker builds."
            print_info "All other components have been installed successfully."
            ;;
    esac
}

# Track what was done during installation
UV_WAS_INSTALLED=0
VENV_WAS_CREATED=0
DOCKER_WAS_BUILT=0

# Print installation summary
print_summary() {
    print_header "Installation Summary"
    
    echo "${GREEN}The following actions were completed:${NC}"
    echo ""
    
    # UV installation status
    if [ $UV_WAS_INSTALLED -eq 1 ]; then
        print_success "UV package manager was installed"
        echo ""
        print_warning "IMPORTANT: To use UV in new terminal sessions, you need to either:"
        echo "  • Restart your shell, OR"
        echo "  • Run: ${YELLOW}source $HOME/.local/bin/env${NC}"
        echo ""
    else
        print_info "UV was already installed (no action needed)"
    fi
    
    # Virtual environment status
    if [ $VENV_WAS_CREATED -eq 1 ]; then
        print_success "Python virtual environment was created (.venv)"
    else
        print_info "Virtual environment already existed (no action needed)"
    fi
    
    # Other installations
    print_success "Git submodules were initialized and updated"
    print_success "Local Python packages were installed:"
    echo "  • NGIAB_data_preprocess (tools/NGIAB_data_preprocess)"
    echo "  • ngiab-cal (tools/ngiab-cal)"
    
    # Docker build status
    if [ $DOCKER_WAS_BUILT -eq 1 ]; then
        print_success "Docker images were built:"
        echo "  • my_ngiab (NextGen in a Box base image)"
        echo "  • ngiab_cal (ngen-cal image)"
        print_success "Configuration files were updated to use local Docker images"
    else
        print_warning "Docker builds were skipped"
        echo "  Run this script again and choose 'y' when prompted to build Docker images"
    fi
    
    echo ""
    print_header "Available CLI Tools"
    
    echo "${GREEN}The following command-line tools are now available:${NC}"
    echo ""
    
    echo "1. ${BLUE}Data Preprocessor:${NC}"
    echo "   Run: ${YELLOW}uv run cli${NC}"
    echo "   Help: ${YELLOW}uv run cli --help${NC}"
    echo ""
    
    echo "2. ${BLUE}Calibration Tool:${NC}"
    echo "   Run: ${YELLOW}uv run ngiab-cal${NC}"
    echo "   Help: ${YELLOW}uv run ngiab-cal --help${NC}"
    echo ""
    
    print_header "Next Steps"
    
    if [ $UV_WAS_INSTALLED -eq 1 ]; then
        echo "1. ${YELLOW}Source the UV environment or restart your shell${NC}"
        echo "   Run: source $HOME/.local/bin/env"
        echo ""
    fi
    
    echo "2. Activate the Python virtual environment (optional):"
    echo "   ${YELLOW}source .venv/bin/activate${NC}"
    echo ""
    
    echo "3. Try out the CLI tools:"
    echo "   • ${YELLOW}uv run cli --help${NC} to see preprocessor options"
    echo "   • ${YELLOW}uv run ngiab-cal --help${NC} to see calibration tool options"
    echo ""
    
    if [ $DOCKER_WAS_BUILT -eq 0 ]; then
        echo "4. Run this script again to build Docker images when ready"
        echo ""
    fi
    
    print_success "Installation script completed!"
}

# Main installation flow
main() {
    print_header "NGIAB Installation Script"
    
    # Step 1: Check and install UV if needed
    check_uv_installation
    
    # Step 2: Setup virtual environment
    setup_virtual_env
    
    # Step 3: Download git submodules
    download_submodules
    
    # Step 4: Install local packages
    install_local_packages
    
    # Step 5: Build Docker images (with confirmation)
    build_docker_images
    
    # Step 6: Print summary
    print_summary
}

# Run the main function
main
