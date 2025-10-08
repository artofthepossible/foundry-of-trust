#!/bin/bash
# Build image with Docker Buildx and attach VEX as attestation
# This approach uses Docker Buildx attestation features

set -euo pipefail

IMAGE_NAME="${1:-demonstrationorg/foundry-of-trust}"
IMAGE_TAG="${2:-v1.1-DHI-fixed}"
VEX_FILE="${3:-scripts/assets/targeted-vex-20251008181815.json}"

FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

echo "🏗️ Building image with Docker Buildx and VEX attestation..."
echo "Image: $FULL_IMAGE_NAME"
echo "VEX File: $VEX_FILE"

# Validate VEX document
if [ ! -f "$VEX_FILE" ]; then
    echo "❌ VEX file not found: $VEX_FILE"
    exit 1
fi

if ! jq empty "$VEX_FILE" 2>/dev/null; then
    echo "❌ Invalid JSON in VEX file: $VEX_FILE"
    exit 1
fi

echo "✅ VEX document validated"

# Create VEX attestation file for buildx
VEX_ATTESTATION_FILE="vex-attestation.json"
cat > "$VEX_ATTESTATION_FILE" << EOF
{
  "predicateType": "https://openvex.dev/ns/v0.2.0",
  "predicate": $(cat "$VEX_FILE")
}
EOF

echo "📋 VEX attestation file created: $VEX_ATTESTATION_FILE"

# Build with Buildx including VEX attestation
echo "🔨 Building with Docker Buildx..."
docker buildx build \
    --builder cloud-demonstrationorg-default \
    --platform linux/amd64,linux/arm64 \
    --sbom=true \
    --provenance=true \
    --attestation "type=custom,name=vex,predicate-file=$VEX_ATTESTATION_FILE" \
    -t "$FULL_IMAGE_NAME" \
    --push \
    .

# Clean up attestation file
rm -f "$VEX_ATTESTATION_FILE"

echo ""
echo "✅ Buildx with VEX attestation completed!"
echo "📋 Image: $FULL_IMAGE_NAME"
echo ""

# Verify attestations
echo "🔍 Verifying attestations..."
docker buildx imagetools inspect "$FULL_IMAGE_NAME" --format '{{json .}}' | jq '.attestations // []'

echo ""
echo "🔗 VEX attestation attached to image"
echo "   Use: docker buildx imagetools inspect $FULL_IMAGE_NAME"