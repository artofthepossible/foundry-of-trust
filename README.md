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

### 1. Developer Workflow: From Vulnerability to Security

#### Step 1: Initial Build with Standard Images

First, let's see what happens with standard container images:

```dockerfile
# Standard Eclipse Temurin images (current state)
FROM eclipse-temurin:21-jdk-jammy AS deps
FROM eclipse-temurin:21-jre-jammy AS final
```

Build with standard images to see vulnerabilities:

```bash
# Build with standard base images
docker buildx build \
  --builder cloud-demonstrationorg-default \
  --sbom=true \
  --provenance=true \
  -t demonstrationorg/foundry-of-trust:v1.0-NoDHI \
  .
```

#### Step 2: Local Security Scanning in VS Code

**Before they even push**, Docker Scout runs locally via VS Code:

```bash
# Scan for vulnerabilities immediately after build
docker scout cves demonstrationorg/foundry-of-trust:v1.0-NoDHI
```

**What developers see:**
- ⚠️ **Vulnerabilities flagged** - Critical CVEs in base images
- 🚫 **Policy violations caught** - Non-compliant dependencies  
- 💡 **Remediation guidance right there** - Fix suggestions in seconds, not days

#### Step 3: Instant Fix with Golden Base Images

Update to DHI golden base images for immediate security improvement:

```dockerfile
# Build Stage - Development tooling included
FROM demonstrationorg/dhi-temurin:21-jdk-alpine3.21-dev AS deps

# Runtime Stage - Minimal, production-ready
FROM demonstrationorg/dhi-temurin:21_whale AS final
```

#### Step 4: Secure Build and Push

Build with golden base images and push to registry:

```bash
# Build with golden base images - instant security improvement
docker buildx build \
  --builder cloud-demonstrationorg-default \
  --sbom=true \
  --provenance=true \
  -t demonstrationorg/foundry-of-trust:v1.0-DHI \
  --push \
  .
```

**Result:**
- ✅ **Zero Critical CVEs** (thanks to golden base images)
- ✅ **Policy compliance** achieved instantly
- ✅ **Supply chain secured** with SBOM and provenance
- ✅ **Ready for production** with minimal effort

### 2. Golden Base Image Strategy

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

### 3. Instant Success Docker Build

Build with Docker Build Cloud for enhanced performance and built-in security features:

```bash
# Single command - instant success, no missing dependencies
docker buildx build \
  --builder cloud-demonstrationorg-default \
  --sbom=true \
  --provenance=true \
  -t demonstrationorg/foundry-of-trust:v1.0-DHI \
  --push \
  .
```

**What happens:**
- 🚀 **Fast builds** via cloud infrastructure
- 📋 **SBOM generation** for supply chain transparency
- 🔒 **Provenance attestation** for build integrity
- 📦 **Optimized layers** for efficient distribution

## 🔧 Security Vulnerability Remediation

### Fixed CVEs through Dependency Updates

This project has been updated to address critical security vulnerabilities identified through Docker Scout scanning:

#### **🚨 Critical Fixes Applied**

**CVE-2025-24813 (CRITICAL - CVSS 9.2)**
- **Component**: Apache Tomcat Embed Core 10.1.16
- **Vulnerability**: Path Equivalence: 'file.name' (Internal Dot) - CISA KEV listed
- **Fix Applied**: Upgraded to Tomcat 10.1.44
- **Impact**: Eliminates critical path traversal vulnerability

#### **🔴 High-Priority Fixes Applied**

**Multiple Tomcat CVEs Fixed (10.1.16 → 10.1.44)**
- CVE-2025-48988: Resource allocation without limits (CVSS 8.7)
- CVE-2024-34750: Uncontrolled resource consumption (CVSS 8.7) 
- CVE-2025-48989: Improper resource shutdown (CVSS 7.5)
- CVE-2024-56337: TOCTOU race condition (CVSS 7.2)
- CVE-2024-50379: TOCTOU race condition (CVSS 7.2)

**Logback Security Fixes (1.4.11 → 1.4.12)**
- CVE-2023-6378: Deserialization of untrusted data (CVSS 7.1)
- CVE-2024-12798: Expression language injection (CVSS 5.9)
- CVE-2024-12801: Server-side request forgery (CVSS 2.4)

**Spring Framework Updates (3.2.0 → 3.2.10)**
- Multiple path traversal vulnerabilities fixed
- Open redirect vulnerabilities patched
- Input validation improvements

#### **📋 Summary of Changes**

| Component | Before | After | CVEs Fixed |
|-----------|---------|--------|------------|
| **Spring Boot** | 3.2.0 | 3.2.10 | Multiple Spring CVEs |
| **Tomcat Embed** | 10.1.16 | 10.1.44 | **1 Critical + 5 High** |
| **Logback** | 1.4.11 | 1.4.12 | **2 High + 1 Medium** |

#### **⚠️ Remaining Unfixed CVEs**

Some CVEs remain unfixed due to no available patches:
- CVE-2025-41242 (Spring WebMVC): No fix available yet
- CVE-2025-41249 (Spring Core): No fix available yet  
- CVE-2025-22235 (Spring Boot): No fix available yet
- Various OS-level packages in base image (fixed in golden base images)

