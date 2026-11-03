#!/bin/bash

# 🔍 DHI Base Image Monitoring Demo
# This script demonstrates the DHI digestabot workflow and how to manually trigger
# base image monitoring for security updates and supply chain integrity.

set -e

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
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
        "SECURITY")
            echo -e "${BOLD}${RED}[SECURITY]${NC} $message"
            ;;
        "MONITOR")
            echo -e "${BOLD}${PURPLE}[MONITOR]${NC} $message"
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

# Function to print security emphasis
print_security_emphasis() {
    echo ""
    echo -e "${BOLD}${RED}🔒 SECURITY EMPHASIS:${NC} $1"
    echo ""
}

# Script introduction
print_header "🔍 DHI Base Image Monitoring Demo"

print_status "INFO" "This demo shows how to monitor DHI base images for security updates"
print_status "SECURITY" "• Automated supply chain integrity monitoring"
print_status "SECURITY" "• Proactive vulnerability management"
print_status "SECURITY" "• Digest pinning for reproducible builds"
print_status "SECURITY" "• Continuous security posture improvement"
echo ""

print_security_emphasis "Keep your DHI golden base images current with automated monitoring!"

# Current DHI Images Section
print_header "🐳 Current DHI Base Images Being Monitored"

print_status "MONITOR" "📋 Build Stage Image:"
echo "   Image: artofthepossible/dhi-temurin:21-jdk-alpine3.21-dev"
echo "   Digest: sha256:d32f08b3aa18668323a82e3ffb297cb1030dc1ed0d85b9786204538ab6e1a32a"
echo "   Purpose: Development and build environment with JDK"
echo "   Security: Pre-hardened Alpine Linux with security patches"
echo ""

print_status "MONITOR" "🚀 Runtime Stage Image:"
echo "   Image: artofthepossible/dhi-temurin:21-alpine3.22_whale1"
echo "   Digest: sha256:0189f624ac7166b288a2b127d30cb511b349d6cec5ecae5463051392d2a3a821"
echo "   Purpose: Minimal runtime environment for production"
echo "   Security: Hardened JRE with reduced attack surface"
echo ""

# Digestabot Workflow Explanation
print_header "🤖 DHI Digestabot Workflow Overview"

print_status "INFO" "The digestabot workflow (.github/workflows/dhi-digestabot.yaml):"
echo ""
print_status "MONITOR" "⏰ Schedule:"
echo "   → Runs every Sunday at midnight UTC (cron: '0 0 * * 0')"
echo "   → Can be triggered manually via workflow_dispatch"
echo "   → Monitors 'Dockerfile dhi' for base image references"
echo ""

print_status "MONITOR" "🔍 Detection Process:"
echo "   → Scans current digest references in Dockerfile"
echo "   → Checks Docker registry for newer image versions"
echo "   → Compares current vs latest available digests"
echo "   → Identifies when security updates are available"
echo ""

print_status "MONITOR" "🔄 Update Process:"
echo "   → Creates new branch: 'dhi-digestabot'"
echo "   → Updates Dockerfile with latest secure digests"
echo "   → Generates pull request with security improvements"
echo "   → Applies labels: 'dependencies,security,dhi-images'"
echo ""

# Prerequisites check
print_header "🔧 Prerequisites for Manual Trigger"

print_status "INFO" "Checking prerequisites for manual workflow trigger..."

# Check GitHub CLI
if ! command -v gh >/dev/null 2>&1; then
    print_status "WARNING" "GitHub CLI (gh) not found"
    print_status "INFO" "Install with: brew install gh (macOS) or visit https://cli.github.com/"
    GITHUB_CLI_AVAILABLE=false
else
    print_status "SUCCESS" "GitHub CLI is available"
    GITHUB_CLI_AVAILABLE=true
fi

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print_status "ERROR" "Not in a git repository"
    exit 1
fi
print_status "SUCCESS" "Git repository detected"

