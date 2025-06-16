-- ==================================================
-- EVOLUTION API - SCHEMA COMPLETO PARA SUPABASE
-- ==================================================
-- Ejecutar este script en Supabase SQL Editor
-- Fecha: 06/06/2025
-- Versión: Evolution API v2.2.3

-- Crear enums
CREATE TYPE instance_connection_status AS ENUM ('open', 'close', 'connecting');
CREATE TYPE device_message AS ENUM ('ios', 'android', 'web', 'unknown', 'desktop');
CREATE TYPE session_status AS ENUM ('opened', 'closed', 'paused');
CREATE TYPE trigger_type AS ENUM ('all', 'keyword', 'none', 'advanced');
CREATE TYPE trigger_operator AS ENUM ('contains', 'equals', 'startsWith', 'endsWith', 'regex');
CREATE TYPE openai_bot_type AS ENUM ('assistant', 'chatCompletion');
CREATE TYPE dify_bot_type AS ENUM ('chatBot', 'textGenerator', 'agent', 'workflow');

-- Tabla principal: Instance
CREATE TABLE "Instance" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) UNIQUE NOT NULL,
    "connectionStatus" instance_connection_status DEFAULT 'open',
    "ownerJid" VARCHAR(100),
    "profileName" VARCHAR(100),
    "profilePicUrl" VARCHAR(500),
    integration VARCHAR(100),
    number VARCHAR(100),
    "businessId" VARCHAR(100),
    token VARCHAR(255),
    "clientName" VARCHAR(100),
    "disconnectionReasonCode" INTEGER,
    "disconnectionObject" JSONB,
    "disconnectionAt" TIMESTAMP,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Session
CREATE TABLE "Session" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "sessionId" TEXT UNIQUE NOT NULL,
    creds TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("sessionId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Chat
CREATE TABLE "Chat" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "remoteJid" VARCHAR(100) NOT NULL,
    name VARCHAR(100),
    labels JSONB,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    "unreadMessages" INTEGER DEFAULT 0,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Contact
CREATE TABLE "Contact" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "remoteJid" VARCHAR(100) NOT NULL,
    "pushName" VARCHAR(100),
    "profilePicUrl" VARCHAR(500),
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE,
    UNIQUE("remoteJid", "instanceId")
);

-- Message
CREATE TABLE "Message" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    key JSONB NOT NULL,
    "pushName" VARCHAR(100),
    participant VARCHAR(100),
    "messageType" VARCHAR(100) NOT NULL,
    message JSONB NOT NULL,
    "contextInfo" JSONB,
    source device_message NOT NULL,
    "messageTimestamp" INTEGER NOT NULL,
    "chatwootMessageId" INTEGER,
    "chatwootInboxId" INTEGER,
    "chatwootConversationId" INTEGER,
    "chatwootContactInboxSourceId" VARCHAR(100),
    "chatwootIsRead" BOOLEAN,
    "instanceId" TEXT NOT NULL,
    "webhookUrl" VARCHAR(500),
    status VARCHAR(30),
    "sessionId" TEXT,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- MessageUpdate
CREATE TABLE "MessageUpdate" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "keyId" VARCHAR(100) NOT NULL,
    "remoteJid" VARCHAR(100) NOT NULL,
    "fromMe" BOOLEAN NOT NULL,
    participant VARCHAR(100),
    "pollUpdates" JSONB,
    status VARCHAR(30) NOT NULL,
    "messageId" TEXT NOT NULL,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("messageId") REFERENCES "Message"(id) ON DELETE CASCADE,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Webhook
CREATE TABLE "Webhook" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    url VARCHAR(500) NOT NULL,
    headers JSONB,
    enabled BOOLEAN DEFAULT true,
    events JSONB,
    "webhookByEvents" BOOLEAN DEFAULT false,
    "webhookBase64" BOOLEAN DEFAULT false,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Chatwoot
CREATE TABLE "Chatwoot" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT true,
    "accountId" VARCHAR(100),
    token VARCHAR(100),
    url VARCHAR(500),
    "nameInbox" VARCHAR(100),
    "signMsg" BOOLEAN DEFAULT false,
    "signDelimiter" VARCHAR(100),
    number VARCHAR(100),
    "reopenConversation" BOOLEAN DEFAULT false,
    "conversationPending" BOOLEAN DEFAULT false,
    "mergeBrazilContacts" BOOLEAN DEFAULT false,
    "importContacts" BOOLEAN DEFAULT false,
    "importMessages" BOOLEAN DEFAULT false,
    "daysLimitImportMessages" INTEGER,
    organization VARCHAR(100),
    logo VARCHAR(500),
    "ignoreJids" JSONB,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Label
