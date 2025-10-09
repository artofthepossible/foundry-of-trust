#!/bin/bash

# Foundry of Trust - Golden Path Demo Script
# This script demonstrates the complete secure container build workflow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
REGISTRY="demonstrationorg"
IMAGE_NAME="foundry-of-trust"
VERSION="v1.0"
GOLDEN_BASE="demonstrationorg/dhi-temurin:21_whale"
BUILD_BASE="demonstrationorg/dhi-temurin:21-jdk-alpine3.21-dev"

echo -e "${BOLD}🐋 Foundry of Trust - Golden Path Demo${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Function to print section headers
print_section() {
    echo -e "\n${BOLD}${BLUE}$1${NC}"
    echo -e "${BLUE}$(printf '%.0s-' {1..50})${NC}"
}

# Function to run commands with explanation
run_command() {
    local explanation="$1"
    local command="$2"
    
    echo -e "\n${YELLOW}📝 $explanation${NC}"
    echo -e "${GREEN}$ $command${NC}"
    
    if [[ "$3" != "dry-run" ]]; then
        eval $command
    else
        echo -e "${BLUE}[DRY RUN - Command would be executed]${NC}"
    fi
}

# Check if we're in dry-run mode
DRY_RUN=""
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN="dry-run"
    echo -e "${YELLOW}🔍 Running in DRY RUN mode - no commands will be executed${NC}"
fi

print_section "1. 🏗️ Golden Base Image Strategy"
echo "Our secure build uses two golden base images:"
echo "• Build Stage: $BUILD_BASE (includes dev tools)"
echo "• Runtime Stage: $GOLDEN_BASE (minimal production)"
echo ""
echo "Benefits:"
echo "✅ Pre-hardened and vulnerability-scanned"
echo "✅ Consistent across all microservices"
echo "✅ Reduced attack surface"
echo "✅ Compliance-ready"

run_command "Show available golden base images" \
    "docker images ${REGISTRY}/dhi-temurin:*" $DRY_RUN

run_command "Display our multi-stage Dockerfile" \
    "cat Dockerfile" $DRY_RUN

print_section "2. 🚀 Instant Success Docker Build"
echo "Building with Docker Build Cloud for enhanced performance and security:"

run_command "Build with SBOM and provenance generation" \
    "docker buildx build --builder cloud-${REGISTRY}-default --sbom=true --provenance=true -t ${REGISTRY}/${IMAGE_NAME}:${VERSION} ." $DRY_RUN

print_section "3. 🔒 Security Scanning with Docker Scout"
echo "Validating image security posture:"

run_command "Quick vulnerability overview" \
    "docker scout quickview ${REGISTRY}/${IMAGE_NAME}:${VERSION}" $DRY_RUN

run_command "Comprehensive CVE analysis" \
    "docker scout cves ${REGISTRY}/${IMAGE_NAME}:${VERSION}" $DRY_RUN

run_command "Policy evaluation check" \
    "docker scout policy ${REGISTRY}/${IMAGE_NAME}:${VERSION}" $DRY_RUN

run_command "Compare against golden base image" \
    "docker scout compare --to ${GOLDEN_BASE} ${REGISTRY}/${IMAGE_NAME}:${VERSION}" $DRY_RUN

print_section "4. 📊 Version Lineage Tracking"
echo "Discovering all microservices built from our golden base:"

run_command "Show version lineage for golden base" \
    "docker scout lineage ${GOLDEN_BASE}" $DRY_RUN

run_command "List all repository images using golden base" \
    "docker scout repo ${REGISTRY} --filter \"base-image:${GOLDEN_BASE}\"" $DRY_RUN

print_section "5. 🧪 Application Testing"
echo "Verifying the application works correctly:"

run_command "Run the Spring Boot application" \
    "docker run -d -p 8080:8080 --name foundry-demo ${REGISTRY}/${IMAGE_NAME}:${VERSION}" $DRY_RUN

if [[ "$DRY_RUN" == "" ]]; then
    echo -e "\n${YELLOW}⏳ Waiting for application to start...${NC}"
    sleep 10
fi

run_command "Check application health" \
    "curl -f http://localhost:8080/actuator/health || echo 'Health check endpoint not ready yet'" $DRY_RUN

run_command "Stop and remove test container" \
    "docker stop foundry-demo && docker rm foundry-demo" $DRY_RUN

print_section "6. 📋 SBOM and Provenance Verification"
echo "Examining supply chain artifacts:"

run_command "Extract and display SBOM" \
    "docker buildx imagetools inspect ${REGISTRY}/${IMAGE_NAME}:${VERSION} --format '{{json .SBOM}}' | jq -r '.packages[] | select(.name) | .name' | head -10" $DRY_RUN

run_command "Verify provenance attestation" \
    "docker buildx imagetools inspect ${REGISTRY}/${IMAGE_NAME}:${VERSION} --format '{{json .Provenance}}' | jq -r '.predicate.builder.id'" $DRY_RUN

print_section "7. 🔄 CI/CD Integration Preview"
echo "Our GitHub Actions workflow provides:"
echo "• Automated builds with Docker Build Cloud"
echo "• Continuous security scanning"
echo "• SBOM and provenance generation"
echo "• Automated remediation workflows"
echo "• Version lineage tracking"

run_command "Show workflow file" \
    "ls -la .github/workflows/" $DRY_RUN

print_section "✅ Demo Complete!"
echo -e "${GREEN}🎉 Successfully demonstrated the Foundry of Trust golden path!${NC}"
echo ""
echo "Key achievements:"
echo "✅ Zero-touch security with golden base images"
echo "✅ Instant build success with no dependency issues"
echo "✅ Complete supply chain transparency (SBOM + Provenance)"
echo "✅ Continuous security monitoring with Docker Scout"
echo "✅ Version lineage tracking across microservices"
echo "✅ Automated CI/CD with security-first approach"
echo ""
echo -e "${BLUE}📚 Next steps:${NC}"
echo "• Review the generated SBOM and provenance data"
echo "• Explore Docker Scout dashboard for ongoing monitoring"
echo "• Set up the GitHub Actions workflow for your repository"
echo "• Extend the pattern to other microservices"
echo ""
echo -e "${YELLOW}💡 Pro tip: Run this demo with --dry-run to see all commands without executing them${NC}"