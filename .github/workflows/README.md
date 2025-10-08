# GitHub Actions Workflows

This repository contains several GitHub Actions workflows for building and securing container images.

## 🚀 Recommended Workflow: `build-with-vex-embedded.yml`

**Simple, fast, and secure** - builds your application with embedded VEX documents, SBOM, and provenance attestations.

### Features:
- ✅ Multi-platform builds (linux/amd64, linux/arm64)
- ✅ Embedded VEX document for CVE compliance
- ✅ SBOM generation for supply chain transparency
- ✅ Provenance attestations for build integrity
- ✅ Docker Scout security scanning
- ✅ SARIF upload to GitHub Security tab

### Required Secrets:
- `DOCKER_HUB_USERNAME`: Docker Hub username (should be "demonstrationorg")
- `DOCKER_HUB_TOKEN`: Docker Hub access token

### Triggers:
- Push to `main` or `develop` branches
- Tag pushes
- Pull requests to `main`
- Manual workflow dispatch

### Output:
- Container image: `demonstrationorg/foundry-of-trust:v1.1-DHI-fixed`
- VEX document embedded at `/app/vex.json`
- Security scan results in GitHub Security tab

## 📊 Comparison Workflow: `gha-build_image_remediate_ci.yml`

Comprehensive workflow that builds and compares standard vs DHI golden base images.

### Features:
- Builds both standard and hardened images
- Compares vulnerability counts
- Detailed security analysis
- Demonstrates security improvements

## 🔧 Legacy Workflows

Other workflows in this directory are for specific use cases:
- `build-with-vex.yml` - Original VEX workflow
- `targeted-vex-attachment.yml` - VEX attachment methods
- `vex-attestation.yml` - VEX as attestation
- `vex-automation.yml` - Automated VEX generation

## 🏃‍♂️ Quick Start

1. **Set up secrets** in your repository:
   - Go to Settings > Secrets and variables > Actions
   - Add `DOCKER_HUB_USERNAME` and `DOCKER_HUB_TOKEN`

2. **Push to main branch** or **create a tag**:
   ```bash
   git add .
   git commit -m "feat: add embedded VEX workflow"
   git push origin main
   ```

3. **Check the Actions tab** to see the build progress and results

4. **View security results** in the Security tab > Code scanning alerts

## 🔍 Testing Your Image

Once built, you can test the image locally:

```bash
# Pull the image
docker pull demonstrationorg/foundry-of-trust:v1.1-DHI-fixed

# Extract VEX document
docker run --rm --entrypoint='' demonstrationorg/foundry-of-trust:v1.1-DHI-fixed cat /app/vex.json

# View SBOM
docker scout sbom demonstrationorg/foundry-of-trust:v1.1-DHI-fixed

# Inspect all attestations
docker buildx imagetools inspect demonstrationorg/foundry-of-trust:v1.1-DHI-fixed
```

## 🛡️ Security Features

This workflow provides comprehensive supply chain security:

1. **VEX Documents**: Embedded vulnerability explanations
2. **SBOM**: Complete software bill of materials
3. **Provenance**: Build metadata and attestations
4. **Multi-platform**: Support for both amd64 and arm64
5. **Golden Base Images**: DHI hardened base images
6. **Automated Scanning**: Docker Scout integration