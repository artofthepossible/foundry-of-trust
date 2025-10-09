#!/bin/bash

# Foundry of Trust - Local Kubernetes Deployment Script
# This script deploys the Foundry of Trust application to a local Docker Desktop Kubernetes cluster

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
IMAGE_TAG="v1.1-DHI-fixed"

echo -e "${BLUE}🚀 Foundry of Trust - Local Kubernetes Deployment${NC}"
echo -e "${BLUE}=================================================${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

if ! command_exists kubectl; then
    echo -e "${RED}❌ kubectl is not installed. Please install kubectl first.${NC}"
    exit 1
fi

if ! command_exists helm; then
    echo -e "${RED}❌ Helm is not installed. Please install Helm first.${NC}"
    exit 1
fi

if ! command_exists terraform; then
    echo -e "${RED}❌ Terraform is not installed. Please install Terraform first.${NC}"
    exit 1
fi

if ! command_exists docker; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker Desktop first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites are installed${NC}"

# Check if Docker Desktop Kubernetes is running
echo -e "${YELLOW}🔍 Checking Docker Desktop Kubernetes...${NC}"
if ! kubectl cluster-info --context docker-desktop >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker Desktop Kubernetes is not running or not accessible.${NC}"
    echo -e "${YELLOW}Please ensure Docker Desktop is running and Kubernetes is enabled.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker Desktop Kubernetes is running${NC}"

# Set kubectl context
kubectl config use-context docker-desktop
echo -e "${GREEN}✅ Kubectl context set to docker-desktop${NC}"

# Pull the latest image to ensure it's available locally
echo -e "${YELLOW}🐳 Pulling Docker image...${NC}"
if docker pull "demonstrationorg/foundry-of-trust:${IMAGE_TAG}"; then
    echo -e "${GREEN}✅ Docker image pulled successfully${NC}"
else
    echo -e "${RED}❌ Failed to pull Docker image. Continuing anyway...${NC}"
fi

# Navigate to terraform directory
cd "$(dirname "$0")/../terraform"

# Initialize Terraform
echo -e "${YELLOW}🔧 Initializing Terraform...${NC}"
terraform init

# Validate Terraform configuration
echo -e "${YELLOW}🔍 Validating Terraform configuration...${NC}"
terraform validate

# Plan the deployment
echo -e "${YELLOW}📋 Planning Terraform deployment...${NC}"
terraform plan \
    -var="namespace=${NAMESPACE}" \
    -var="release_name=${RELEASE_NAME}" \
    -var="image_tag=${IMAGE_TAG}"

# Apply the deployment
echo -e "${YELLOW}🚀 Deploying application...${NC}"
terraform apply -auto-approve \
    -var="namespace=${NAMESPACE}" \
    -var="release_name=${RELEASE_NAME}" \
    -var="image_tag=${IMAGE_TAG}"

# Wait for deployment to be ready
echo -e "${YELLOW}⏳ Waiting for deployment to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/${RELEASE_NAME} -n ${NAMESPACE}

# Get deployment status
echo -e "${YELLOW}📊 Checking deployment status...${NC}"
kubectl get pods -n ${NAMESPACE} -l app.kubernetes.io/name=foundry-of-trust

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${BLUE}=================================================${NC}"
echo -e "${YELLOW}📝 Access Information:${NC}"
echo -e "• Namespace: ${NAMESPACE}"
echo -e "• Release: ${RELEASE_NAME}"
echo -e "• Image: demonstrationorg/foundry-of-trust:${IMAGE_TAG}"
echo ""
echo -e "${YELLOW}🔗 Access the application:${NC}"
echo -e "kubectl port-forward -n ${NAMESPACE} svc/${RELEASE_NAME} 8080:80"
echo -e "Then open: http://localhost:8080"
echo ""
echo -e "${YELLOW}📊 Monitor the application:${NC}"
echo -e "kubectl logs -n ${NAMESPACE} -l app.kubernetes.io/name=foundry-of-trust -f"
echo ""
echo -e "${YELLOW}🔍 View VEX document:${NC}"
echo -e "kubectl exec -n ${NAMESPACE} deployment/${RELEASE_NAME} -- cat /app/vex.json"