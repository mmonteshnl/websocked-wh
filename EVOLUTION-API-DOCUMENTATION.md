# 📱 Evolution API - Documentación Completa

## 🎯 Descripción del Proyecto

Evolution API es una solución completa para integrar WhatsApp Business en aplicaciones, proporcionando endpoints REST para enviar mensajes, gestionar instancias y automatizar conversaciones.

## 🏗️ Arquitectura del Sistema

### **Servicios Desplegados:**
- **Evolution API**: `http://localhost:8081`
- **N8N Automation**: `http://localhost:8080`
- **PostgreSQL Database**: `localhost:5432`
- **Redis Cache**: `localhost:6379`

### **Versión Actual:**
- Evolution API v2.2.3
- Manager Interface disponible en `/manager`

## 🔐 Configuración de Autenticación

### **API Key Authentication:**
```bash
Header: apikey: evolution_api_key_2024
Content-Type: application/json
```

### **Variables de Entorno:**
```bash
AUTHENTICATION_API_KEY=evolution_api_key_2024
AUTHENTICATION_TYPE=apikey
AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=true
```

## 📱 Gestión de Instancias WhatsApp

### **Instancias Activas:**

#### **Instancia Principal:**
- **Nombre**: `h`
- **Estado**: `open` (Conectada)
- **WhatsApp ID**: `50763116918@s.whatsapp.net`
- **Instance ID**: `237f6631-d9c5-4587-9698-a5f84f64ccc6`
- **Listo para enviar mensajes**: ✅

#### **Instancia de Prueba:**
- **Nombre**: `test_instance`
- **Estado**: `close` (Requiere conexión QR)
- **Instance ID**: `e4aa0861-0aec-40bc-a3c4-5b5c1660abf4`

## 🚀 API Endpoints - Guía de Uso

### **1. 📝 Enviar Mensaje de Texto**

```http
POST http://localhost:8081/message/sendText/{instance}
```

**Headers:**
```json
{
  "apikey": "evolution_api_key_2024",
  "Content-Type": "application/json"
}
```

**Body:**
```json
{
  "number": "50763116918",
  "text": "¡Hola desde Evolution API! 🚀"
}
```

**Ejemplo cURL:**
```bash
curl -X POST "http://localhost:8081/message/sendText/h" \
  -H "apikey: evolution_api_key_2024" \
  -H "Content-Type: application/json" \
  -d '{
    "number": "50763116918",
    "text": "¡Hola desde Evolution API!"
  }'
```

### **2. 🖼️ Enviar Mensaje con Imagen**

```http
POST http://localhost:8081/message/sendMedia/{instance}
```

**Body:**
```json
{
  "number": "50763116918",
  "mediatype": "image",
  "media": "https://picsum.photos/400/300",
  "caption": "Imagen enviada desde Evolution API 📸"
}
```

**Tipos de Media Soportados:**
- `image` - Imágenes (JPG, PNG, WEBP)
- `video` - Videos (MP4, AVI, MOV)
- `audio` - Audios (MP3, OGG, WAV)
- `document` - Documentos (PDF, DOC, XLS, etc.)

### **3. 🔘 Enviar Mensaje con Botones**

```http
POST http://localhost:8081/message/sendButtons/{instance}
```

**Body:**
```json
{
  "number": "50763116918",
  "title": "🎯 Selecciona una opción",
  "description": "Por favor, elige una de las siguientes opciones:",
  "buttons": [
    {
      "buttonId": "option1",
      "buttonText": {
        "displayText": "✅ Opción 1"
      },
      "type": "reply"
    },
    {
      "buttonId": "option2",
      "buttonText": {
        "displayText": "🚀 Opción 2"
      },
      "type": "reply"
    }
  ]
}
```

### **4. 📋 Enviar Lista de Opciones**

```http
POST http://localhost:8081/message/sendList/{instance}
```

**Body:**
```json
{
  "number": "50763116918",
  "title": "📋 Menú de Opciones",
  "description": "Selecciona una opción del menú:",
  "buttonText": "Ver Opciones",
  "footerText": "Evolution API Bot",
  "sections": [
    {
      "title": "🛍️ Productos",
      "rows": [
        {
          "rowId": "prod1",
          "title": "Producto 1",
          "description": "Descripción del producto 1"
        },
        {
          "rowId": "prod2",
          "title": "Producto 2", 
          "description": "Descripción del producto 2"
        }
      ]
    }
  ]
}
```

### **5. 📞 Enviar Mensaje de Contacto**

```http
POST http://localhost:8081/message/sendContact/{instance}
```

**Body:**
```json
{
  "number": "50763116918",
  "contact": {
    "fullName": "Juan Pérez",
    "wuid": "50712345678",
    "phoneNumber": "50712345678"
  }
}
```

