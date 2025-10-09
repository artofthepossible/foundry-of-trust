#!/bin/bash

# Foundry of Trust - Status Check Script
# This script checks the status of the deployed application

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

echo -e "${BLUE}📊 Foundry of Trust - Status Check${NC}"
echo -e "${BLUE}===================================${NC}"

# Check if namespace exists
if ! kubectl get namespace ${NAMESPACE} >/dev/null 2>&1; then
    echo -e "${RED}❌ Namespace '${NAMESPACE}' not found. Application may not be deployed.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Namespace found: ${NAMESPACE}${NC}"

# Check Helm release
echo -e "${YELLOW}🔍 Checking Helm release...${NC}"
if helm status ${RELEASE_NAME} -n ${NAMESPACE} >/dev/null 2>&1; then
    helm status ${RELEASE_NAME} -n ${NAMESPACE}
    echo -e "${GREEN}✅ Helm release is deployed${NC}"
else
    echo -e "${RED}❌ Helm release not found${NC}"
    exit 1
fi

# Check pods
echo -e "${YELLOW}🔍 Checking pods...${NC}"
kubectl get pods -n ${NAMESPACE} -l app.kubernetes.io/name=foundry-of-trust

# Check services
echo -e "${YELLOW}🔍 Checking services...${NC}"
kubectl get services -n ${NAMESPACE}

# Check deployment status
echo -e "${YELLOW}🔍 Checking deployment status...${NC}"
kubectl get deployment ${RELEASE_NAME} -n ${NAMESPACE}

# Check if pods are ready
echo -e "${YELLOW}🔍 Checking pod readiness...${NC}"
READY_PODS=$(kubectl get pods -n ${NAMESPACE} -l app.kubernetes.io/name=foundry-of-trust --no-headers | grep "Running" | grep "1/1" | wc -l)
TOTAL_PODS=$(kubectl get pods -n ${NAMESPACE} -l app.kubernetes.io/name=foundry-of-trust --no-headers | wc -l)

if [ "$READY_PODS" -eq "$TOTAL_PODS" ] && [ "$TOTAL_PODS" -gt 0 ]; then
    echo -e "${GREEN}✅ All pods are ready (${READY_PODS}/${TOTAL_PODS})${NC}"
else
    echo -e "${YELLOW}⚠️  Pods not all ready (${READY_PODS}/${TOTAL_PODS})${NC}"
fi

# Show recent logs
echo -e "${YELLOW}📋 Recent application logs:${NC}"
kubectl logs -n ${NAMESPACE} -l app.kubernetes.io/name=foundry-of-trust --tail=10

echo -e "${BLUE}===================================${NC}"
echo -e "${YELLOW}🔗 Access the application:${NC}"
echo -e "kubectl port-forward -n ${NAMESPACE} svc/${RELEASE_NAME} 8080:80"
echo -e "Then open: http://localhost:8080"
echo ""
echo -e "${YELLOW}📊 View logs:${NC}"
echo -e "kubectl logs -n ${NAMESPACE} -l app.kubernetes.io/name=foundry-of-trust -f"
echo ""
echo -e "${YELLOW}🔍 View VEX document:${NC}"
echo -e "kubectl exec -n ${NAMESPACE} deployment/${RELEASE_NAME} -- cat /app/vex.json"