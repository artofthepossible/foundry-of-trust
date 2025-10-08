#!/bin/bash
# Build and push image with embedded VEX document
# This approach includes VEX directly in the application image

set -euo pipefail

IMAGE_NAME="${1:-demonstrationorg/foundry-of-trust}"
IMAGE_TAG="${2:-v1.1-DHI-fixed}"
VEX_FILE="${3:-scripts/assets/targeted-vex-20251008181815.json}"
PLATFORMS="${4:-linux/amd64,linux/arm64}"

FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

echo "🏗️ Building image with embedded VEX document..."
echo "Image: $FULL_IMAGE_NAME"
echo "VEX File: $VEX_FILE"
echo "Platforms: $PLATFORMS"

# Validate VEX document exists and is valid JSON
if [ ! -f "$VEX_FILE" ]; then
    echo "❌ VEX file not found: $VEX_FILE"
    exit 1
fi

if ! jq empty "$VEX_FILE" 2>/dev/null; then
    echo "❌ Invalid JSON in VEX file: $VEX_FILE"
    exit 1
fi

echo "✅ VEX document validated"

# VEX document is already embedded in the main Dockerfile
echo "📋 Using main Dockerfile with embedded VEX document..."
echo "✅ VEX document and metadata already configured in Dockerfile"

# Build the enhanced image with SBOM and provenance
echo "🔨 Building Docker image with embedded VEX, SBOM, and provenance..."

# Check if buildx builder exists, create if needed
BUILDER_NAME="foundry-builder"
if ! docker buildx inspect "$BUILDER_NAME" >/dev/null 2>&1; then
    echo "📋 Creating Docker Buildx builder: $BUILDER_NAME"
    docker buildx create --name "$BUILDER_NAME" --driver docker-container --bootstrap
else
    echo "📋 Using existing Docker Buildx builder: $BUILDER_NAME"
fi

# Ensure builder is running
docker buildx inspect "$BUILDER_NAME" --bootstrap >/dev/null 2>&1

# Use buildx for enhanced build with SBOM and provenance
docker buildx build \
    --builder "$BUILDER_NAME" \
    --platform "$PLATFORMS" \
    --file Dockerfile \
    --tag "$FULL_IMAGE_NAME" \
    --sbom=true \
    --provenance=true \
    --metadata-file build-metadata.json \
    --annotation "vex.openvex.dev/embedded=true" \
    --annotation "vex.openvex.dev/document=/app/vex.json" \
    --annotation "vex.openvex.dev/schema-version=v0.2.0" \
    --annotation "org.opencontainers.image.title=Foundry of Trust with Embedded VEX" \
    --annotation "org.opencontainers.image.description=Spring Boot application with embedded VEX statements for CVE compliance" \
    --push \
    .

echo "✅ Image built and pushed with SBOM and provenance"

# Display build metadata if available
if [ -f "build-metadata.json" ]; then
    echo "📋 Build metadata:"
    jq -r '.["containerimage.digest"], .["containerimage.config.digest"]' build-metadata.json 2>/dev/null | sed 's/^/   /'
    rm -f build-metadata.json
fi

# Clean up is not needed since we use the main Dockerfile
echo ""

echo ""
echo "✅ Image with embedded VEX completed!"
echo "📋 Image: $FULL_IMAGE_NAME"
echo ""
echo "🔗 To access VEX document:"
echo "   docker run --rm $FULL_IMAGE_NAME cat /app/vex.json"
echo ""

# Verify SBOM and attestations
echo "🔍 Verifying SBOM and attestations..."
docker buildx imagetools inspect "$FULL_IMAGE_NAME" --format '{{json .}}' | jq -r '.attestations // [] | length' | \
    awk '{if($1>0) print "✅ Found " $1 " attestation(s)"; else print "⚠️ No attestations found"}'

# Check for SBOM specifically
if docker buildx imagetools inspect "$FULL_IMAGE_NAME" --format '{{json .}}' | jq -e '.attestations[]? | select(.mediaType | contains("spdx"))' >/dev/null 2>&1; then
    echo "✅ SBOM attestation present"
else
    echo "⚠️ SBOM attestation not found"
fi

# Check for provenance
if docker buildx imagetools inspect "$FULL_IMAGE_NAME" --format '{{json .}}' | jq -e '.attestations[]? | select(.mediaType | contains("provenance"))' >/dev/null 2>&1; then
    echo "✅ Provenance attestation present"
else
    echo "⚠️ Provenance attestation not found"
fi

echo ""

# Verify VEX accessibility using alternative methods for DHI minimal images
echo "🔍 Verifying VEX accessibility..."

# Method 1: Try to extract VEX document directly
if docker create --name vex-check "$FULL_IMAGE_NAME" >/dev/null 2>&1; then
    if docker cp vex-check:/app/vex.json /tmp/vex-check.json >/dev/null 2>&1; then
        echo "✅ VEX document exists in container"
        # Test if VEX document is valid JSON
        if jq empty /tmp/vex-check.json 2>/dev/null; then
            CVE_COUNT=$(jq '.statements | length' /tmp/vex-check.json 2>/dev/null)
            echo "✅ VEX document is valid JSON covering $CVE_COUNT CVEs"
        else
            echo "⚠️ VEX document exists but may not be valid JSON"
        fi
        rm -f /tmp/vex-check.json
    else
        echo "❌ VEX document not found in container"
    fi
    docker rm vex-check >/dev/null 2>&1
else
    echo "❌ Failed to create temporary container for VEX verification"
fi

echo ""
echo "📊 **Security Attestations Summary:**"
echo "   🛡️ VEX Document: Embedded at /app/vex.json"
echo "   📋 SBOM: Attached as attestation"
echo "   🔒 Provenance: Attached as attestation"
echo "   🏗️ Multi-platform: linux/amd64, linux/arm64"
echo ""
echo "🔍 **Inspection Commands:**"
echo "   # View all attestations:"
echo "   docker buildx imagetools inspect $FULL_IMAGE_NAME"
echo "   # Extract VEX document:"
echo "   docker run --rm --entrypoint='' $FULL_IMAGE_NAME cat /app/vex.json"
echo "   # View SBOM:"
echo "   docker scout sbom $FULL_IMAGE_NAME"