CREATE TABLE "Label" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "labelId" VARCHAR(100),
    name VARCHAR(100) NOT NULL,
    color VARCHAR(100) NOT NULL,
    "predefinedId" VARCHAR(100),
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE,
    UNIQUE("labelId", "instanceId")
);

-- Proxy
CREATE TABLE "Proxy" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT false,
    host VARCHAR(100) NOT NULL,
    port VARCHAR(100) NOT NULL,
    protocol VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Setting
CREATE TABLE "Setting" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "rejectCall" BOOLEAN DEFAULT false,
    "msgCall" VARCHAR(100),
    "groupsIgnore" BOOLEAN DEFAULT false,
    "alwaysOnline" BOOLEAN DEFAULT false,
    "readMessages" BOOLEAN DEFAULT false,
    "readStatus" BOOLEAN DEFAULT false,
    "syncFullHistory" BOOLEAN DEFAULT false,
    "wavoipToken" VARCHAR(100),
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Rabbitmq
CREATE TABLE "Rabbitmq" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT false,
    events JSONB NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Sqs
CREATE TABLE "Sqs" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT false,
    events JSONB NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Websocket
CREATE TABLE "Websocket" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT false,
    events JSONB NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Pusher
CREATE TABLE "Pusher" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT false,
    "appId" VARCHAR(100) NOT NULL,
    key VARCHAR(100) NOT NULL,
    secret VARCHAR(100) NOT NULL,
    cluster VARCHAR(100) NOT NULL,
    "useTLS" BOOLEAN DEFAULT false,
    events JSONB NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Typebot
CREATE TABLE "Typebot" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT true,
    description VARCHAR(255),
    url VARCHAR(500) NOT NULL,
    typebot VARCHAR(100) NOT NULL,
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "ignoreJids" JSONB,
    "triggerType" trigger_type,
    "triggerOperator" trigger_operator,
    "triggerValue" TEXT,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- TypebotSetting
CREATE TABLE "TypebotSetting" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "typebotIdFallback" VARCHAR(100),
    "ignoreJids" JSONB,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Media
CREATE TABLE "Media" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "fileName" VARCHAR(500) UNIQUE NOT NULL,
    type VARCHAR(100) NOT NULL,
    mimetype VARCHAR(100) NOT NULL,
    "createdAt" DATE DEFAULT CURRENT_DATE,
    "messageId" TEXT UNIQUE NOT NULL,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("messageId") REFERENCES "Message"(id) ON DELETE CASCADE,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- OpenaiCreds
CREATE TABLE "OpenaiCreds" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) UNIQUE,
    "apiKey" VARCHAR(255) UNIQUE,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- OpenaiBot
CREATE TABLE "OpenaiBot" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT true,
    description VARCHAR(255),
    "botType" openai_bot_type NOT NULL,
    "assistantId" VARCHAR(255),
    "functionUrl" VARCHAR(500),
    model VARCHAR(100),
    "systemMessages" JSONB,
    "assistantMessages" JSONB,
    "userMessages" JSONB,
    "maxTokens" INTEGER,
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "splitMessages" BOOLEAN DEFAULT false,
    "timePerChar" INTEGER DEFAULT 50,
    "ignoreJids" JSONB,
    "triggerType" trigger_type,
    "triggerOperator" trigger_operator,
    "triggerValue" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "openaiCredsId" TEXT NOT NULL,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("openaiCredsId") REFERENCES "OpenaiCreds"(id) ON DELETE CASCADE,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- IntegrationSession
CREATE TABLE "IntegrationSession" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "sessionId" VARCHAR(255) NOT NULL,
    "remoteJid" VARCHAR(100) NOT NULL,
    "pushName" TEXT,
    status session_status NOT NULL,
    "awaitUser" BOOLEAN DEFAULT false,
    context JSONB,
    type VARCHAR(100),
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    parameters JSONB,
    "botId" TEXT,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- OpenaiSetting
CREATE TABLE "OpenaiSetting" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "ignoreJids" JSONB,
    "splitMessages" BOOLEAN DEFAULT false,
    "timePerChar" INTEGER DEFAULT 50,
    "speechToText" BOOLEAN DEFAULT false,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "openaiCredsId" TEXT UNIQUE NOT NULL,
    "openaiIdFallback" VARCHAR(100),
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("openaiCredsId") REFERENCES "OpenaiCreds"(id),
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Template
CREATE TABLE "Template" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "templateId" VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) UNIQUE NOT NULL,
    template JSONB NOT NULL,
    "webhookUrl" VARCHAR(500),
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Dify
CREATE TABLE "Dify" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT true,
    description VARCHAR(255),
    "botType" dify_bot_type NOT NULL,
    "apiUrl" VARCHAR(255),
    "apiKey" VARCHAR(255),
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "ignoreJids" JSONB,
    "splitMessages" BOOLEAN DEFAULT false,
    "timePerChar" INTEGER DEFAULT 50,
    "triggerType" trigger_type,
    "triggerOperator" trigger_operator,
    "triggerValue" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- DifySetting
