#!/bin/bash

# 📊 Image Comparison Demo - DHI vs Standard Base Images
# This script demonstrates the differences between standard and DHI hardened images
# both now available in the same repository with different tags.

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
        "COMPARE")
            echo -e "${PURPLE}[COMPARE]${NC} $message"
            ;;
        "SECURITY")
            echo -e "${BOLD}${RED}[SECURITY]${NC} $message"
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

print_header "📊 Repository Image Comparison"

print_status "INFO" "Comparing images in demonstrationorg/local-foundry-of-trust repository:"
echo ""

print_status "INFO" "🏷️ Image Tags Available:"
echo "   → demonstrationorg/local-foundry-of-trust:nodhi (Standard Eclipse Temurin)"
echo "   → demonstrationorg/local-foundry-of-trust:dhi (DHI Hardened Images)"
echo ""

print_header "🔍 Security Attestation Inspection"

print_status "INFO" "Inspecting Standard Image (nodhi)..."
echo "Command: docker buildx imagetools inspect demonstrationorg/local-foundry-of-trust:nodhi"
echo ""

print_status "INFO" "Inspecting DHI Hardened Image (dhi)..."
echo "Command: docker buildx imagetools inspect demonstrationorg/local-foundry-of-trust:dhi"
echo ""

print_header "🚀 Running the Images"

print_status "INFO" "To run the Standard image:"
echo "docker run -p 8080:8080 demonstrationorg/local-foundry-of-trust:nodhi"
echo ""

print_status "INFO" "To run the DHI Hardened image:"
echo "docker run -p 8080:8080 demonstrationorg/local-foundry-of-trust:dhi"
echo ""

print_header "🛡️ Security Comparison"

print_status "SECURITY" "Key Differences:"
echo ""
print_status "COMPARE" "Standard Image (:nodhi):"
echo "   ✓ Built with Eclipse Temurin base images"
echo "   ✓ Standard security posture"
echo "   ✓ SBOM and Provenance included"
echo "   ⚠️ May contain baseline vulnerabilities"
echo "   ⚠️ Requires manual security hardening"
echo ""

print_status "COMPARE" "DHI Hardened Image (:dhi):"
echo "   ✅ Built with DHI golden hardened base images"
echo "   ✅ Enhanced security posture from foundation"
echo "   ✅ SBOM and Provenance included"
echo "   ✅ Pre-hardened and security-validated"
echo "   ✅ Reduced attack surface"
echo "   ✅ Known good baseline established"
echo ""

print_header "📋 Docker Compose Options"

print_status "INFO" "Use Docker Compose with different image variants:"
echo ""
echo "# For DHI hardened deployment"
echo "docker compose -f compose-dhi.yaml up"
echo ""
echo "# For standard deployment"
echo "docker compose up"
echo ""

print_header "🔬 Security Analysis Commands"

print_status "INFO" "Recommended security analysis:"
echo ""
echo "# Pull both images for comparison"
echo "docker pull demonstrationorg/local-foundry-of-trust:nodhi"
echo "docker pull demonstrationorg/local-foundry-of-trust:dhi"
echo ""
echo "# Scan for vulnerabilities (example with Docker Scout)"
echo "docker scout cves demonstrationorg/local-foundry-of-trust:nodhi"
echo "docker scout cves demonstrationorg/local-foundry-of-trust:dhi"
echo ""
echo "# Compare SBOM content"
echo "docker scout sbom demonstrationorg/local-foundry-of-trust:nodhi"
echo "docker scout sbom demonstrationorg/local-foundry-of-trust:dhi"
echo ""

print_header "🎯 Key Takeaways"

print_status "SUCCESS" "Repository Structure:"
echo "   📦 Single repository: demonstrationorg/local-foundry-of-trust"
echo "   🏷️ Two security variants: :nodhi and :dhi tags"
echo "   🔒 Both include SBOM and Provenance attestations"
echo "   ☁️ Both built with Docker Build Cloud"
echo ""

print_status "SECURITY" "Security Recommendations:"
echo "   1. 🛡️ Use :dhi tag for production deployments"
echo "   2. 🔍 Compare vulnerability scans between tags"
echo "   3. 📊 Establish security metrics and monitoring"
echo "   4. ⬆️ Keep dependencies updated in both variants"
echo "   5. 🧪 Test both variants in your CI/CD pipeline"
echo ""

print_status "INFO" "This demonstrates 'shift-left' security with multiple security postures available!"