### **6. 📍 Enviar Ubicación**

```http
POST http://localhost:8081/message/sendLocation/{instance}
```

**Body:**
```json
{
  "number": "50763116918",
  "latitude": 9.934739,
  "longitude": -84.087502,
  "name": "San José, Costa Rica",
  "address": "Centro de San José"
}
```

## 🔍 Endpoints de Consulta

### **Estado de Instancia**
```http
GET http://localhost:8081/instance/connectionState/{instance}
```

### **Listar Todas las Instancias**
```http
GET http://localhost:8081/instance/fetchInstances
```

### **Información de la Instancia**
```http
GET http://localhost:8081/instance/find/{instance}
```

### **Obtener QR Code**
```http
GET http://localhost:8081/instance/connect/{instance}
```

## 🎛️ Gestión de Instancias

### **Crear Nueva Instancia**
```http
POST http://localhost:8081/instance/create
```

**Body:**
```json
{
  "instanceName": "mi_bot_2024",
  "integration": "WHATSAPP-BAILEYS",
  "token": "mi_token_personalizado"
}
```

### **Eliminar Instancia**
```http
DELETE http://localhost:8081/instance/delete/{instance}
```

### **Reiniciar Instancia**
```http
PUT http://localhost:8081/instance/restart/{instance}
```

### **Desconectar Instancia**
```http
DELETE http://localhost:8081/instance/logout/{instance}
```

## 🔔 Configuración de Webhooks

### **Configurar Webhook**
```http
POST http://localhost:8081/webhook/set/{instance}
```

**Body:**
```json
{
  "webhook": {
    "enabled": true,
    "url": "https://tu-servidor.com/webhook",
    "webhookByEvents": true,
    "webhookBase64": false,
    "events": [
      "MESSAGES_UPSERT",
      "MESSAGES_UPDATE", 
      "CONNECTION_UPDATE",
      "PRESENCE_UPDATE",
      "CHATS_UPSERT"
    ]
  }
}
```

### **Obtener Configuración de Webhook**
```http
GET http://localhost:8081/webhook/find/{instance}
```

### **Eventos de Webhook Disponibles:**
- `MESSAGES_UPSERT` - Nuevos mensajes recibidos
- `MESSAGES_UPDATE` - Actualizaciones de estado de mensajes
- `CONNECTION_UPDATE` - Cambios en la conexión de la instancia
- `PRESENCE_UPDATE` - Actualizaciones de presencia (online/offline)
- `CHATS_UPSERT` - Nuevos chats creados
- `CONTACTS_UPSERT` - Nuevos contactos agregados
- `CONTACTS_UPDATE` - Actualizaciones de contactos

## 🗃️ Base de Datos

### **Esquema PostgreSQL:**
El sistema utiliza más de 30 tablas para gestión completa:

**Tablas Principales:**
- `Instance` - Gestión de instancias WhatsApp
- `Message` - Almacenamiento de todos los mensajes
- `Contact` - Información de contactos
- `Chat` - Datos de conversaciones
- `Webhook` - Configuraciones de webhooks
- `Setting` - Configuraciones de instancias
- `Media` - Gestión de archivos multimedia

### **Consultas de Base de Datos:**
```sql
-- Ver todas las instancias
SELECT * FROM "Instance";

-- Ver mensajes recientes
SELECT * FROM "Message" ORDER BY "createdAt" DESC LIMIT 10;

-- Ver contactos de una instancia
SELECT * FROM "Contact" WHERE "instanceId" = 'tu-instance-id';
```

## 🛠️ Comandos de Administración

### **Comandos Make:**
```bash
# Ver ayuda
make help

# Iniciar proyecto completo
make start

# Estado de servicios  
make status

# Ver logs de Evolution API
make logs-evolution

# Ver logs de N8N
make logs-n8n

# Ver logs de PostgreSQL
make logs-postgres

# Detener servicios
make down

# Reiniciar servicios
make restart

# Backup de base de datos
make backup

# Limpiar todo (⚠️ CUIDADO - Elimina datos)
make clean
```

### **Scripts Útiles:**
```bash
# Obtener QR Code
./get-qr.sh

# Inicializar múltiples bases de datos
./init-multi-db.sh

# Script de inicio personalizado
./start.sh
```

## 🔧 Configuración Avanzada

### **Variables de Entorno Importantes:**
```bash
# Servidor
SERVER_PORT=8080

# Base de datos
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://user:pass@localhost:5432/evolutiondb
DATABASE_ENABLED=true

# Redis
CACHE_REDIS_ENABLED=true
CACHE_REDIS_URI=redis://localhost:6379
CACHE_REDIS_PREFIX_KEY=evolution_v2

# CORS
CORS_ORIGIN=*
CORS_METHODS=POST,GET,PUT,DELETE
CORS_CREDENTIALS=true

# Límites
QRCODE_LIMIT=10
```