# Check remote repository
REPO_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")
if [[ -z "$REPO_URL" ]]; then
    print_status "WARNING" "No remote origin configured"
    REPO_AVAILABLE=false
else
    print_status "SUCCESS" "Remote repository: $REPO_URL"
    REPO_AVAILABLE=true
fi

# Check Docker Hub authentication
print_status "INFO" "Checking Docker Hub authentication..."
if docker manifest inspect artofthepossible/dhi-temurin:21-jdk-alpine3.21-dev >/dev/null 2>&1; then
    print_status "SUCCESS" "Docker Hub authentication working"
    DOCKER_AUTH_AVAILABLE=true
else
    print_status "WARNING" "Docker Hub authentication required"
    print_status "INFO" "The DHI images require authentication to artofthepossible registry"
    print_status "INFO" "Configure GitHub secrets: DOCKER_HUB_USERNAME and DOCKER_HUB_TOKEN"
    DOCKER_AUTH_AVAILABLE=false
fi

echo ""

# Manual Trigger Section
print_header "🚀 Manual Workflow Trigger Demo"

print_security_emphasis "DEMONSTRATE: How to manually trigger DHI base image monitoring!"

print_status "INFO" "Manual trigger options:"
echo ""

# GitHub CLI method
if [[ "$GITHUB_CLI_AVAILABLE" == "true" && "$REPO_AVAILABLE" == "true" ]]; then
    print_status "COMMAND" "Method 1: GitHub CLI (Recommended)"
    echo "gh workflow run dhi-digestabot.yaml"
    echo ""
    
    print_status "INFO" "To run the workflow now:"
    echo ""
    read -p "Do you want to trigger the DHI digestabot workflow now? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "INFO" "Triggering DHI digestabot workflow..."
        if gh workflow run dhi-digestabot.yaml; then
            print_status "SUCCESS" "Workflow triggered successfully!"
            echo ""
            print_status "INFO" "Monitor the workflow:"
            echo "gh run list --workflow=dhi-digestabot.yaml"
            echo ""
            print_status "INFO" "View workflow details:"
            echo "gh run view --workflow=dhi-digestabot.yaml"
        else
            print_status "ERROR" "Failed to trigger workflow"
        fi
    else
        print_status "INFO" "Workflow trigger skipped"
    fi
else
    print_status "INFO" "GitHub CLI not available or repository not configured"
fi

echo ""

# GitHub UI method
print_status "COMMAND" "Method 2: GitHub Web Interface"
echo "1. Go to: https://github.com/artofthepossible/foundry-of-trust/actions"
echo "2. Click on 'DHI Base Image Digestabot' workflow"
echo "3. Click 'Run workflow' button"
echo "4. Select branch (usually 'main')"
echo "5. Click 'Run workflow' to trigger"
echo ""

# Monitoring Section
print_header "📊 Monitoring and Results"

print_status "INFO" "After triggering the workflow, monitor for:"
echo ""

print_status "MONITOR" "🔍 Workflow Execution:"
echo "   → Check Actions tab for workflow status"
echo "   → Review logs for security scan results"
echo "   → Monitor for pull request creation"
echo "   → Verify digest updates in summary"
echo ""

print_status "MONITOR" "📝 Pull Request Creation:"
echo "   → PR title: 'Update DHI base image digests'"
echo "   → Branch: 'dhi-digestabot'"
echo "   → Labels: 'dependencies,security,dhi-images'"
echo "   → Description includes security benefits"
echo ""

print_status "MONITOR" "🛡️ Security Verification:"
echo "   → Compare old vs new image digests"
echo "   → Review security improvements in PR description"
echo "   → Validate that images are still from artofthepossible"
echo "   → Confirm DHI golden image provenance"
echo ""

# Expected Results Section
print_header "🎯 Expected Results and Actions"

print_status "SUCCESS" "When DHI base images have updates:"
echo ""
print_status "MONITOR" "✅ Automated PR Created:"
echo "   → New digests for artofthepossible/dhi-temurin images"
echo "   → Security patches and vulnerability fixes included"
echo "   → Reproducible builds maintained through digest pinning"
echo "   → Supply chain integrity verified"
echo ""

