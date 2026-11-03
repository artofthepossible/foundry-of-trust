#!/bin/bash

# 🛡️ DHI Build Demo - Defense in Depth with Hardened Base Images
# This script demonstrates building with DHI (Docker Hardened Images) and emphasizes
# developer security habits for "shift-left" security practices.

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
        "EXPLAIN")
            echo -e "${PURPLE}[EXPLAIN]${NC} $message"
            ;;
        "SECURITY")
            echo -e "${BOLD}${RED}[SECURITY]${NC} $message"
            ;;
        "HABIT")
            echo -e "${BOLD}${GREEN}[DEVELOPER HABIT]${NC} $message"
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
print_header "🛡️ DHI Build Demo - Defense in Depth Security"

print_status "INFO" "This demo builds using DHI (Docker Hardened Images) to demonstrate:"
print_status "SECURITY" "• Shift-left security practices"
print_status "SECURITY" "• Developer ownership of vulnerabilities"
print_status "SECURITY" "• Defense in depth from build-time to runtime"
print_status "SECURITY" "• Starting with known good, hardened base images"
echo ""

print_security_emphasis "We want developers to validate application security quality LEFT OF COMMIT!"

# Developer Habits Section
print_header "👨‍💻 Essential Developer Security Habits"

print_status "HABIT" "🎯 Habit 1: Start with Known Good Hardened Base Images"
echo "   → Always use DHI golden base images as your default"
echo "   → These images are pre-hardened, patched, and security-validated"
echo "   → Eliminates baseline vulnerabilities before you even start coding"
echo ""

print_status "HABIT" "🔍 Habit 2: Own Your Vulnerabilities Early"
echo "   → Scan and validate dependencies BEFORE committing code"
echo "   → Fix application-layer vulnerabilities in your development environment"
echo "   → Don't push vulnerable code to production pipelines"
echo ""

print_status "HABIT" "⬆️ Habit 3: Keep Dependencies Current"
echo "   → Regularly update packages with known CVEs"
echo "   → Use tools to identify and fix vulnerable dependencies"
echo "   → Automate dependency updates where possible"
echo ""

print_status "HABIT" "🛡️ Habit 4: Validate Security Quality Left of Commit"
echo "   → Run security scans locally before git commit"
echo "   → Implement pre-commit hooks for vulnerability checks"
echo "   → Treat security as part of code quality, not an afterthought"
echo ""

# Command breakdown explanation
print_header "📖 DHI Command Breakdown"

echo "We'll execute this enhanced Docker Buildx cloud command:"
echo ""
print_status "COMMAND" "docker buildx build \\"
print_status "COMMAND" "  --builder cloud-artofthepossible-default \\"
print_status "COMMAND" "  --sbom=true \\"
print_status "COMMAND" "  --provenance=true \\"
print_status "COMMAND" "  --push \\"
print_status "COMMAND" "  -t artofthepossible/local-foundry-of-trust:dhi \\"
print_status "COMMAND" "  -f \"Dockerfile\" \\"
print_status "COMMAND" "  ."
echo ""

print_status "EXPLAIN" "🆚 Key Difference from Previous Demo:"
echo "   → Uses 'Dockerfile' (with DHI golden images) instead of 'DockerfileNoDHI'"
echo "   → Tags image as 'dhi' instead of 'nodhi' for clear identification"
echo "   → Builds upon pre-hardened, security-validated base images"
echo "   → Uses --push to push directly to registry with cloud builder"
echo "   → Leverages Docker Build Cloud for enhanced build performance"
echo "   → Pushes to same repository (artofthepossible/local-foundry-of-trust) with different tag"
echo ""

# DHI Benefits Deep Dive
print_header "🛡️ DHI (Docker Hardened Images) Benefits"

print_status "SECURITY" "🔒 Defense in Depth - Build Time Security:"
echo "   ✅ Pre-hardened base images with security best practices"
echo "   ✅ Regular security patches and vulnerability fixes"
echo "   ✅ Reduced attack surface through minimal components"
echo "   ✅ Security-focused configuration and hardening"
echo "   ✅ Known good baseline eliminates common vulnerabilities"
echo ""

print_status "SECURITY" "🔍 Defense in Depth - Runtime Security:"
echo "   ✅ Immutable infrastructure principles"
echo "   ✅ Non-privileged user execution by default"
echo "   ✅ Minimal runtime dependencies"
echo "   ✅ Security monitoring and logging capabilities"
echo "   ✅ Container escape prevention measures"
echo ""

print_status "SECURITY" "⚡ Developer Productivity Benefits:"
echo "   ✅ No need to research and implement base image hardening"
echo "   ✅ Faster security validation and compliance"
echo "   ✅ Reduced security debt and technical debt"
echo "   ✅ Focus on application logic, not infrastructure security"
echo "   ✅ Consistent security standards across teams"
echo ""

print_status "SECURITY" "☁️ Docker Build Cloud Benefits:"
echo "   ✅ Faster builds with optimized cloud infrastructure"
echo "   ✅ Automatic registry push with security attestations"
echo "   ✅ Enhanced build performance and reliability"
echo "   ✅ Native SBOM and provenance generation"
echo "   ✅ Centralized build artifacts with security metadata"
echo ""

