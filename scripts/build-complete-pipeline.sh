#!/bin/bash
# Complete pipeline: Build image + Generate VEX + Attach as separate artifact
# This combines the current approach with automated VEX generation

set -euo pipefail

IMAGE_NAME="${1:-demonstrationorg/foundry-of-trust}"
IMAGE_TAG="${2:-v1.1-DHI-fixed}"
BUILDER="${3:-cloud-demonstrationorg-default}"

FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"
VEX_FILE="scripts/assets/targeted-vex-$(date +%Y%m%d%H%M%S).json"

echo "🚀 **COMPLETE BUILD + VEX PIPELINE**"
echo "Image: $FULL_IMAGE_NAME"
echo "Builder: $BUILDER"
echo "VEX File: $VEX_FILE"
echo ""

# Step 1: Build the main application image
echo "📦 **Step 1: Building Application Image**"
docker buildx build \
    --builder "$BUILDER" \
    --sbom=true \
    --provenance=true \
    -t "$FULL_IMAGE_NAME" \
    --push \
    .

echo "✅ Application image built and pushed"
echo ""

# Step 2: Generate fresh VEX document with current image digest
echo "🛡️ **Step 2: Generating VEX Document**"

# Get image digest
IMAGE_DIGEST=$(docker buildx imagetools inspect "$FULL_IMAGE_NAME" --format '{{.Manifest.Digest}}')
echo "📋 Image digest: $IMAGE_DIGEST"

# Create VEX directory if it doesn't exist
mkdir -p scripts/assets/

# Generate VEX document with current timestamp and digest
cat > "$VEX_FILE" << EOF
{
  "@context": "https://openvex.dev/ns/v0.2.0",
  "@id": "https://openvex.dev/docs/example/vex-$(date +%s)",
  "author": "Foundry of Trust Demo - Automated Pipeline",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "version": 1,
  "statements": [
    {
      "vulnerability": {
        "name": "CVE-2025-22235",
        "@id": "https://www.cve.org/CVERecord?id=CVE-2025-22235"
      },
      "products": [
        {
          "@id": "pkg:oci/${IMAGE_NAME}@${IMAGE_DIGEST}",
          "identifiers": {
            "purl": "pkg:maven/org.springframework.boot/spring-boot@3.2.10"
          }
        }
      ],
      "status": "not_affected",
      "justification": "vulnerable_code_not_in_execute_path",
      "impact_statement": "Spring Boot input validation components are not accessible in application configuration. Application uses minimal Spring Boot features and does not expose vulnerable validation endpoints.",
      "action_statement": "No action required - vulnerable code path not in execution. Application architecture prevents exploitation through input validation bypass."
    },
    {
      "vulnerability": {
        "name": "CVE-2025-41242",
        "@id": "https://www.cve.org/CVERecord?id=CVE-2025-41242"
      },
      "products": [
        {
          "@id": "pkg:oci/${IMAGE_NAME}@${IMAGE_DIGEST}",
          "identifiers": {
            "purl": "pkg:maven/org.springframework/spring-webmvc@6.1.21"
          }
        }
      ],
      "status": "not_affected",
      "justification": "vulnerable_code_not_in_execute_path",
      "impact_statement": "Application does not expose file serving endpoints or static resource handlers that could be exploited for path traversal. Only serves dynamic content through controllers.",
      "action_statement": "No action required - application architecture prevents exploitation. No file serving capabilities exposed to external requests."
    }
  ]
}
EOF

echo "✅ VEX document generated: $VEX_FILE"

# Validate generated VEX
if jq empty "$VEX_FILE" 2>/dev/null; then
    echo "✅ VEX document is valid JSON"
    CVE_COUNT=$(jq '.statements | length' "$VEX_FILE")
    echo "📊 VEX covers $CVE_COUNT CVEs"
else
    echo "❌ Generated VEX document is invalid"
    exit 1
fi

echo ""

# Step 3: Attach VEX as separate OCI artifact
echo "🔗 **Step 3: Attaching VEX as OCI Artifact**"

if command -v oras >/dev/null 2>&1; then
    echo "📤 Pushing VEX with ORAS..."
    
    # Push as separate VEX artifact with timestamp
    VEX_TAG="docker.io/${FULL_IMAGE_NAME}-vex-$(date +%Y%m%d)"
    
    oras push "$VEX_TAG" \
        "$VEX_FILE:application/vnd.openvex" \
        --annotation "org.opencontainers.image.title=VEX Document for $FULL_IMAGE_NAME" \
        --annotation "org.opencontainers.image.description=OpenVEX v0.2.0 vulnerability statements" \
        --annotation "vex.openvex.dev/schema-version=v0.2.0" \
        --annotation "vex.openvex.dev/target-image=$FULL_IMAGE_NAME" \
        --annotation "vex.openvex.dev/target-digest=$IMAGE_DIGEST" \
        --annotation "vex.generated.timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        
    echo "✅ VEX artifact pushed to: $VEX_TAG"
    
    # Also push to current approach (overwrite same tag)
    CURRENT_VEX_TAG="docker.io/${FULL_IMAGE_NAME}"
    oras push "$CURRENT_VEX_TAG" \
        "$VEX_FILE:application/vnd.openvex" \
        --annotation "org.opencontainers.image.title=VEX Document for $FULL_IMAGE_NAME" \
        --annotation "org.opencontainers.image.description=OpenVEX v0.2.0 vulnerability statements" \
        --annotation "vex.openvex.dev/schema-version=v0.2.0"
        
    echo "✅ VEX artifact also pushed to: $CURRENT_VEX_TAG"
    
else
    echo "❌ ORAS not available for VEX attachment"
    exit 1
fi

echo ""

# Step 4: Verification and summary
echo "🔍 **Step 4: Verification**"

echo "📋 **Build Summary:**"
echo "   Application Image: $FULL_IMAGE_NAME"
echo "   Image Digest: $IMAGE_DIGEST"
echo "   VEX Document: $VEX_FILE"
echo "   VEX Artifact (Versioned): $VEX_TAG"
echo "   VEX Artifact (Current): $CURRENT_VEX_TAG"
echo ""

echo "🔍 Verifying image..."
docker buildx imagetools inspect "$FULL_IMAGE_NAME" > /dev/null && echo "✅ Application image accessible"

echo "🔍 Verifying VEX artifacts..."
oras manifest fetch "$VEX_TAG" > /dev/null 2>&1 && echo "✅ Versioned VEX artifact accessible"
oras manifest fetch "$CURRENT_VEX_TAG" > /dev/null 2>&1 && echo "✅ Current VEX artifact accessible"

echo ""
echo "🎯 **Usage Instructions:**"
echo ""
echo "📦 **Pull Application Image:**"
echo "   docker pull $FULL_IMAGE_NAME"
echo ""
echo "🛡️ **Access VEX Documents:**"
echo "   # Versioned VEX artifact:"
echo "   oras pull $VEX_TAG --output vex-extracted/"
echo "   # Current VEX artifact:"
echo "   oras pull $CURRENT_VEX_TAG --output vex-current/"
echo ""
echo "🔍 **Scanner Integration:**"
echo "   # Use with Grype:"
echo "   grype $FULL_IMAGE_NAME --vex-documents $VEX_FILE"
echo "   # Use with Trivy:"
echo "   trivy image --ignore-vex $VEX_FILE $FULL_IMAGE_NAME"
echo ""

echo "✅ **PIPELINE COMPLETED SUCCESSFULLY!**"
echo "🚀 Application built with comprehensive VEX coverage"