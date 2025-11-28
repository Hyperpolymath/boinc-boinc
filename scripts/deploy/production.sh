#!/usr/bin/env bash
set -euo pipefail

# Oblibeny BOINC Production Deployment Script

echo "==================================="
echo "Oblibeny BOINC Production Deployment"
echo "==================================="
echo ""

# Check prerequisites
command -v podman >/dev/null 2>&1 || { echo "Error: podman is required but not installed"; exit 1; }
command -v podman-compose >/dev/null 2>&1 || { echo "Error: podman-compose is required but not installed"; exit 1; }

# Configuration
DEPLOY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$DEPLOY_DIR"

# Load environment variables
if [ -f ".env.production" ]; then
    echo "Loading production environment..."
    export $(grep -v '^#' .env.production | xargs)
else
    echo "Warning: .env.production not found, using defaults"
fi

# Build containers
echo ""
echo "Step 1/5: Building containers..."
cd deployment/podman
podman-compose build

# Initialize database
echo ""
echo "Step 2/5: Starting ArangoDB..."
podman-compose up -d arangodb
sleep 10 # Wait for ArangoDB to be ready

echo "Initializing database schema..."
podman exec oblibeny-arangodb arangosh \
    --server.endpoint http+tcp://127.0.0.1:8529 \
    --server.username root \
    --server.password "${ARANGO_PASSWORD:-oblibeny_secure_password}" \
    --javascript.execute /docker-entrypoint-initdb.d/init-db.js

# Start all services
echo ""
echo "Step 3/5: Starting all services..."
podman-compose up -d

# Wait for services to be ready
echo ""
echo "Step 4/5: Waiting for services to be ready..."
sleep 15

# Health checks
echo ""
echo "Step 5/5: Running health checks..."

check_service() {
    local name=$1
    local url=$2

    echo -n "Checking $name... "
    if curl -f -s "$url" > /dev/null; then
        echo "✓ OK"
        return 0
    else
        echo "✗ FAILED"
        return 1
    fi
}

check_service "ArangoDB" "http://localhost:8529/_api/version"
check_service "Coordinator" "http://localhost:4000/health"
check_service "Prometheus" "http://localhost:9090/-/healthy"
check_service "Grafana" "http://localhost:3000/api/health"

echo ""
echo "==================================="
echo "Deployment Complete!"
echo "==================================="
echo ""
echo "Services:"
echo "  ArangoDB UI:  http://localhost:8529"
echo "  Coordinator:  http://localhost:4000"
echo "  Prometheus:   http://localhost:9090"
echo "  Grafana:      http://localhost:3000"
echo ""
echo "Next steps:"
echo "  1. Check logs: podman-compose logs -f"
echo "  2. Monitor metrics: http://localhost:3000"
echo "  3. Generate work: curl http://localhost:4000/api/work/generate"
echo ""
