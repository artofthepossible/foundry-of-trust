#!/bin/bash

# 🏗️ Local Build Demo - Standard Base Images (No DHI)
# This script demonstrates building a container image using standard Eclipse Temurin base images
# without DHI (Demonstration Hardware Infrastructure) golden base images for comparison.

set -e

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local level="$1"
    local message="$2"
    case "$level" in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
        "COMMAND")
            echo -e "${CYAN}[COMMAND]${NC} $message"
            ;;
        "EXPLAIN")
            echo -e "${PURPLE}[EXPLAIN]${NC} $message"
            ;;
        *)
            echo "$message"
            ;;
    esac
}

# Function to print section headers
print_header() {
    echo ""
    echo "========================================"
    echo "$1"
    echo "========================================"
    echo ""
}

# Script introduction
print_header "🏗️ Local Build Demo - Standard Base Images"

print_status "INFO" "This demo builds a Spring Boot application container using standard Eclipse Temurin base images"
print_status "INFO" "We'll use Docker Buildx with enhanced security features enabled"
echo ""

# Command breakdown explanation
print_header "📖 Command Breakdown Explanation"

echo "We'll execute this Docker Buildx command:"
echo ""
print_status "COMMAND" "docker buildx build \\"
print_status "COMMAND" "  --builder cloud-demonstrationorg-default \\"
print_status "COMMAND" "  --sbom=true \\"
print_status "COMMAND" "  --provenance=true \\"
print_status "COMMAND" "  -t demonstrationorg/local-foundry-of-trust-nodhi:nodhi \\"
print_status "COMMAND" "  -f \"DockerfileNoDHI\" \\"
print_status "COMMAND" "  ."
echo ""

print_status "EXPLAIN" "Let's break down each parameter:"
echo ""

print_status "EXPLAIN" "🔧 --builder cloud-demonstrationorg-default"
echo "   → Uses a specific Docker Buildx builder instance"
echo "   → Provides enhanced build capabilities and remote building"
echo "   → Enables advanced features like multi-platform builds"
echo ""

print_status "EXPLAIN" "📋 --sbom=true"
echo "   → SBOM = Software Bill of Materials"
echo "   → Generates a detailed inventory of all software components"
echo "   → Lists dependencies, libraries, and their versions"
echo "   → Critical for supply chain security and vulnerability tracking"
echo ""

print_status "EXPLAIN" "🔒 --provenance=true"
echo "   → Creates cryptographic attestation of the build process"
echo "   → Records who built the image, when, and how"
echo "   → Provides build reproducibility and integrity verification"
echo "   → Enables security auditing and compliance"
echo ""

print_status "EXPLAIN" "🏷️ -t demonstrationorg/local-foundry-of-trust-nodhi:nodhi"
echo "   → Tags the built image with name and version"
echo "   → 'demonstrationorg' = organization namespace"
echo "   → 'local-foundry-of-trust-nodhi' = image name"
echo "   → 'nodhi' = tag indicating no DHI golden base images used"
echo ""

print_status "EXPLAIN" "📄 -f \"DockerfileNoDHI\""
echo "   → Specifies the Dockerfile to use for building"
echo "   → DockerfileNoDHI uses standard Eclipse Temurin base images"
echo "   → Compare with regular Dockerfile that uses DHI golden images"
echo ""

print_status "EXPLAIN" "📂 . (build context)"
echo "   → Uses current directory as build context"
echo "   → Includes all files needed for the build process"
echo "   → Source code, configuration files, and build scripts"
echo ""

# Dockerfile analysis
print_header "🔍 DockerfileNoDHI Analysis"

print_status "EXPLAIN" "This Dockerfile demonstrates a multi-stage build process:"
echo ""
print_status "EXPLAIN" "Stage 1 - Dependencies (eclipse-temurin:21-jdk-jammy)"
echo "   → Downloads and caches Maven dependencies"
echo "   → Uses standard Eclipse Temurin JDK for building"
echo "   → Leverages Docker layer caching for efficiency"
echo ""
print_status "EXPLAIN" "Stage 2 - Package (builds the application)"
echo "   → Compiles the Spring Boot application"
echo "   → Creates the executable JAR file"
echo "   → Optimizes for container deployment"
echo ""
print_status "EXPLAIN" "Stage 3 - Extract (prepares layered application)"
echo "   → Uses Spring Boot's layertools for optimal caching"
echo "   → Separates dependencies from application code"
echo "   → Improves Docker layer reuse and rebuild speed"
echo ""
print_status "EXPLAIN" "Stage 4 - Final Runtime (eclipse-temurin:21-jre-jammy)"
echo "   → Minimal runtime environment with JRE only"
echo "   → Non-privileged user for security"
echo "   → Optimized JVM settings for containers"
echo ""

# Security and benefits explanation
print_header "🔒 Security Features & Benefits"

