# Foundry of Trust - Golden Path Demo

> Demonstrating secure, compliant container builds with golden base images and comprehensive supply chain security.

## Overview

This demo showcases a complete secure development workflow using:
- **Golden Base Images** from a trusted registry
- **Multi-stage Docker builds** with instant success
- **SBOM & Provenance** generation via Docker Build Cloud
- **Vulnerability scanning** with Docker Scout
- **Version lineage tracking** across microservices

## 🎯 Demo Flow

### 1. Golden Base Image Strategy

Our application uses curated, hardened base images from the `demonstrationorg` registry:

```dockerfile
# Build Stage - Development tooling included
FROM demonstrationorg/dhi-temurin:21-jdk-alpine3.21-dev AS deps

# Runtime Stage - Minimal, production-ready
FROM demonstrationorg/dhi-temurin:21_whale AS final
```

**Benefits:**
- ✅ Pre-hardened and vulnerability-scanned
- ✅ Consistent across all microservices
- ✅ Reduced attack surface
- ✅ Compliance-ready

### 2. Instant Success Docker Build

Build with Docker Build Cloud for enhanced performance and built-in security features:

```bash
# Single command - instant success, no missing dependencies
docker buildx build \
  --builder cloud-demonstrationorg-default \
  --sbom=true \
  --provenance=true \
  -t demonstrationorg/foundry-of-trust:v1.0 \
  .
```

**What happens:**
- 🚀 **Fast builds** via cloud infrastructure
- 📋 **SBOM generation** for supply chain transparency
- 🔒 **Provenance attestation** for build integrity
- 📦 **Optimized layers** for efficient distribution

### 3. Security Scanning with Docker Scout

Validate your image security posture:

```bash
# Comprehensive vulnerability scan
docker scout cves demonstrationorg/foundry-of-trust:v1.0

# Policy evaluation
docker scout policy demonstrationorg/foundry-of-trust:v1.0

# Compare against base image
docker scout compare --to demonstrationorg/dhi-temurin:21_whale \
  demonstrationorg/foundry-of-trust:v1.0
```

**Expected Results:**
- ✅ **Zero Critical CVEs** (thanks to golden base images)
- ✅ **Signed attestations** verified
- ✅ **Policy compliance** passed
- ✅ **Supply chain verified**

### 4. Version Lineage Tracking

Track all microservices built from the same golden base:

```bash
# Discover all images using our golden base
docker scout repo demonstrationorg --filter "base-image:demonstrationorg/dhi-temurin:21_whale"

# Generate lineage report
docker scout lineage demonstrationorg/dhi-temurin:21_whale
```

## 🏃‍♂️ Quick Start

### Prerequisites

```bash
# Install Docker with buildx
docker --version
docker buildx version

# Login to demonstration registry
docker login demonstrationorg

# Install Docker Scout
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh
```

### Build and Scan

1. **Clone and build:**
   ```bash
   git clone <repo-url>
   cd foundry-of-trust
   
   # Build with security attestations
   docker buildx build \
     --builder cloud-demonstrationorg-default \
     --sbom=true \
     --provenance=true \
     -t demonstrationorg/foundry-of-trust:v1.0 \
     .
   ```

2. **Verify security:**
   ```bash
   # Quick vulnerability check
   docker scout quickview demonstrationorg/foundry-of-trust:v1.0
   
   # Detailed analysis
   docker scout cves demonstrationorg/foundry-of-trust:v1.0
   ```

3. **Check lineage:**
   ```bash
   # View all services using this base
   docker scout lineage demonstrationorg/dhi-temurin:21_whale
   ```

## 🔄 CI/CD Integration

### GitHub Actions Workflow

Create `.github/workflows/secure-build.yml`:

```yaml
name: Secure Container Build & Remediation

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: demonstrationorg
  IMAGE_NAME: foundry-of-trust

jobs:
  build-scan-remediate:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
      id-token: write
      attestations: write

    steps:
    - name: Checkout repository
      uses: actions/checkout@v4

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
      with:
        builder: cloud-demonstrationorg-default

    - name: Log into registry
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_TOKEN }}

    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=sha,prefix={{branch}}-
          type=raw,value=latest,enable={{is_default_branch}}

    - name: Build and push image
      id: build
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        sbom: true
        provenance: true
        builder: cloud-demonstrationorg-default

    - name: Generate SBOM attestation
      uses: actions/attest-sbom@v1
      with:
        subject-name: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        subject-digest: ${{ steps.build.outputs.digest }}
        sbom-path: sbom.json

    - name: Docker Scout - CVE Analysis
      id: scout-cves
      uses: docker/scout-action@v1
      with:
        command: cves
        image: ${{ steps.meta.outputs.tags }}
        sarif-file: sarif.output.json
        summary: true

    - name: Upload SARIF result
      uses: github/codeql-action/upload-sarif@v3
      if: always()
      with:
        sarif_file: sarif.output.json

    - name: Docker Scout - Policy Check
      uses: docker/scout-action@v1
      with:
        command: policy
        image: ${{ steps.meta.outputs.tags }}

    - name: Docker Scout - Compare to Base
      uses: docker/scout-action@v1
      with:
        command: compare
        image: ${{ steps.meta.outputs.tags }}
        to: demonstrationorg/dhi-temurin:21_whale

    - name: Generate Security Report
      run: |
        echo "## 🔒 Security Analysis Report" >> $GITHUB_STEP_SUMMARY
        echo "- **Base Image**: demonstrationorg/dhi-temurin:21_whale" >> $GITHUB_STEP_SUMMARY
        echo "- **Built Image**: ${{ steps.meta.outputs.tags }}" >> $GITHUB_STEP_SUMMARY
        echo "- **SBOM Generated**: ✅" >> $GITHUB_STEP_SUMMARY
        echo "- **Provenance Attestation**: ✅" >> $GITHUB_STEP_SUMMARY
        echo "- **Vulnerability Scan**: ✅" >> $GITHUB_STEP_SUMMARY
```

## 📊 Demo Script

### Scene 1: Golden Base Images
```bash
# Show available golden base images
docker images demonstrationorg/dhi-temurin:*

# Explain the multi-stage approach
cat Dockerfile
```

### Scene 2: Instant Build Success
```bash
# Demonstrate build speed and success
time docker buildx build \
  --builder cloud-demonstrationorg-default \
  --sbom=true \
  --provenance=true \
  -t demonstrationorg/foundry-of-trust:v1.0 \
  .
```

### Scene 3: Security Validation
```bash
# Show clean vulnerability report
docker scout cves demonstrationorg/foundry-of-trust:v1.0

# Verify signatures and attestations
docker scout policy demonstrationorg/foundry-of-trust:v1.0
```

### Scene 4: Version Lineage
```bash
# Show all microservices using golden base
docker scout lineage demonstrationorg/dhi-temurin:21_whale

# Demonstrate centralized security management
docker scout repo demonstrationorg
```

## 🎬 Key Demo Points

1. **"Zero Touch" Security**: Golden base images eliminate common vulnerabilities
2. **Build Confidence**: Instant success with no dependency issues
3. **Supply Chain Transparency**: SBOM and provenance provide complete visibility
4. **Continuous Monitoring**: Docker Scout provides ongoing security oversight
5. **Ecosystem Benefits**: All microservices inherit security improvements

## 🔧 Troubleshooting

### Common Issues

**Build fails with base image not found:**
```bash
# Verify registry access
docker login demonstrationorg
docker pull demonstrationorg/dhi-temurin:21_whale
```

**Docker Scout not showing results:**
```bash
# Enable Docker Scout
docker scout enroll

# Verify organization access
docker scout org list
```

## 📚 Additional Resources

- [Docker Build Cloud Documentation](https://docs.docker.com/build/cloud/)
- [Docker Scout CLI Reference](https://docs.docker.com/scout/cli/)
- [SBOM and Provenance Guide](https://docs.docker.com/build/attestations/)
- [Golden Base Image Strategy](https://example.com/golden-images)

---

*This demo showcases the power of secure-by-default container builds with golden base images and comprehensive supply chain security.*