CREATE TABLE "DifySetting" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "ignoreJids" JSONB,
    "splitMessages" BOOLEAN DEFAULT false,
    "timePerChar" INTEGER DEFAULT 50,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "difyIdFallback" VARCHAR(100),
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- EvolutionBot
CREATE TABLE "EvolutionBot" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT true,
    description VARCHAR(255),
    "apiUrl" VARCHAR(255),
    "apiKey" VARCHAR(255),
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "ignoreJids" JSONB,
    "splitMessages" BOOLEAN DEFAULT false,
    "timePerChar" INTEGER DEFAULT 50,
    "triggerType" trigger_type,
    "triggerOperator" trigger_operator,
    "triggerValue" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- EvolutionBotSetting
CREATE TABLE "EvolutionBotSetting" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "ignoreJids" JSONB,
    "splitMessages" BOOLEAN DEFAULT false,
    "timePerChar" INTEGER DEFAULT 50,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "botIdFallback" VARCHAR(100),
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- Flowise
CREATE TABLE "Flowise" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    enabled BOOLEAN DEFAULT true,
    description VARCHAR(255),
    "apiUrl" VARCHAR(255),
    "apiKey" VARCHAR(255),
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "ignoreJids" JSONB,
    "splitMessages" BOOLEAN DEFAULT false,
    "timePerChar" INTEGER DEFAULT 50,
    "triggerType" trigger_type,
    "triggerOperator" trigger_operator,
    "triggerValue" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "instanceId" TEXT NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- FlowiseSetting
CREATE TABLE "FlowiseSetting" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    expire INTEGER DEFAULT 0,
    "keywordFinish" VARCHAR(100),
    "delayMessage" INTEGER,
    "unknownMessage" VARCHAR(100),
    "listeningFromMe" BOOLEAN DEFAULT false,
    "stopBotFromMe" BOOLEAN DEFAULT false,
    "keepOpen" BOOLEAN DEFAULT false,
    "debounceTime" INTEGER,
    "ignoreJids" JSONB,
    "splitMessages" BOOLEAN DEFAULT false,
    "timePerChar" INTEGER DEFAULT 50,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "flowiseIdFallback" VARCHAR(100),
    "instanceId" TEXT UNIQUE NOT NULL,
    FOREIGN KEY ("instanceId") REFERENCES "Instance"(id) ON DELETE CASCADE
);

-- IsOnWhatsapp
CREATE TABLE "IsOnWhatsapp" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "remoteJid" VARCHAR(100) UNIQUE NOT NULL,
    "jidOptions" TEXT NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==================================================
-- CREAR ÍNDICES PARA OPTIMIZACIÓN
-- ==================================================

CREATE INDEX idx_chat_instance ON "Chat"("instanceId");
CREATE INDEX idx_chat_remote ON "Chat"("remoteJid");
CREATE INDEX idx_contact_remote ON "Contact"("remoteJid");
CREATE INDEX idx_contact_instance ON "Contact"("instanceId");
CREATE INDEX idx_message_instance ON "Message"("instanceId");
CREATE INDEX idx_messageupdate_instance ON "MessageUpdate"("instanceId");
CREATE INDEX idx_messageupdate_message ON "MessageUpdate"("messageId");
CREATE INDEX idx_setting_instance ON "Setting"("instanceId");

-- ==================================================
-- AGREGAR FOREIGN KEYS ADICIONALES
-- ==================================================

-- Agregar foreign key para sessionId en Message
ALTER TABLE "Message" 
ADD CONSTRAINT fk_message_session 
FOREIGN KEY ("sessionId") REFERENCES "IntegrationSession"(id);

-- Agregar foreign key para fallback en OpenaiSetting
ALTER TABLE "OpenaiSetting"
ADD CONSTRAINT fk_openai_fallback
FOREIGN KEY ("openaiIdFallback") REFERENCES "OpenaiBot"(id);

-- ==================================================
-- SCRIPT COMPLETADO ✅
-- ==================================================
-- Ejecutar este script completo en Supabase SQL Editor
-- Todas las tablas de Evolution API creadas con:
-- - 30+ tablas principales
-- - 7 tipos enum
-- - Índices optimizados
-- - Foreign keys completas
-- - Soporte para JSONB
-- ==================================================