### Verification Commands

After applying fixes, verify the improvements:

```bash
# Rebuild with updated dependencies
mvn clean package

# Rebuild Docker image
docker buildx build -t demonstrationorg/foundry-of-trust:v1.1-fixed .

# Scan for remaining vulnerabilities
docker scout cves demonstrationorg/foundry-of-trust:v1.1-fixed

# Compare with previous version
docker scout compare demonstrationorg/foundry-of-trust:v1.0-NoDHI \
  --to demonstrationorg/foundry-of-trust:v1.1-fixed
```

## 🛡️ Security Scanning with Docker Scout

Validate your image security posture:

```bash
# Compare: Standard vs Golden Base Images
docker scout cves demonstrationorg/foundry-of-trust:v1.0-NoDHI
docker scout cves demonstrationorg/foundry-of-trust:v1.0-DHI

# Policy evaluation
docker scout policy demonstrationorg/foundry-of-trust:v1.0-DHI

# Compare against base image
docker scout compare --to demonstrationorg/dhi-temurin:21_whale \
  demonstrationorg/foundry-of-trust:v1.0-DHI
```

**Expected Results:**
- ❌ **Multiple CVEs** in NoDHI version (standard images)
- ✅ **Zero Critical CVEs** in DHI version (golden base images)
- ✅ **Signed attestations** verified
- ✅ **Policy compliance** passed
- ✅ **Supply chain verified**

### 5. Version Lineage Tracking

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


### Build and Scan

1. **Start with standard images to see vulnerabilities:**
   ```bash
   git clone <repo-url>
   cd foundry-of-trust
   
   # Build with standard base images (shows vulnerabilities)
   docker buildx build \
     --builder cloud-demonstrationorg-default \
     --sbom=true \
     --provenance=true \
     -t demonstrationorg/foundry-of-trust:v1.0-NoDHI \
     .
   ```

2. **Scan for vulnerabilities locally:**
   ```bash
   # See vulnerabilities in standard images
   docker scout cves demonstrationorg/foundry-of-trust:v1.0-NoDHI
   ```

3. **Switch to golden base images:**
   ```bash
   # Update Dockerfile to use DHI golden base images
   # FROM demonstrationorg/dhi-temurin:21-jdk-alpine3.21-dev AS deps
   # FROM demonstrationorg/dhi-temurin:21_whale AS final
   
   # Build with golden base images - instant security fix
   docker buildx build \
     --builder cloud-demonstrationorg-default \
     --sbom=true \
     --provenance=true \
     -t demonstrationorg/foundry-of-trust:v1.0-DHI \
     --push \
     .
   ```

4. **Verify security improvement:**
   ```bash
   # Compare vulnerability scans
   docker scout cves demonstrationorg/foundry-of-trust:v1.0-NoDHI
   docker scout cves demonstrationorg/foundry-of-trust:v1.0-DHI
   
   # Detailed analysis of golden image
   docker scout policy demonstrationorg/foundry-of-trust:v1.0-DHI
   ```

5. **Check lineage:**
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

### Scene 1: The Problem - Standard Images Have Vulnerabilities
```bash
# Show current Dockerfile with standard images
cat Dockerfile

# Build with standard images
docker buildx build \
  --builder cloud-demonstrationorg-default \
  --sbom=true \
  --provenance=true \
  -t demonstrationorg/foundry-of-trust:v1.0-NoDHI \
  .

# Scan for vulnerabilities - show the problems
docker scout cves demonstrationorg/foundry-of-trust:v1.0-NoDHI
```

### Scene 2: The Solution - Golden Base Images
```bash
# Update Dockerfile to use golden base images
# Show the difference in base images

# Build with golden base images
docker buildx build \
  --builder cloud-demonstrationorg-default \
  --sbom=true \
  --provenance=true \
  -t demonstrationorg/foundry-of-trust:v1.0-DHI \
  --push \
  .
```

### Scene 3: Security Validation - Before vs After
```bash
# Compare vulnerability scans
echo "=== BEFORE: Standard Images ==="
docker scout cves demonstrationorg/foundry-of-trust:v1.0-NoDHI

echo "=== AFTER: Golden Base Images ==="
docker scout cves demonstrationorg/foundry-of-trust:v1.0-DHI

# Verify policy compliance
docker scout policy demonstrationorg/foundry-of-trust:v1.0-DHI
```

### Scene 4: Version Lineage - Ecosystem Benefits
```bash
# Show all microservices using golden base
docker scout lineage demonstrationorg/dhi-temurin:21_whale

# Demonstrate centralized security management
docker scout repo demonstrationorg
```

## 🎬 Key Demo Points

1. **"Problem-Solution" Narrative**: Start with vulnerable standard images, then show instant fix with golden bases
2. **Local Development Integration**: Docker Scout in VS Code catches issues before they reach CI/CD
3. **Immediate Impact**: Zero-touch security improvement by switching base images
4. **Supply Chain Transparency**: SBOM and provenance provide complete visibility
5. **Continuous Monitoring**: Docker Scout provides ongoing security oversight
6. **Ecosystem Benefits**: All microservices inherit security improvements automatically

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