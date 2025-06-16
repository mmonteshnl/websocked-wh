#!/bin/bash

# N8N Complete Project - Script de Inicio Automático
# ===================================================

echo "🚀 Iniciando N8N Complete Project..."
echo ""

# Verificar si Docker está ejecutándose
if ! docker info >/dev/null 2>&1; then
    echo "❌ Error: Docker no está ejecutándose"
    echo "   Por favor, inicia Docker Desktop y vuelve a intentar"
    exit 1
fi

# Verificar si existe el archivo .env
if [ ! -f ".env" ]; then
    echo "📋 Copiando configuración desde .env.example..."
    cp .env.example .env
    echo "✅ Archivo .env creado"
fi

echo "🐳 Iniciando servicios con Docker Compose..."
docker-compose up -d

echo ""
echo "⏳ Esperando que los servicios estén listos..."
sleep 15

echo ""
echo "📊 Estado de los servicios:"
docker-compose ps

echo ""
echo "🎉 ¡N8N Complete Project iniciado exitosamente!"
echo ""
echo "📱 Acceso a los servicios:"
echo "   • N8N Automation: http://localhost:8080"
echo "     Usuario: admin"
echo "     Contraseña: admin123"
echo ""
echo "   • Evolution API: http://localhost:8081"
echo "   • PostgreSQL: localhost:5432"
echo ""
echo "💡 Comandos útiles:"
echo "   • Ver logs: make logs"
echo "   • Parar servicios: make down"
echo "   • Reiniciar: make restart"
echo "   • Estado: make status"
echo ""