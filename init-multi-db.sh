#!/bin/bash
set -e

echo "Initializing N8N Complete Project databases..."

# Create Evolution API database and user
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create Evolution API database
    CREATE DATABASE evolutiondb;
    
    -- Create Evolution API user
    CREATE USER evouser WITH ENCRYPTED PASSWORD 'evopass';
    
    -- Grant all privileges on database
    GRANT ALL PRIVILEGES ON DATABASE evolutiondb TO evouser;
    
    -- Connect to evolutiondb and grant schema permissions
    \c evolutiondb;
    
    -- Grant schema permissions for migrations
    GRANT ALL ON SCHEMA public TO evouser;
    GRANT CREATE ON SCHEMA public TO evouser;
    GRANT USAGE ON SCHEMA public TO evouser;
    
    -- Grant default privileges for future objects
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO evouser;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO evouser;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO evouser;
EOSQL

echo "✅ N8N Complete Project databases initialized successfully!"
echo "✅ Evolution API database: evolutiondb"
echo "✅ Evolution API user: evouser"
echo "✅ Schema permissions granted"