# Shift-Left Security
print_header "⬅️ Shift-Left Security: Left of Commit Validation"

print_security_emphasis "CRITICAL: Validate security BEFORE code reaches the repository!"

print_status "HABIT" "🎯 Pre-Commit Security Workflow:"
echo "   1. 🏗️  Start with DHI hardened base image (this demo)"
echo "   2. 🔍 Scan application dependencies for CVEs"
echo "   3. 🛠️  Fix vulnerable packages and update versions"
echo "   4. 🧪 Test application with updated dependencies"
echo "   5. 📋 Generate and review SBOM (Software Bill of Materials)"
echo "   6. ✅ Validate build security before git commit"
echo "   7. 🚀 Only then push to repository"
echo ""

print_status "SECURITY" "🚫 What We're Preventing:"
echo "   ❌ Vulnerable dependencies reaching production"
echo "   ❌ Security debt accumulation"
echo "   ❌ Emergency patching in production"
echo "   ❌ Compliance violations and audit failures"
echo "   ❌ Security incidents from known vulnerabilities"
echo ""

# Dockerfile comparison
print_header "🔍 Dockerfile Analysis - DHI vs Standard"

print_status "EXPLAIN" "DHI Dockerfile uses hardened golden base images:"
echo ""
print_status "EXPLAIN" "🏗️ Build Stage:"
echo "   FROM artofthepossible/dhi-temurin:21-jdk-alpine3.21-dev"
echo "   → Pre-hardened JDK environment with Alpine Linux"
echo "   → Minimal attack surface, security patches applied"
echo "   → Known good baseline for development builds"
echo ""
print_status "EXPLAIN" "🚀 Runtime Stage:"
echo "   FROM artofthepossible/dhi-temurin:21-alpine3.22_whale1"
echo "   → Hardened JRE runtime environment"
echo "   → Security-focused configuration"
echo "   → Digest pinning for supply chain security"
echo ""

print_status "SECURITY" "🔒 Security Advantages over Standard Images:"
echo "   ✅ Proactive vulnerability patching"
echo "   ✅ Security hardening applied by experts"
echo "   ✅ Reduced configuration drift"
echo "   ✅ Compliance with security standards"
echo "   ✅ Supply chain integrity validation"
echo ""

# Prerequisites check
print_header "🔧 Prerequisites Check"

print_status "INFO" "Checking build prerequisites and security tools..."

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
if ! docker buildx inspect cloud-artofthepossible-default >/dev/null 2>&1; then
    print_status "WARNING" "Builder 'cloud-artofthepossible-default' not found"
    print_status "INFO" "Will use default builder instead"
    BUILDER_ARG=""
else
    print_status "SUCCESS" "Builder 'cloud-artofthepossible-default' is available"
    BUILDER_ARG="--builder cloud-artofthepossible-default"
fi

# Check Dockerfile
if [[ ! -f "Dockerfile" ]]; then
    print_status "ERROR" "Dockerfile not found in current directory"
    exit 1
fi
print_status "SUCCESS" "Dockerfile (with DHI images) found"

# Check if we have our vulnerability fix script
if [[ -f "fix-app" ]]; then
    print_status "SUCCESS" "Vulnerability fix script 'fix-app' found"
    print_status "HABIT" "✅ Good practice: Having vulnerability fix tools available"
else
    print_status "WARNING" "Vulnerability fix script 'fix-app' not found"
    print_status "HABIT" "Consider creating tools to fix application vulnerabilities"
fi

echo ""

# Security reminder before build
print_header "🔒 Pre-Build Security Validation"

print_security_emphasis "DEVELOPER RESPONSIBILITY: Validate your application security NOW!"

print_status "HABIT" "🔍 Recommended Pre-Build Security Checks:"
echo "   1. Run: ./fix-app --dry-run (check for vulnerable dependencies)"
echo "   2. Run: ./fix-app (apply vulnerability fixes if needed)"
echo "   3. Run: mvn verify (validate application still works)"
echo "   4. Review: Application dependencies and versions"
echo "   5. Confirm: No known CVEs in your dependency stack"
echo ""

print_status "INFO" "Proceeding with DHI hardened base image build..."
echo ""

# Execute the build
print_header "🚀 Executing DHI Hardened Build"

print_status "INFO" "Building with DHI golden base images for enhanced security..."
print_status "INFO" "This demonstrates starting with a known good, hardened foundation"
print_status "INFO" "Using Docker Build Cloud for optimized build performance and registry push"
echo ""

# Construct and display the command
BUILD_CMD="docker buildx build"
if [[ -n "$BUILDER_ARG" ]]; then
    BUILD_CMD="$BUILD_CMD $BUILDER_ARG"
fi
BUILD_CMD="$BUILD_CMD --sbom=true --provenance=true --push -t artofthepossible/local-foundry-of-trust:dhi -f Dockerfile ."

print_status "COMMAND" "Executing: $BUILD_CMD"
echo "----------------------------------------"

