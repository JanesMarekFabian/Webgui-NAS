#!/bin/bash

# =============================================================================
# NAS DEPLOYMENT SCRIPT
# =============================================================================
# Script zum Deployen der NAS mit Web-GUI auf Ihrem Kubernetes Cluster

echo "🚀 Deploying NAS with Web-GUI to Kubernetes Cluster..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster"
    exit 1
fi

print_success "Connected to Kubernetes cluster"

# Create shared-services namespace if it doesn't exist
print_status "Creating shared-services namespace..."
kubectl create namespace shared-services --dry-run=client -o yaml | kubectl apply -f -

# Deploy PostgreSQL for Nextcloud
print_status "Deploying PostgreSQL for Nextcloud..."
kubectl apply -f postgres-nextcloud.yaml

# Wait for PostgreSQL to be ready
print_status "Waiting for PostgreSQL to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres,component=nextcloud-db -n shared-services --timeout=300s

# Deploy Nextcloud PVCs
print_status "Deploying Nextcloud PVCs..."
kubectl apply -f nextcloud-pvcs.yaml

# Deploy Nextcloud
print_status "Deploying Nextcloud NAS..."
kubectl apply -f nextcloud-deployment.yaml

# Wait for deployments to be ready
print_status "Waiting for deployments to be ready..."
kubectl wait --for=condition=available deployment/nextcloud -n shared-services --timeout=300s

# Get service information
print_status "Getting service information..."

echo ""
print_success "🎉 NAS Deployment completed successfully!"
echo ""

# Display access information
print_status "📋 Access Information:"
echo ""

# Nextcloud access
NEXTCLOUD_NODEPORT=$(kubectl get service nextcloud-service -n shared-services -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
if [ ! -z "$NEXTCLOUD_NODEPORT" ]; then
    print_success "Nextcloud (Full NAS):"
    echo "  🌐 Web Interface: http://192.168.1.101:$NEXTCLOUD_NODEPORT"
    echo "  🌐 Web Interface: http://192.168.1.110:$NEXTCLOUD_NODEPORT"
    echo "  👤 Admin User: admin"
    echo "  🔑 Admin Password: admin_secure_password_123"
    echo ""
fi


# Port forwarding option
print_status "🔧 Alternative Access (Port Forwarding):"
echo "  kubectl port-forward service/nextcloud-service 8080:80 -n shared-services"
echo ""

# Display pod status
print_status "📊 Pod Status:"
kubectl get pods -n shared-services -l app=nextcloud
kubectl get pods -n shared-services -l app=postgres,component=shared-database

echo ""
print_status "📊 PVC Status:"
kubectl get pvc -n shared-services

echo ""
print_status "📊 Services:"
kubectl get services -n shared-services

echo ""
print_success "🎯 Your Nextcloud NAS with Web-GUI is ready!"
print_status "Nextcloud provides a complete NAS solution with file management, user management, and mobile apps."
