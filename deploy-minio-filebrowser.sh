#!/bin/bash

# =============================================================================
# DEPLOY MINIO + FILEBROWSER
# =============================================================================
# Script zum Deployment von MinIO mit FileBrowser als einfachem Web-Interface

set -e

echo "🚀 Deploying MinIO + FileBrowser..."

# Namespace erstellen
echo "📦 Creating namespace..."
kubectl create namespace storage --dry-run=client -o yaml | kubectl apply -f -

# MinIO + FileBrowser deployen
echo "🗄️ Deploying MinIO + FileBrowser..."
kubectl apply -f filebrowser-deployment.yaml

# Warten auf Pods
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=minio -n storage --timeout=300s
kubectl wait --for=condition=ready pod -l app=filebrowser -n storage --timeout=300s

# Status anzeigen
echo "📊 Deployment Status:"
kubectl get pods -n storage
kubectl get services -n storage
kubectl get pvc -n storage

# NodePort anzeigen
echo ""
echo "🌐 Access Information:"
echo "FileBrowser (Web-Interface):"
FILEBROWSER_PORT=$(kubectl get service filebrowser-service -n storage -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
echo "  http://192.168.1.101:${FILEBROWSER_PORT}"
echo "  http://192.168.1.110:${FILEBROWSER_PORT}"
echo ""
echo "MinIO API (S3-API):"
echo "  Internal: minio-service.storage.svc.cluster.local:9000"
echo "  (Accessible from within cluster)"
echo ""
echo "Credentials:"
echo "  FileBrowser: admin/admin (default, change after first login)"
echo "  MinIO API: admin/minio123"
echo ""
echo "🎉 MinIO + FileBrowser deployed successfully!"
echo ""
echo "📝 Next Steps:"
echo "1. Open FileBrowser in browser"
echo "2. Login with admin/admin (change password)"
echo "3. Browse and manage files"
echo "4. Use MinIO S3-API from applications"
echo ""
echo "🔧 S3-API Configuration (for apps):"
echo "  Endpoint: minio-service.storage.svc.cluster.local:9000"
echo "  Access Key: admin"
echo "  Secret Key: minio123"
echo "  Region: us-east-1"
