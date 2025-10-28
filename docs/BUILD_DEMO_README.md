# 🏗️ Local Build Demo - Standard Base Images

## Overview

This demo script (`01-build-local.sh`) demonstrates building a Spring Boot container image using standard Eclipse Temurin base images with enhanced security features.

## What It Does

The script executes this Docker Buildx command with comprehensive explanations:

```bash
docker buildx build \
  --builder cloud-demonstrationorg-default \
  --sbom=true \
  --provenance=true \
  -t demonstrationorg/local-foundry-of-trust-nodhi:nodhi \
  -f "DockerfileNoDHI" \
  .
```

## Key Features

### 🔒 **Security Enhancements**
- **SBOM Generation**: Creates Software Bill of Materials for dependency tracking
- **Build Provenance**: Generates cryptographic attestation of build process
- **Multi-stage Build**: Reduces attack surface and image size
- **Non-privileged User**: Runs application as non-root user

### ⚡ **Performance Optimization**
- **Layer Caching**: Optimizes rebuild times
- **Dependency Separation**: Improves cache hit rates
- **JVM Tuning**: Container-optimized Java settings
- **Minimal Runtime**: JRE-only final image

### 📖 **Educational Content**
- **Command Breakdown**: Detailed explanation of each Docker parameter
- **Dockerfile Analysis**: Multi-stage build process explanation
- **Security Features**: Benefits and implementation details
- **Prerequisites Check**: Validates build environment

## Usage

```bash
# Run the complete demo
./demos/01-build-local.sh

# Test the built image
docker run -p 8080:8080 demonstrationorg/local-foundry-of-trust-nodhi:nodhi
curl http://localhost:8080
```

## Build Results

- **Image Size**: ~445MB
- **Base Images**: Eclipse Temurin (standard)
- **Security**: SBOM + Provenance included
- **Architecture**: Multi-stage optimized

## Educational Value

This script serves as:
- **Documentation**: Self-explaining build process
- **Training Tool**: Teaches Docker security best practices
- **Comparison Baseline**: Standard images vs DHI golden images
- **Security Demo**: SBOM and provenance generation

## Next Steps

After running this demo:
1. **Test the Application**: Verify it runs correctly
2. **Inspect Security Artifacts**: Examine SBOM and provenance
3. **Compare with DHI**: Run `02-build-local-dhi.sh` for comparison
4. **Deploy**: Use image in container platforms

## Prerequisites

- Docker with Buildx support
- Access to `cloud-demonstrationorg-default` builder (optional)
- Internet connection for base image downloads