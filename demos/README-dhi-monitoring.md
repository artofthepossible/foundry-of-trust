# 🔍 DHI Base Image Monitoring Demo Guide

This guide demonstrates how to test and use the DHI (Docker Hardened Images) digestabot workflow for automated supply chain security monitoring.

## 🎯 Overview

The DHI digestabot workflow automatically monitors our Docker Hardened Images base images for security updates and creates pull requests when newer, more secure versions are available. This ensures our application maintains the strongest security posture through automated supply chain integrity monitoring.

## 🛡️ Security Benefits

### Supply Chain Security
- **Digest Pinning**: Uses cryptographic SHA256 digests to ensure immutable image references
- **Tampering Protection**: Prevents supply chain attacks through verified image integrity
- **Audit Trail**: Complete tracking of all base image security updates
- **Reproducible Builds**: Consistent builds regardless of when they're executed

### Proactive Vulnerability Management
- **Automated Detection**: Weekly scans for security updates and patches
- **Timely Updates**: Immediate notification when DHI security improvements are available
- **Zero Maintenance**: Automatically opens PRs for security updates
- **Continuous Monitoring**: Never miss critical security patches

## 🐳 Monitored DHI Base Images

Our workflow monitors these specific DHI golden base images:

### Build Stage Image
```dockerfile
demonstrationorg/dhi-temurin:21-jdk-alpine3.21-dev@sha256:d32f08b3aa18668323a82e3ffb297cb1030dc1ed0d85b9786204538ab6e1a32a
```
- **Purpose**: Development and build environment with JDK 21
- **Base**: Pre-hardened Alpine Linux 3.21 with security patches
- **Security**: Reduced attack surface with unnecessary packages removed
- **Features**: Build tools, Maven cache optimization, security scanning

### Runtime Stage Image
```dockerfile
demonstrationorg/dhi-temurin:21_whale1@sha256:0189f624ac7166b288a2b127d30cb511b349d6cec5ecae5463051392d2a3a821
```
- **Purpose**: Minimal runtime environment for production deployment
- **Base**: Hardened JRE 21 with custom whale theme
- **Security**: Ultra-minimal attack surface, production-optimized
- **Features**: Runtime-only components, memory optimization, security hardening

## 🤖 Digestabot Workflow Details

### Workflow Configuration
- **File**: `.github/workflows/dhi-digestabot.yaml`
- **Trigger**: 
  - Weekly schedule (Sundays at midnight UTC)
  - Manual dispatch for testing
- **Target**: `Dockerfile dhi` (our DHI-based Dockerfile)
- **Tool**: Chainguard digestabot for enterprise-grade security monitoring

### Automated Process
1. **Scan**: Analyzes current digest references in `Dockerfile dhi`
2. **Check**: Queries Docker registry for newer image versions
3. **Compare**: Identifies when security updates are available
4. **Update**: Creates branch with latest secure digests
5. **PR**: Opens pull request with security improvement details
6. **Label**: Applies `dependencies`, `security`, `dhi-images` labels

## 🚀 Demo Script Usage

### Quick Start
```bash
./demos/04-monitor-base-image-updates.sh
```

### What the Demo Shows
The demo script demonstrates:
- Current DHI base images being monitored
- How to manually trigger the digestabot workflow
- Expected results and security verification process
- Advanced monitoring commands for ongoing maintenance

### Prerequisites
- **GitHub CLI**: Install with `brew install gh` (macOS)
- **Git Repository**: Must be in the project repository
- **GitHub Access**: Authenticated GitHub CLI session

### Manual Workflow Trigger

#### Method 1: GitHub CLI (Recommended)
```bash
# Trigger the workflow
gh workflow run dhi-digestabot.yaml

# Monitor workflow runs
gh run list --workflow=dhi-digestabot.yaml

# View latest run details
gh run view --workflow=dhi-digestabot.yaml
```

#### Method 2: GitHub Web Interface
1. Navigate to: `https://github.com/YOUR_ORG/foundry-of-trust/actions`
2. Click on "DHI Base Image Digestabot" workflow
3. Click "Run workflow" button
4. Select branch (usually `main`)
5. Click "Run workflow" to trigger

## 📊 Monitoring and Verification

### Workflow Status Monitoring
```bash
# Check recent workflow runs
gh run list --workflow=dhi-digestabot.yaml --limit=5

# View detailed run information
gh run view $(gh run list --workflow=dhi-digestabot.yaml --json databaseId -q '.[0].databaseId')

# Check for open digestabot PRs
gh pr list --label=dhi-images --state=open
```

### Image Digest Verification
```bash
# Check current build image digest
docker inspect demonstrationorg/dhi-temurin:21-jdk-alpine3.21-dev \
  --format='{{index .RepoDigests 0}}'

# Check current runtime image digest
docker inspect demonstrationorg/dhi-temurin:21_whale1 \
  --format='{{index .RepoDigests 0}}'
```

## 🎯 Expected Results

### When Updates Are Available
The workflow will:
- ✅ Create new branch: `dhi-digestabot`
- ✅ Update `Dockerfile dhi` with latest secure digests
- ✅ Open pull request with title: "Update DHI base image digests"
- ✅ Apply labels: `dependencies`, `security`, `dhi-images`
- ✅ Include security improvement summary in PR description

