#!/bin/bash

# Script para obtener código QR de WhatsApp
echo "🔍 Obteniendo código QR para WhatsApp..."

API_KEY="evolution_api_key_2024"
INSTANCE_NAME="whatsapp_nuevo"

echo "📱 Verificando estado de la instancia..."
curl -X GET "http://localhost:8081/instance/connectionState/${INSTANCE_NAME}" \
  -H "apikey: ${API_KEY}" | jq '.'

echo ""
echo "📋 Listando todas las instancias..."
curl -X GET "http://localhost:8081/instance/fetchInstances" \
  -H "apikey: ${API_KEY}" | jq '.'

echo ""
echo "🔄 Intentando forzar conexión..."
curl -X GET "http://localhost:8081/instance/connect/${INSTANCE_NAME}" \
  -H "apikey: ${API_KEY}" | jq '.'

echo ""
echo "⏰ Esperando generación de QR..."
sleep 5

echo ""
echo "📱 Verificando nuevamente el estado..."
curl -X GET "http://localhost:8081/instance/connectionState/${INSTANCE_NAME}" \
  -H "apikey: ${API_KEY}" | jq '.'

echo ""
echo "🌐 Accede al manager en: http://localhost:8081/manager"
echo "🔑 API Key: ${API_KEY}"
echo "📱 Instancia: ${INSTANCE_NAME}"