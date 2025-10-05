#!/bin/bash

# =============================================================================
# DEPLOY MINIO + MINIO CONSOLE
# =============================================================================
# Script zum Deployment von MinIO mit eingebautem Web-Console

set -e

echo "🚀 Deploying MinIO + MinIO Console..."

# Namespace erstellen
echo "📦 Creating namespace..."
kubectl create namespace storage --dry-run=client -o yaml | kubectl apply -f -

# MinIO + Console deployen
echo "🗄️ Deploying MinIO + Console..."
kubectl apply -f minio-deployment.yaml

# Warten auf Pods
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=minio -n storage --timeout=300s

# Status anzeigen
echo "📊 Deployment Status:"
kubectl get pods -n storage
kubectl get services -n storage
kubectl get pvc -n storage

# NodePort anzeigen
echo ""
echo "🌐 Access Information:"
echo "MinIO Console (Web-Interface):"
MINIO_CONSOLE_PORT=$(kubectl get service minio-service -n storage -o jsonpath='{.spec.ports[?(@.name=="console")].nodePort}')
echo "  http://192.168.1.101:${MINIO_CONSOLE_PORT}"
echo "  http://192.168.1.110:${MINIO_CONSOLE_PORT}"
echo ""
echo "MinIO API (S3-API):"
MINIO_API_PORT=$(kubectl get service minio-service -n storage -o jsonpath='{.spec.ports[?(@.name=="api")].nodePort}')
echo "  http://192.168.1.101:${MINIO_API_PORT}"
echo "  http://192.168.1.110:${MINIO_API_PORT}"
echo ""
echo "Credentials:"
echo "  Username: admin"
echo "  Password: minio123"
echo ""
echo "🎉 MinIO + Console deployed successfully!"
echo ""
echo "📝 Next Steps:"
echo "1. Open MinIO Console in browser"
echo "2. Login with admin/minio123"
echo "3. Create buckets for your data"
echo "4. Configure S3-API access"
echo ""
echo "🔧 S3-API Configuration:"
echo "  Endpoint: http://192.168.1.101:${MINIO_API_PORT}"
echo "  Access Key: admin"
echo "  Secret Key: minio123"