print_status "SUCCESS" "When DHI base images are current:"
echo ""
print_status "MONITOR" "ℹ️ No Changes Required:"
echo "   → Workflow completes without creating PR"
echo "   → Current digests are already the latest"
echo "   → Security posture remains optimal"
echo "   → No action needed from developers"
echo ""

# Security Benefits Summary
print_header "🛡️ Security Benefits Demonstrated"

print_status "SECURITY" "Supply Chain Security:"
echo "   ✅ Cryptographic digest verification"
echo "   ✅ Immutable image references"
echo "   ✅ Protection against image tampering"
echo "   ✅ Audit trail of all base image changes"
echo ""

print_status "SECURITY" "Proactive Vulnerability Management:"
echo "   ✅ Automatic detection of security updates"
echo "   ✅ Timely application of DHI security patches"
echo "   ✅ Reduced window of vulnerability exposure"
echo "   ✅ Continuous security posture improvement"
echo ""

print_status "SECURITY" "Developer Experience:"
echo "   ✅ Zero-maintenance security updates"
echo "   ✅ Clear communication through PR descriptions"
echo "   ✅ Automated workflow with manual review gates"
echo "   ✅ Consistent security standards across team"
echo ""

# Advanced Monitoring Section
print_header "🔬 Advanced Monitoring Commands"

print_status "INFO" "Additional monitoring and verification commands:"
echo ""

print_status "COMMAND" "Check current image digests:"
echo "docker inspect docker.io/artofthepossible/dhi-temurin:21-jdk-alpine3.21-dev --format='{{index .RepoDigests 0}}'"
echo "docker inspect docker.io/artofthepossible/dhi-temurin:21-alpine3.22_whale1 --format='{{index .RepoDigests 0}}'"
echo ""

print_status "COMMAND" "Monitor workflow runs:"
echo "gh run list --workflow=dhi-digestabot.yaml --limit=5"
echo ""

print_status "COMMAND" "View latest workflow details:"
echo "gh run view \$(gh run list --workflow=dhi-digestabot.yaml --json databaseId -q '.[0].databaseId')"
echo ""

print_status "COMMAND" "Check for open digestabot PRs:"
echo "gh pr list --label=dhi-images --state=open"
echo ""

# Summary and Next Steps
print_header "🎉 DHI Base Image Monitoring Demo Summary"

print_status "SUCCESS" "DHI base image monitoring demo completed!"
echo ""
print_status "INFO" "What we demonstrated:"
echo "   🔍 Automated DHI base image monitoring workflow"
echo "   🤖 Manual trigger capabilities for testing"
echo "   🛡️ Supply chain security through digest pinning"
echo "   📊 Monitoring and verification procedures"
echo "   🔄 Continuous security update process"
echo ""

print_status "INFO" "Security posture improvements:"
echo "   🔒 Proactive vulnerability management"
echo "   🛡️ Supply chain integrity verification"
echo "   📋 Complete audit trail of security updates"
echo "   ⬅️ Shift-left security automation"
echo ""

print_status "INFO" "Next steps:"
echo "   → Monitor workflow runs weekly"
echo "   → Review and merge digestabot PRs promptly"
echo "   → Test updated images in development"
echo "   → Maintain DHI golden image benefits"
echo ""

print_security_emphasis "REMEMBER: Automated security monitoring is key to maintaining strong security posture!"

print_status "SUCCESS" "🎯 Key Takeaway: Digestabot ensures your DHI foundation stays secure automatically!"
echo ""

# Additional Resources
print_header "📚 Additional Resources"

print_status "INFO" "Learn more about:"
echo "   → DHI Golden Images: Enhanced security through pre-hardened containers"
echo "   → Digest Pinning: Supply chain security best practices"
echo "   → Container Security: Defense in depth strategies"
echo ""

