# WebGUI-NAS - MinIO S3-API Storage mit Web-Interface

## 🎯 Übersicht

Dieses Projekt bietet zwei moderne Storage-Lösungen mit S3-API und Web-Interface für Ihr Kubernetes Cluster:

1. **MinIO + MinIO Console** - S3-API mit eingebautem Web-Interface
2. **MinIO + FileBrowser** - S3-API mit einfachem File-Manager

## 🏗️ Architektur

### Option 1: MinIO + MinIO Console
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Browser   │───▶│  MinIO Console  │───▶│  MinIO Storage  │
│                 │    │   (Port 9001)   │    │   (Port 9000)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │                         │
                              ▼                         ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   Web-Interface │    │   S3-API        │
                       │   Bucket Mgmt   │    │   File Storage  │
                       │   User Mgmt     │    │   Metadata      │
                       └─────────────────┘    └─────────────────┘
```

### Option 2: MinIO + FileBrowser
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Browser   │───▶│   FileBrowser   │───▶│  MinIO Storage  │
│                 │    │   (Port 80)     │    │   (Port 9000)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │                         │
                              ▼                         ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   File Manager  │    │   S3-API        │
                       │   Upload/Download│    │   File Storage  │
                       │   Simple UI     │    │   Metadata      │
                       └─────────────────┘    └─────────────────┘
```

## 🚀 Installation

### Voraussetzungen
- Kubernetes Cluster (k3s empfohlen)
- kubectl konfiguriert
- Storage Class (local-path empfohlen)

### Option 1: MinIO + MinIO Console
```bash
# Deployment starten
chmod +x deploy-minio-console.sh
./deploy-minio-console.sh
```

### Option 2: MinIO + FileBrowser
```bash
# Deployment starten
chmod +x deploy-minio-filebrowser.sh
./deploy-minio-filebrowser.sh
```

## 🌐 Zugriff

### MinIO + MinIO Console
- **Web-Interface**: http://192.168.1.101:30001
- **S3-API**: http://192.168.1.101:30000
- **Credentials**: admin / minio123

### MinIO + FileBrowser
- **Web-Interface**: http://192.168.1.101:30002
- **S3-API**: minio-service.storage.svc.cluster.local:9000
- **Credentials**: admin / admin (erste Anmeldung)

## 🔧 Konfiguration

### S3-API Zugriff
```bash
# AWS CLI Konfiguration
aws configure set aws_access_key_id admin
aws configure set aws_secret_access_key minio123
aws configure set default.region us-east-1

# MinIO Client
mc alias set minio http://192.168.1.101:30000 admin minio123
```

### S3-API Commands
```bash
# Bucket erstellen
aws s3 mb s3://my-bucket --endpoint-url http://192.168.1.101:30000

# Datei hochladen
aws s3 cp file.txt s3://my-bucket/ --endpoint-url http://192.168.1.101:30000

# Dateien auflisten
aws s3 ls s3://my-bucket/ --endpoint-url http://192.168.1.101:30000
```

## 📊 Monitoring

### Pod Status
```bash
kubectl get pods -n storage
kubectl get services -n storage
kubectl get pvc -n storage
```

### Logs
```bash
# MinIO Logs
kubectl logs -f deployment/minio -n storage

# FileBrowser Logs
kubectl logs -f deployment/filebrowser -n storage
```

## 🔒 Sicherheit

### Standard Credentials ändern
```bash
# MinIO Credentials
kubectl set env deployment/minio MINIO_ROOT_USER=newuser -n storage
kubectl set env deployment/minio MINIO_ROOT_PASSWORD=newpassword -n storage

# FileBrowser Credentials
# Nach erster Anmeldung über Web-Interface ändern
```

### TLS/SSL
```bash
# Ingress mit TLS konfigurieren
kubectl apply -f ingress-tls.yaml
```

## 🗂️ Storage Management

### Persistent Volumes
- **MinIO Data**: 100Gi (local-path)
- **FileBrowser Config**: 5Gi (local-path)

### Backup
```bash
# MinIO Data backup
kubectl exec -it deployment/minio -n storage -- mc mirror /data /backup

# PVC backup
kubectl create job --from=cronjob/backup-job backup-$(date +%Y%m%d)
```

## 🔄 Updates

### MinIO Update
```bash
kubectl set image deployment/minio minio=minio/minio:latest -n storage
```

### FileBrowser Update
```bash
kubectl set image deployment/filebrowser filebrowser=filebrowser/filebrowser:latest -n storage
```

## 🧹 Cleanup

### Deployment entfernen
```bash
# MinIO + Console
kubectl delete -f minio-deployment.yaml

# MinIO + FileBrowser
kubectl delete -f filebrowser-deployment.yaml

# Namespace löschen
kubectl delete namespace storage
```

## 🆚 Vergleich

| Feature | MinIO Console | FileBrowser |
|---------|---------------|-------------|
| **Interface** | Enterprise | Einfach |
| **Features** | Bucket Mgmt, Users | File Manager |
| **Komplexität** | Hoch | Niedrig |
| **S3-API** | ✅ | ✅ |
| **User Management** | ✅ | ❌ |
| **Bucket Management** | ✅ | ❌ |
| **Performance** | Hoch | Mittel |

## 🎯 Empfehlung

### Für Enterprise/Advanced:
- **MinIO + MinIO Console**
- Vollständige S3-API Features
- User und Bucket Management
- Enterprise-ready

### Für Einfachheit:
- **MinIO + FileBrowser**
- Einfaches File Management
- Weniger Features
- Einfache Wartung

## 🔗 Links

- [MinIO Documentation](https://docs.min.io/)
- [FileBrowser Documentation](https://filebrowser.org/)
- [S3 API Reference](https://docs.aws.amazon.com/s3/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## 📝 Changelog

- **v1.0**: Initial Release mit MinIO + Console
- **v1.1**: FileBrowser Option hinzugefügt
- **v1.2**: Nextcloud entfernt, Fokus auf S3-API