## 🔗 Integraciones Disponibles

### **Plataformas Compatibles:**
- **N8N** - Automatización de flujos de trabajo
- **Chatwoot** - Atención al cliente
- **OpenAI** - Integración con IA
- **Typebot** - Chatbots conversacionales
- **Dify** - Plataforma de IA conversacional
- **Flowise** - Workflows de LangChain
- **Make** (Integromat) - Automatización
- **Zapier** - Conectores de aplicaciones

### **Configuración de OpenAI:**
```json
{
  "openaiApiKey": "tu-api-key",
  "model": "gpt-3.5-turbo",
  "systemMessage": "Eres un asistente útil para WhatsApp",
  "maxTokens": 1000,
  "temperature": 0.7
}
```

## 🧪 Herramienta de Pruebas

### **HTML Tester Incluido:**
📁 **Archivo**: `evolution-api-tester.html`

**Características:**
- ✅ Interfaz web amigable
- ✅ Prueba de 3 tipos de mensajes
- ✅ Campos editables para personalización
- ✅ Respuestas en tiempo real
- ✅ Validación de campos
- ✅ Estados visuales (éxito/error)

**Uso:**
1. Abrir `evolution-api-tester.html` en el navegador
2. Configurar número de destino
3. Personalizar mensajes
4. Hacer clic en los botones para enviar

## 📊 Monitoreo y Logs

### **Logs en Tiempo Real:**
```bash
# Todos los servicios
docker-compose logs -f

# Solo Evolution API
docker-compose logs -f evolution-api

# Solo N8N
docker-compose logs -f n8n

# Solo PostgreSQL  
docker-compose logs -f postgres
```

### **Estado de Servicios:**
```bash
# Ver estado actual
docker-compose ps

# Estadísticas de uso
docker stats
```

## 🔒 Seguridad

### **Mejores Prácticas:**
- ✅ Cambiar API key por defecto
- ✅ Usar HTTPS en producción
- ✅ Configurar firewall apropiado
- ✅ Hacer backups regulares
- ✅ Monitorear logs de acceso
- ✅ Validar números de teléfono
- ✅ Implementar rate limiting

### **Configuración de Seguridad:**
```bash
# Generar nueva API key
AUTHENTICATION_API_KEY=$(openssl rand -hex 32)

# Configurar CORS específico
CORS_ORIGIN=https://tu-dominio.com

# Habilitar logs de seguridad
LOGGER_LEVEL=DEBUG
```

## 🚨 Troubleshooting

### **Problemas Comunes:**

#### **Error de Conexión:**
```bash
# Verificar servicios
make status

# Reiniciar servicios
make restart

# Ver logs de errores
make logs
```

#### **Instancia No Conecta:**
```bash
# Obtener nuevo QR
./get-qr.sh

# Verificar estado
curl -H "apikey: evolution_api_key_2024" \
  http://localhost:8081/instance/connectionState/h
```

#### **Base de Datos:**
```bash
# Verificar conexión PostgreSQL
docker exec -it n8n_postgres psql -U postgres -d evolutiondb -c "\dt"

# Backup de emergencia
make backup
```

## 📚 Recursos Adicionales

### **Documentación Oficial:**
- 🌐 **Sitio Web**: https://evolution-api.com
- 📖 **Documentación**: https://doc.evolution-api.com
- 🐙 **GitHub**: https://github.com/EvolutionAPI/evolution-api
- 💬 **Discord**: https://discord.gg/evolutionapi

### **APIs Relacionadas:**
- **WhatsApp Business API**: https://developers.facebook.com/docs/whatsapp
- **Baileys Library**: https://github.com/WhiskeySockets/Baileys
- **N8N Documentation**: https://docs.n8n.io

---

## ✨ Casos de Uso Prácticos

### **1. Bot de Atención al Cliente**
```javascript
// Respuesta automática a consultas
const autoResponse = {
  number: customerPhone,
  text: "¡Hola! Gracias por contactarnos. Un agente te atenderá pronto. 👋"
}
```

### **2. Notificaciones Automáticas**
```javascript
// Notificar eventos del sistema
const notification = {
  number: adminPhone,
  text: `🚨 Alerta: ${eventType} - ${eventMessage}`
}
```

### **3. Marketing Personalizado**
```javascript
// Envío masivo con personalización
customers.forEach(customer => {
  const message = {
    number: customer.phone,
    text: `¡Hola ${customer.name}! 🎉 Tenemos ofertas especiales para ti.`
  }
})
```

---

**🎯 Evolution API está listo para integrar WhatsApp en tus proyectos. ¡Comienza a automatizar conversaciones ahora!**

---

*Última actualización: Diciembre 2024*
*Versión: Evolution API v2.2.3*