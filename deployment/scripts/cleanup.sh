#!/bin/bash

# Foundry of Trust - Cleanup Script
# This script removes the Foundry of Trust application from the local Kubernetes cluster

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NAMESPACE="foundry-of-trust"
RELEASE_NAME="foundry-of-trust"

echo -e "${BLUE}🧹 Foundry of Trust - Cleanup${NC}"
echo -e "${BLUE}==============================${NC}"

# Navigate to terraform directory
cd "$(dirname "$0")/../terraform"

# Destroy the deployment
echo -e "${YELLOW}🗑️  Destroying Terraform deployment...${NC}"
terraform destroy -auto-approve \
    -var="namespace=${NAMESPACE}" \
    -var="release_name=${RELEASE_NAME}"

# Verify cleanup
echo -e "${YELLOW}🔍 Verifying cleanup...${NC}"
if kubectl get namespace ${NAMESPACE} >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Namespace still exists, attempting manual cleanup...${NC}"
    kubectl delete namespace ${NAMESPACE} --ignore-not-found=true
else
    echo -e "${GREEN}✅ Namespace successfully removed${NC}"
fi

echo -e "${GREEN}🎉 Cleanup completed successfully!${NC}"