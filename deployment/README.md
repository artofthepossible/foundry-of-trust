# Foundry of Trust - Local Kubernetes Deployment

This directory contains Terraform configurations and Helm charts to deploy the Foundry of Trust application (`artofthepossible/foundry-of-trust:v1.1-DHI-fixed`) to a local Docker Desktop Kubernetes cluster.

## 📋 Prerequisites

Before deploying, ensure you have the following installed and configured:

### Required Software
- **Docker Desktop** with Kubernetes enabled
- **Helm** (v3.x) - Kubernetes package manager
- **Terraform** (v1.0+) - Infrastructure as Code tool

### Installation Commands

**macOS (using Homebrew):**
```bash
# Install Docker Desktop manually from https://www.docker.com/products/docker-desktop

# Install kubectl, helm, and terraform
brew install kubectl helm terraform
```

**Windows (using Chocolatey):**
```bash
# Install Docker Desktop manually from https://www.docker.com/products/docker-desktop

# Install tools
choco install kubernetes-cli kubernetes-helm terraform
```

### Docker Desktop Setup
1. Install and start Docker Desktop
2. Go to Settings → Kubernetes → Enable Kubernetes
3. Wait for Kubernetes to start (green indicator)

## 🚀 Quick Start

### 1. Verify Prerequisites
```bash
# Check if all tools are installed
kubectl version --client
helm version
terraform version
docker --version

# Verify Docker Desktop Kubernetes is running
kubectl cluster-info --context docker-desktop
```

### 2. Deploy the Application
```bash
# Navigate to the deployment directory
cd deployment

# Run the deployment script
./scripts/deploy-local.sh
```

### 3. Access the Application
```bash
# Port forward to access the application
kubectl port-forward -n foundry-of-trust svc/foundry-of-trust 8080:80

# Open in browser: http://localhost:8080
```

## 📁 Directory Structure

```
deployment/
├── helm/
│   └── foundry-of-trust/          # Helm chart for the application
│       ├── Chart.yaml             # Chart metadata
│       ├── values.yaml            # Default configuration values
│       └── templates/             # Kubernetes manifests
│           ├── deployment.yaml    # Application deployment
│           ├── service.yaml       # Service definition
│           ├── configmap.yaml     # Configuration
│           ├── serviceaccount.yaml # Service account
│           ├── ingress.yaml       # Ingress (optional)
│           └── hpa.yaml           # Horizontal Pod Autoscaler
├── terraform/                     # Terraform configurations
│   ├── foundry.tf                # Main Terraform configuration
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   └── values.yaml                # Terraform-managed Helm values
└── scripts/                       # Deployment scripts
    ├── deploy-local.sh            # Main deployment script
    ├── cleanup.sh                 # Cleanup script
    └── status.sh                  # Status check script
```

## 🛠️ Manual Deployment Steps

If you prefer to deploy manually:

### Using Terraform:
```bash
cd deployment/terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the deployment
terraform apply
```

### Using Helm directly:
```bash
cd deployment

# Create namespace
kubectl create namespace foundry-of-trust

# Deploy using Helm
helm install foundry-of-trust helm/foundry-of-trust \
  --namespace foundry-of-trust \
  --set image.tag=v1.1-DHI-fixed
```

## 📊 Monitoring and Management

### Check Application Status
```bash
# Run status check script
./scripts/status.sh

# Or check manually
kubectl get pods -n foundry-of-trust
kubectl get services -n foundry-of-trust
```

### View Application Logs
```bash
# Follow application logs
kubectl logs -n foundry-of-trust -l app.kubernetes.io/name=foundry-of-trust -f

# View recent logs
kubectl logs -n foundry-of-trust deployment/foundry-of-trust --tail=50
```

### Access VEX Document
```bash
# View the embedded VEX document
kubectl exec -n foundry-of-trust deployment/foundry-of-trust -- cat /app/vex.json

# Or extract it locally
kubectl cp foundry-of-trust/$(kubectl get pods -n foundry-of-trust -l app.kubernetes.io/name=foundry-of-trust -o jsonpath='{.items[0].metadata.name}'):/app/vex.json ./vex-extracted.json
```

## 🔧 Configuration

### Customizing the Deployment

Edit the Helm values in `helm/foundry-of-trust/values.yaml`:

```yaml
# Number of replicas
replicaCount: 2

# Resource limits
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

# Enable ingress
ingress:
  enabled: true
  hosts:
    - host: foundry-of-trust.local
```

### Environment Variables

The application supports these environment variables:

- `SPRING_PROFILES_ACTIVE`: Spring Boot profile (default: "kubernetes")
- `JAVA_OPTS`: JVM options (default: "-Xms128m -Xmx384m -XX:+UseG1GC")
- `SERVER_PORT`: Application port (default: "8080")

## 🔍 Health Checks

The application includes Spring Boot Actuator endpoints:

- **Health**: `http://localhost:8080/actuator/health`
- **Info**: `http://localhost:8080/actuator/info`
- **Metrics**: `http://localhost:8080/actuator/metrics`
- **Liveness**: `http://localhost:8080/actuator/health/liveness`
- **Readiness**: `http://localhost:8080/actuator/health/readiness`

## 🧹 Cleanup

### Remove the Application
```bash
# Run cleanup script
./scripts/cleanup.sh

# Or manually with Terraform
cd deployment/terraform
terraform destroy

# Or manually with Helm
helm uninstall foundry-of-trust -n foundry-of-trust
kubectl delete namespace foundry-of-trust
```

## 🐛 Troubleshooting

### Common Issues

**1. Docker Desktop Kubernetes not running:**
```bash
# Check if Kubernetes is enabled in Docker Desktop settings
kubectl cluster-info --context docker-desktop
```

**2. Image pull issues:**
```bash
# Manually pull the image
docker pull artofthepossible/foundry-of-trust:v1.1-DHI-fixed
```

**3. Port already in use:**
```bash
# Find what's using port 8080
lsof -i :8080

# Use a different port for port-forwarding
kubectl port-forward -n foundry-of-trust svc/foundry-of-trust 8081:80
```

**4. Pods not starting:**
```bash
# Check pod events
kubectl describe pods -n foundry-of-trust

# Check pod logs
kubectl logs -n foundry-of-trust deployment/foundry-of-trust
```

### Debug Commands
```bash
# Get all resources in namespace
kubectl get all -n foundry-of-trust

# Describe deployment
kubectl describe deployment foundry-of-trust -n foundry-of-trust

# Check Helm release status
helm status foundry-of-trust -n foundry-of-trust

# Validate Helm chart
helm lint helm/foundry-of-trust
```

## 🔐 Security Features

This deployment includes several security features:

- **VEX Document**: Embedded at `/app/vex.json` with OpenVEX v0.2.0 standard
- **SBOM**: Software Bill of Materials attached as attestation
- **Provenance**: Build provenance attestation for supply chain security
- **Security Context**: Non-root container execution with restricted capabilities
- **Read-only Root Filesystem**: Enhanced container security
- **Resource Limits**: CPU and memory constraints

## 📝 Notes

- The application runs on port 8080 internally
- Default namespace is `foundry-of-trust`
- The Helm chart includes configurable resource limits, health checks, and scaling options
- All security attestations (VEX, SBOM, Provenance) are embedded in the image
- The deployment uses the DHI golden base images for enhanced security