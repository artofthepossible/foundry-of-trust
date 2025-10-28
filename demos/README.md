# Foundry of Trust - Demo Scripts

This directory contains demonstration scripts showcasing various aspects of supply chain security, vulnerability management, and container security practices.

## Demo Flow Overview

### 🔄 Setup & Reset Demos
- **`00-reset-demo.sh`** - Reset POM to original state (introduces CVEs for demonstration)
- **`00-restore-fixed.sh`** - Restore POM to security-fixed state (removes CVEs)

### 🏗️ Build & Fix Demos  
- **`01-build-local.sh`** - Build application with standard base image
- **`01-fix-app.sh`** - Apply security fixes to resolve Maven dependency vulnerabilities
- **`02-build-local-dhi.sh`** - Build application with DHI (Demonstration Hardened Image)

### 🧪 Testing & Monitoring Demos
- **`03-testcontainers.sh`** - Integration testing with Testcontainers
- **`04-monitor-base-image-updates.sh`** - DHI base image monitoring and update checking

### 🔍 Comparison & Analysis
- **`00-compare-images.sh`** - Compare standard vs DHI images

## Recommended Demo Sequence

### Complete Vulnerability Management Workflow

1. **Reset to Vulnerable State**
   ```bash
   ./demos/00-reset-demo.sh
   ```
   - Resets POM to original state with known CVEs
   - Creates backup of current fixed state
   - Demonstrates "before" security posture

2. **Identify Vulnerabilities**
   ```bash
   mvn versions:display-dependency-updates
   # Look for outdated Tomcat, Logback, Spring components
   ```

3. **Apply Security Fixes**
   ```bash
   ./demos/01-fix-app.sh
   ```
   - Applies Maven dependency security patches
   - Updates vulnerable components to latest secure versions
   - Validates fixes with compilation and testing

4. **Build with Standard Image**
   ```bash
   ./demos/01-build-local.sh
   ```
   - Build container with standard base image
   - Tag with standard naming convention

5. **Build with DHI (Hardened Image)**
   ```bash
   ./demos/02-build-local-dhi.sh  
   ```
   - Build container with Demonstration Hardened Image
   - Shows supply chain security with pinned digests

6. **Compare Security Postures**
   ```bash
   ./demos/00-compare-images.sh
   ```
   - Compare standard vs DHI images
   - Analyze security differences

7. **Integration Testing**
   ```bash
   ./demos/03-testcontainers.sh
   ```
   - Validate functionality with Testcontainers
   - Test container integration and external dependencies

8. **Monitor for Updates**
   ```bash
   ./demos/04-monitor-base-image-updates.sh
   ```
   - Check for DHI base image updates
   - Demonstrate ongoing security monitoring

9. **Restore Fixed State (if needed)**
   ```bash
   ./demos/00-restore-fixed.sh
   ```
   - Restore to security-fixed state after demos
   - Ensures production-ready configuration

## Key Learning Objectives

### 🛡️ Vulnerability Management
- **CVE Discovery**: How to identify vulnerable dependencies
- **Patch Strategy**: Safe incremental vs major version upgrades  
- **Validation**: Ensuring fixes don't break functionality
- **Automation**: Scripted approaches to security maintenance

### 📦 Supply Chain Security
- **Base Image Security**: DHI vs standard images
- **Digest Pinning**: Immutable image references
- **SBOM Generation**: Software bill of materials creation
- **Provenance**: Build attestation and verification

### 🧪 Testing & Validation
- **Integration Testing**: Container-based testing with Testcontainers
- **Security Testing**: Vulnerability scanning and validation
- **Functional Testing**: Ensuring security doesn't break features
- **Automation**: CI/CD integration patterns

### 📊 Monitoring & Maintenance
- **Update Monitoring**: Automated base image update detection
- **Security Alerting**: CVE notification and response
- **Policy Management**: Security policy as code
- **Compliance**: Security posture reporting

## File Structure

```
demos/
├── README.md                          # This file - demo documentation
├── 00-reset-demo.sh                   # Reset POM to vulnerable state
├── 00-restore-fixed.sh                # Restore POM to fixed state  
├── 00-compare-images.sh               # Compare standard vs DHI images
├── 01-build-local.sh                  # Build with standard image
├── 01-fix-app.sh                      # Apply security fixes
├── 02-build-local-dhi.sh              # Build with DHI
├── 03-testcontainers.sh               # Integration testing
├── 04-monitor-base-image-updates.sh   # DHI monitoring
├── pom-original.xml                   # Backup of original (vulnerable) POM
└── README-dhi-monitoring.md           # DHI monitoring documentation
```

## Prerequisites

- Docker Desktop or compatible Docker runtime
- Maven 3.6+ 
- Java 21+
- Access to demonstrationorg/dhi-temurin Docker registry (for DHI demos)
- Internet connectivity for dependency downloads

## Security Notes

⚠️ **Important**: The reset demo intentionally introduces known CVEs for educational purposes. Always restore to the fixed state before production use.

🔒 **Best Practices Demonstrated**:
- Incremental security patching
- Supply chain security with DHI
- Automated vulnerability scanning
- Container security hardening
- Continuous security monitoring

## Support

For questions or issues with the demos, please refer to:
- [Main README](../README.md)
- [DHI Monitoring Guide](README-dhi-monitoring.md)
- [GitHub Issues](https://github.com/artofthepossible/foundry-of-trust/issues)
