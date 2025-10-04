# 🚀 Nextcloud NAS mit Web-GUI für Kubernetes

Eine komplette Nextcloud NAS-Lösung mit Web-Interface für Ihr Kubernetes Cluster!

## 📋 Was Sie bekommen

### 🎯 Nextcloud (Vollständige NAS-Lösung)
- ✅ **Web-GUI** - Benutzerfreundliche Oberfläche
- ✅ **File Management** - Dateien hochladen, herunterladen, verwalten
- ✅ **User Management** - Mehrere Benutzer
- ✅ **Mobile Apps** - iOS/Android Apps verfügbar
- ✅ **Desktop Apps** - Windows/Mac/Linux Apps
- ✅ **Calendar & Contacts** - Vollständige PIM-Funktionen
- ✅ **Notes & Tasks** - Produktivitäts-Tools
- ✅ **File Sharing** - Links teilen
- ✅ **Backup & Sync** - Automatische Synchronisation
- ✅ **Plugin System** - Erweiterbare Funktionalität
- ✅ **Shared PostgreSQL** - Zentrale Datenbank für alle Projekte

## 🏗️ Architektur

```
Kubernetes Cluster
├── shared-services Namespace
│   ├── PostgreSQL (Shared Database für alle Projekte)
│   │   ├── nextcloud
│   │   ├── azure_b2c_booking
│   │   ├── ecommerce_system
│   │   ├── crm_system
│   │   ├── analytics
│   │   └── dev_tools
│   └── Nextcloud (Vollständige NAS)
└── Persistent Storage
    ├── Nextcloud Data (100Gi)
    ├── Nextcloud Config (5Gi)
    ├── Nextcloud Apps (10Gi)
    └── PostgreSQL Shared (50Gi)
```

## 🚀 Installation

### 1. Automatische Installation
```bash
# Script ausführen
./deploy-nas.sh
```

### 2. Manuelle Installation
```bash
# Namespace erstellen
kubectl create namespace shared-services

# Shared PostgreSQL für alle Projekte
kubectl apply -f postgres-nextcloud.yaml

# Nextcloud PVCs
kubectl apply -f nextcloud-pvcs.yaml

# Nextcloud Deployment
kubectl apply -f nextcloud-deployment.yaml
```

## 🌐 Zugriff

### Nextcloud (Vollständige NAS)
```bash
# Web Interface
http://192.168.1.101:<NodePort>
http://192.168.1.110:<NodePort>

# Admin Login
Username: admin
Password: admin_secure_password_123
```


### Port Forwarding (Alternative)
```bash
# Nextcloud
kubectl port-forward service/nextcloud-service 8080:80 -n shared-services
# Dann: http://localhost:8080
```

## 📊 Monitoring

### Pod Status prüfen
```bash
kubectl get pods -n shared-services
```

### PVC Status prüfen
```bash
kubectl get pvc -n shared-services
```

### Services prüfen
```bash
kubectl get services -n shared-services
```

### Logs anzeigen
```bash
# Nextcloud Logs
kubectl logs -f deployment/nextcloud -n shared-services

# PostgreSQL Logs
kubectl logs -f deployment/postgres-shared -n shared-services
```

## 🔧 Konfiguration

### Resource Limits
```yaml
# Nextcloud
resources:
  requests:
    memory: "512Mi"
    cpu: "300m"
  limits:
    memory: "1Gi"
    cpu: "1000m"

# PostgreSQL (Shared)
resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "2Gi"
    cpu: "1000m"
```

### Storage
```yaml
# Nextcloud Data
storage: 100Gi

# Nextcloud Config
storage: 5Gi

# Nextcloud Apps
storage: 10Gi

# PostgreSQL Shared (für alle Projekte)
storage: 50Gi
```

## 🎯 Features

### Nextcloud Features
- 📁 **File Management** - Vollständige Dateiverwaltung
- 👥 **User Management** - Mehrere Benutzer
- 📱 **Mobile Apps** - iOS/Android
- 💻 **Desktop Apps** - Windows/Mac/Linux
- 📅 **Calendar** - Terminverwaltung
- 📞 **Contacts** - Kontaktverwaltung
- 📝 **Notes** - Notizen
- ✅ **Tasks** - Aufgabenverwaltung
- 🔗 **File Sharing** - Dateien teilen
- 🔄 **Sync** - Automatische Synchronisation
- 🔌 **Plugins** - Erweiterbare Funktionalität

### Shared PostgreSQL Features
- 🗄️ **Multi-Database** - Separate Datenbanken für alle Projekte
- 📊 **Performance Optimized** - Optimierte Einstellungen
- 🔍 **Monitoring Ready** - pg_stat_statements aktiviert
- 🔄 **Backup Ready** - Einfache Backup-Strategien
- 🚀 **Scalable** - Für alle zukünftigen Projekte

## 🛠️ Wartung

### Backup
```bash
# PostgreSQL Backup (alle Datenbanken)
kubectl exec -it deployment/postgres-shared -n shared-services -- pg_dumpall -U postgres > all_databases_backup.sql

# Einzelne Datenbank Backup
kubectl exec -it deployment/postgres-shared -n shared-services -- pg_dump -U postgres nextcloud > nextcloud_backup.sql
kubectl exec -it deployment/postgres-shared -n shared-services -- pg_dump -U postgres azure_b2c_booking > azure_b2c_backup.sql

# PVC Backup (Snapshots)
kubectl create -f pvc-snapshot.yaml
```

### Updates
```bash
# Nextcloud Update
kubectl set image deployment/nextcloud nextcloud=nextcloud:latest -n shared-services

# PostgreSQL Update
kubectl set image deployment/postgres-shared postgres=postgres:15-alpine -n shared-services
```

### Scaling
```bash
# Nextcloud Scaling (nicht empfohlen für NAS)
kubectl scale deployment nextcloud --replicas=2 -n shared-services

# PostgreSQL Scaling (nicht empfohlen - Single Instance)
# Für High Availability: PostgreSQL Cluster mit Patroni
```

## 🎉 Fertig!

Ihre Nextcloud NAS mit Web-GUI ist jetzt bereit! 

**Was Sie haben:**
- 🎯 **Nextcloud** - Vollständige NAS-Funktionalität
- 🗄️ **Shared PostgreSQL** - Zentrale Datenbank für alle Projekte
- 📱 **Mobile Apps** - iOS/Android Support
- 💻 **Desktop Apps** - Windows/Mac/Linux Support
- 🔄 **Backup & Sync** - Automatische Synchronisation

**Viel Spaß mit Ihrer neuen Nextcloud NAS!** 🚀