print_status "EXPLAIN" "Enhanced Security Features:"
echo "   ✅ SBOM generation for dependency tracking"
echo "   ✅ Build provenance for supply chain integrity"
echo "   ✅ Multi-stage build reduces attack surface"
echo "   ✅ Non-privileged user execution"
echo "   ✅ Minimal runtime environment"
echo ""

print_status "EXPLAIN" "Performance Benefits:"
echo "   ⚡ Layer caching optimizes rebuild times"
echo "   ⚡ Dependency separation improves cache hits"
echo "   ⚡ JVM tuning for container environments"
echo "   ⚡ Minimal final image size"
echo ""

# Prerequisites check
print_header "🔧 Prerequisites Check"

print_status "INFO" "Checking build prerequisites..."

# Check Docker
if ! command -v docker >/dev/null 2>&1; then
    print_status "ERROR" "Docker not found. Please install Docker first."
    exit 1
fi
print_status "SUCCESS" "Docker is available"

# Check Docker Buildx
if ! docker buildx version >/dev/null 2>&1; then
    print_status "ERROR" "Docker Buildx not available. Please ensure Docker Buildx is installed."
    exit 1
fi
print_status "SUCCESS" "Docker Buildx is available"

# Check if builder exists
if ! docker buildx inspect cloud-demonstrationorg-default >/dev/null 2>&1; then
    print_status "WARNING" "Builder 'cloud-demonstrationorg-default' not found"
    print_status "INFO" "Will use default builder instead"
    BUILDER_ARG=""
else
    print_status "SUCCESS" "Builder 'cloud-demonstrationorg-default' is available"
    BUILDER_ARG="--builder cloud-demonstrationorg-default"
fi

# Check Dockerfile
if [[ ! -f "DockerfileNoDHI" ]]; then
    print_status "ERROR" "DockerfileNoDHI not found in current directory"
    exit 1
fi
print_status "SUCCESS" "DockerfileNoDHI found"

echo ""

# Execute the build
print_header "🚀 Executing Docker Build"

print_status "INFO" "Starting enhanced Docker build with security features..."
print_status "INFO" "This may take several minutes on first run (downloading base images and dependencies)"
echo ""

# Construct and display the command
BUILD_CMD="docker buildx build"
if [[ -n "$BUILDER_ARG" ]]; then
    BUILD_CMD="$BUILD_CMD $BUILDER_ARG"
fi
BUILD_CMD="$BUILD_CMD --sbom=true --provenance=true -t demonstrationorg/local-foundry-of-trust-nodhi:nodhi -f DockerfileNoDHI ."

print_status "COMMAND" "Executing: $BUILD_CMD"
echo "----------------------------------------"

# Execute the build command
if eval "$BUILD_CMD"; then
    print_status "SUCCESS" "Docker build completed successfully!"
else
    print_status "ERROR" "Docker build failed"
    exit 1
fi

echo ""

# Post-build analysis
print_header "📊 Build Results & Analysis"

print_status "INFO" "Analyzing the built image..."

# Check if image was created
if docker images demonstrationorg/local-foundry-of-trust-nodhi:nodhi >/dev/null 2>&1; then
    print_status "SUCCESS" "Image created successfully"
    
    # Show image details
    echo ""
    print_status "INFO" "Image details:"
    docker images demonstrationorg/local-foundry-of-trust-nodhi:nodhi --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""
    
    # Show layers (if possible)
    print_status "INFO" "Image layers and history:"
    docker history demonstrationorg/local-foundry-of-trust-nodhi:nodhi --format "table {{.CreatedBy}}\t{{.Size}}" | head -10
    
else
    print_status "WARNING" "Image verification failed"
fi

echo ""

# Summary and next steps
print_header "🎉 Build Demo Summary"

print_status "SUCCESS" "Local build demo completed successfully!"
echo ""
print_status "INFO" "What we accomplished:"
echo "   🏗️ Built Spring Boot application container"
echo "   📋 Generated Software Bill of Materials (SBOM)"
echo "   🔒 Created build provenance attestation"
echo "   ⚡ Used multi-stage build for optimization"
echo "   🔧 Applied standard Eclipse Temurin base images"
echo ""

print_status "INFO" "The image is now ready for:"
echo "   🚀 Local testing and development"
echo "   📤 Pushing to container registry"
echo "   🔄 Deployment to container platforms"
echo "   🔍 Security scanning and analysis"
echo ""

print_status "INFO" "Next steps:"
echo "   → Run: docker run -p 8080:8080 demonstrationorg/local-foundry-of-trust-nodhi:nodhi"
echo "   → Test: curl http://localhost:8080"
echo "   → Compare: Run demos/02-build-local-dhi.sh to see DHI golden image differences"
echo ""

print_status "INFO" "Security artifacts generated:"
echo "   → SBOM: Software Bill of Materials for dependency tracking"
echo "   → Provenance: Build attestation for supply chain verification"