### When Images Are Current
The workflow will:
- ℹ️ Complete successfully without creating a PR
- ℹ️ Log that current digests are already the latest
- ℹ️ Maintain current security posture
- ℹ️ Schedule next automatic check

## 🔬 Testing Scenarios

### Scenario 1: Manual Trigger Test
**Purpose**: Verify workflow can be triggered manually
**Steps**:
1. Run `./demos/04-monitor-base-image-updates.sh`
2. Choose to trigger workflow when prompted
3. Monitor workflow execution
4. Verify completion status

**Expected**: Workflow executes successfully, checks for updates

### Scenario 2: Forced Update Test
**Purpose**: Test PR creation process
**Steps**:
1. Manually modify digests in `Dockerfile dhi` to older versions
2. Commit changes to test branch
3. Trigger digestabot workflow
4. Verify PR creation with correct updates

**Expected**: PR created with updated digests and security labels

### Scenario 3: Weekly Schedule Test
**Purpose**: Verify automatic scheduling works
**Steps**:
1. Wait for scheduled run (Sundays at midnight UTC)
2. Check Actions tab for automatic execution
3. Verify workflow runs without manual intervention

**Expected**: Automatic execution every Sunday

## 🛠️ Troubleshooting

### Common Issues

#### Workflow Not Triggering
**Symptoms**: Manual trigger fails or doesn't start
**Solutions**:
- Verify GitHub CLI is authenticated: `gh auth status`
- Check repository permissions for Actions
- Ensure workflow file syntax is valid

#### No PR Created When Expected
**Symptoms**: Workflow runs but doesn't create PR
**Causes**:
- Images are already up to date
- No newer digests available in registry
- Branch `dhi-digestabot` already exists

**Solutions**:
- Check workflow logs for update detection
- Verify image availability in registry
- Delete existing `dhi-digestabot` branch if needed

#### Digest Verification Failures
**Symptoms**: Cannot verify current image digests
**Solutions**:
- Pull latest images: `docker pull demonstrationorg/dhi-temurin:21-jdk-alpine3.21-dev`
- Check registry availability
- Verify image names and tags are correct

### Debug Commands

```bash
# Check workflow file syntax
gh workflow list | grep -i digestabot

# View workflow file
cat .github/workflows/dhi-digestabot.yaml

# Check repository Actions settings
gh api repos/:owner/:repo/actions/permissions

# List all branches (check for existing dhi-digestabot)
git branch -a | grep digestabot
```

## 📚 Security Best Practices

### Digest Pinning Strategy
- **Always** use SHA256 digests for base images
- **Never** use mutable tags like `latest` in production
- **Regularly** update digests through automated workflows
- **Verify** digest integrity before deployment

### PR Review Process
1. **Security Review**: Verify new digests are from trusted sources
2. **Change Validation**: Confirm only digest changes, no other modifications
3. **Testing**: Run builds with updated images before merging
4. **Documentation**: Update any relevant security documentation

### Monitoring Cadence
- **Weekly**: Automatic digestabot checks (configured)
- **Daily**: Manual monitoring of open security PRs
- **Monthly**: Review overall security posture and workflow effectiveness
- **Quarterly**: Audit DHI base image strategy and update policies

## 🔗 Related Resources

### Project Scripts
- [`01-build-local.sh`](./01-build-local.sh) - Standard Docker builds demo
- [`02-build-local-dhi.sh`](./02-build-local-dhi.sh) - DHI builds demo
- [`03-testcontainers.sh`](./03-testcontainers.sh) - Integration testing demo
- [`00-compare-images.sh`](./00-compare-images.sh) - Security comparison demo

### Documentation
- [Chainguard Digestabot](https://github.com/chainguard-dev/digestabot) - Official digestabot documentation
- [Docker Content Trust](https://docs.docker.com/engine/security/trust/) - Docker image signing and verification
- [Supply Chain Security](https://cloud.google.com/software-supply-chain-security) - Best practices for secure software supply chains

### Security Tools
- [Docker Scout](https://docs.docker.com/scout/) - Vulnerability scanning and analysis
- [Cosign](https://sigstore.dev/) - Container image signing and verification
- [SLSA](https://slsa.dev/) - Supply chain security framework

## 🎉 Success Metrics

After running this demo, you should understand:
- ✅ How DHI digestabot automates supply chain security
- ✅ The process for manually triggering security monitoring
- ✅ How to monitor and verify workflow results
- ✅ Best practices for maintaining secure base images
- ✅ The security benefits of digest pinning and automated updates

## 🚨 Security Reminders

### Critical Security Points
- **Digest Pinning**: The foundation of supply chain security
- **Regular Updates**: Security is only as strong as your latest patches
- **Automated Monitoring**: Human-only processes don't scale for security
- **Defense in Depth**: Multiple layers of security from build to runtime

### Key Takeaways
1. **Automation**: DHI digestabot reduces manual security maintenance to zero
2. **Proactive**: Identifies security updates before vulnerabilities are exploited
3. **Transparent**: Clear audit trail of all base image security changes
4. **Scalable**: Works across all projects using DHI golden images

---

**Remember**: Consistent security practices start with secure foundations. DHI base images + automated monitoring = strong security posture! 🛡️