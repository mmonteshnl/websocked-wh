# N8N Complete Project Setup

Complete N8N automation platform with Evolution API and PostgreSQL database.

## 🚀 Inicio Rápido (CONFIGURACIÓN GUARDADA ✅)

**¡La configuración ya está lista para funcionar automáticamente!**

### Opción 1: Inicio Automático (RECOMENDADO)
```bash
make start
# o
./start.sh
```

### Opción 2: Inicio Manual
```bash
make up
# o
docker-compose up -d
```

### Acceso a los Servicios
- **N8N**: http://localhost:8080 
  - Usuario: `admin`
  - Contraseña: `admin123`
- **Evolution API**: http://localhost:8081
- **PostgreSQL**: localhost:5432

> **✅ NOTA**: La configuración está completamente guardada y probada. No necesitas modificar ningún archivo para que funcione.

## 📋 Services

### N8N Automation Platform
- **Port**: 8080
- **Username**: admin (configurable in .env)
- **Password**: admin123 (configurable in .env)
- **Database**: PostgreSQL with persistent storage
- **Features**: Workflow automation, webhooks, API integrations

### Evolution API
- **Port**: 8081
- **API Key**: evolution_api_key_2024 (configurable in .env)
- **Purpose**: WhatsApp Business API integration

### PostgreSQL Database
- **Port**: 5432
- **Database**: n8ndb
- **User**: n8nuser
- **Purpose**: N8N data persistence

## 🛠️ Available Commands (Makefile)

```bash
make help          # Mostrar todos los comandos disponibles
make start         # Iniciar con configuración automática (RECOMENDADO)
make up            # Iniciar todos los servicios
make down          # Parar todos los servicios
make restart       # Reiniciar todos los servicios
make logs          # Mostrar logs de todos los servicios
make logs-n8n      # Mostrar logs solo de N8N
make status        # Mostrar estado de los servicios
make backup        # Respaldar base de datos PostgreSQL
make clean         # Eliminar contenedores y volúmenes (⚠️ borra datos)
```

## 💾 Configuración Guardada

**✅ TODO ESTÁ CONFIGURADO Y LISTO PARA USAR**

La configuración incluye:
- ✅ **Bases de datos**: N8N y Evolution API configuradas automáticamente
- ✅ **Usuarios y permisos**: Creados automáticamente al inicio
- ✅ **Variables de entorno**: Todas las configuraciones necesarias
- ✅ **Scripts de inicialización**: Setup automático de base de datos
- ✅ **Credenciales de acceso**: admin/admin123 para N8N

### Archivos de Configuración Guardados:
- `.env` - Variables de entorno principales
- `.env.example` - Plantilla con configuración completa
- `docker-compose.yml` - Orquestación de servicios
- `init-multi-db.sh` - Script de inicialización de BD
- `start.sh` - Script de inicio automático

## ⚙️ Configuration

All configuration is managed through the `.env` file:

### N8N Settings
- `N8N_BASIC_AUTH_USER`: Admin username
- `N8N_BASIC_AUTH_PASSWORD`: Admin password
- `GENERIC_TIMEZONE`: Your timezone
- `N8N_ENCRYPTION_KEY`: Encryption key for sensitive data

### Database Settings  
- `POSTGRES_DB`: Database name
- `POSTGRES_USER`: Database user
- `POSTGRES_PASSWORD`: Database password

### Evolution API Settings
- `EVOLUTION_API_KEY`: API authentication key

## 🔧 Management Commands

### View Logs
```bash
make logs           # All services
make logs-n8n       # N8N only
make logs-postgres  # Database only
```

### Database Operations
```bash
make backup                           # Create database backup
make restore FILE=backup_file.sql     # Restore from backup
make shell-postgres                   # Access database shell
```

### Container Access
```bash
make shell-n8n        # Access N8N container
make shell-postgres   # Access PostgreSQL container
make shell-evolution  # Access Evolution API container
```

## 📁 Project Structure

```
N8N/
├── docker-compose.yml    # Docker services configuration
├── .env                  # Environment variables
├── .env.example         # Environment template
├── Makefile            # Management commands
├── README-n8n.md      # This documentation
└── .gitignore          # Git ignore rules
```

## 🔒 Security Notes

- Change default passwords in `.env`
- Use strong encryption keys
- Keep `.env` file secure and never commit it
- Regularly backup your database
- Monitor logs for security issues

## 🐛 Troubleshooting

### Services won't start
```bash
make logs           # Check service logs
make status         # Check service status
```

### Database connection issues
```bash
make logs-postgres  # Check database logs
make shell-postgres # Access database directly
```

### Reset everything
```bash
make clean          # ⚠️ This deletes all data
make up             # Start fresh
```

## 📚 Next Steps

1. Configure your workflows in N8N
2. Set up Evolution API for WhatsApp integration
3. Create automated workflows between services
4. Monitor logs and performance
5. Set up regular database backups