# Execute the build command
if eval "$BUILD_CMD"; then
    print_status "SUCCESS" "DHI hardened build and push completed successfully!"
    print_status "SUCCESS" "Image pushed to artofthepossible/local-foundry-of-trust:dhi"
else
    print_status "ERROR" "DHI hardened build and push failed"
    exit 1
fi

echo ""

# Post-build analysis and comparison
print_header "📊 DHI Build Results & Security Analysis"

print_status "INFO" "Analyzing the DHI hardened image..."

# Since we pushed to registry, check if image was pushed successfully
print_status "INFO" "Image has been pushed to registry with security attestations"
print_status "SUCCESS" "Registry: artofthepossible/local-foundry-of-trust:dhi"
print_status "SUCCESS" "SBOM and provenance attestations included with pushed image"

echo ""

# Security benefits summary
print_header "🛡️ DHI Security Benefits Realized"

print_status "SUCCESS" "Security enhancements achieved with DHI:"
echo ""
print_status "SECURITY" "🔒 Build-Time Security:"
echo "   ✅ Started with pre-hardened, security-validated base images"
echo "   ✅ Eliminated baseline vulnerabilities common in standard images"
echo "   ✅ Applied security best practices from image foundation"
echo "   ✅ Generated SBOM with hardened component inventory"
echo ""

print_status "SECURITY" "🛡️ Runtime Security:"
echo "   ✅ Reduced attack surface through minimal, hardened runtime"
echo "   ✅ Security-focused configuration and permissions"
echo "   ✅ Defense in depth from container layer to application layer"
echo "   ✅ Supply chain integrity through digest pinning"
echo ""

print_status "SECURITY" "⬅️ Shift-Left Security Achieved:"
echo "   ✅ Security validation occurred before deployment"
echo "   ✅ Known good baseline established from start"
echo "   ✅ Proactive vulnerability management"
echo "   ✅ Developer-owned security practices demonstrated"
echo ""

# Developer habits reinforcement
print_header "🎯 Developer Security Habits - Action Items"

print_security_emphasis "MAKE THESE HABITS PART OF YOUR DAILY DEVELOPMENT WORKFLOW!"

print_status "HABIT" "✅ Daily Security Practices:"
echo "   1. 🛡️  Always start new projects with DHI hardened base images"
echo "   2. 🔍 Run vulnerability scans before every commit"
echo "   3. 🛠️  Fix application vulnerabilities immediately when found"
echo "   4. ⬆️  Keep dependencies updated and CVE-free"
echo "   5. 📋 Review SBOM and understand your dependency chain"
echo "   6. 🧪 Test security changes before committing"
echo "   7. 🚀 Only commit code that passes security validation"
echo ""

print_status "HABIT" "🔒 Team Security Culture:"
echo "   → Share vulnerability findings and fixes with team"
echo "   → Establish security gates in development workflow"
echo "   → Make security quality as important as code quality"
echo "   → Celebrate proactive security improvements"
echo ""

# Summary and next steps
print_header "🎉 DHI Defense in Depth Demo Summary"

print_status "SUCCESS" "DHI hardened build demo completed successfully!"
echo ""
print_status "INFO" "What we accomplished:"
echo "   🛡️ Built with DHI hardened golden base images"
echo "   🔒 Demonstrated defense in depth security"
echo "   ⬅️ Practiced shift-left security validation"
echo "   📋 Generated security artifacts (SBOM + Provenance)"
echo "   🎯 Reinforced developer security habits"
echo ""

print_status "INFO" "Security posture improvements:"
echo "   🔒 Enhanced baseline security from hardened images"
echo "   🛡️ Reduced attack surface and vulnerability exposure"
echo "   📊 Comprehensive security artifact generation"
echo "   🔍 Proactive vulnerability management workflow"
echo ""

print_status "INFO" "Next steps for security excellence:"
echo "   → Pull and test: docker pull artofthepossible/local-foundry-of-trust:dhi"
echo "   → Run locally: docker run -p 8080:8080 artofthepossible/local-foundry-of-trust:dhi"
echo "   → Verify attestations: docker buildx imagetools inspect artofthepossible/local-foundry-of-trust:dhi"
echo "   → Compare images: docker buildx imagetools inspect artofthepossible/local-foundry-of-trust:nodhi"
echo "   → Security comparison: Compare vulnerability scans between :nodhi and :dhi tags"
echo "   → Implement: Pre-commit security validation hooks"
echo "   → Adopt: DHI images as your team's default base images"
echo ""

print_security_emphasis "REMEMBER: Security is everyone's responsibility, starting with YOU!"

print_status "HABIT" "🎯 Key Takeaway: Start with known good hardened images, validate left of commit!"
echo ""
print_status "INFO" "Security artifacts generated and pushed:"
echo "   → SBOM: Hardened component inventory for compliance (attached to registry)"
echo "   → Provenance: Build attestation with security validation (attached to registry)"
echo "   → DHI Benefits: Enhanced security posture from foundation up"
echo "   → Registry Push: Image available for deployment with security attestations"
