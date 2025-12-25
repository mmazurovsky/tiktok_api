# TikTok API Deployment Guide

## Overview
This project has been containerized using Docker and follows the same deployment pattern as the `linkedin_scraper_service` project.

## Files Created/Modified

### 1. Dockerfile
- Base image: `python:3.11-slim`
- Installs all dependencies from `requirements.txt`
- Runs uvicorn server on port 80
- Production-ready with timeout configurations

### 2. docker-compose.yml
- Service name: `tiktok_api`
- Exposed port: 8080 (configurable via `.env`)
- Persistent volumes for logs and downloads
- Network: `tiktok_api_network` (bridge mode)
- Platform: `linux/amd64` for compatibility

### 3. .env.example and .env
Environment variables for configuration:
- `MY_IMAGE`: Docker image name
- `HOST_PORT`: External port (default: 8080)
- `SENTRY_ENVIRONMENT`: Sentry environment
- `TZ`: Timezone configuration

## Quick Start

### Build and Run
```bash
# Build the Docker image
docker compose build

# Start the container
docker compose up -d

# Check logs
docker compose logs -f

# Stop the container
docker compose down
```

### Access the API
- API Documentation: http://localhost:8080/docs
- ReDoc Documentation: http://localhost:8080/redoc
- Web Interface: http://localhost:8080 (if PyWebIO is enabled)

## Configuration

### Port Configuration
To change the external port, edit `.env`:
```bash
HOST_PORT=8080  # Change to your desired port
```

### Volume Mounts
The following directories are mounted for persistence:
- `./logs` - Application logs
- `./download` - Downloaded files
- `./config.yaml` - API configuration

### Environment Variables
Edit `.env` to customize:
- `SENTRY_ENVIRONMENT`: Set to `development` or `production`
- `TZ`: Timezone (default: `Asia/Shanghai`)
- `PUID` and `PGID`: User and group IDs

## Deployment Workflow

### Development
```bash
docker compose up
```

### Production
```bash
# Build with specific image tag
MY_IMAGE=tiktok_api:v1.0.0 docker compose build

# Run in detached mode
docker compose up -d

# Monitor logs
docker compose logs -f
```

## Troubleshooting

### Check Container Status
```bash
docker compose ps
```

### View Logs
```bash
docker compose logs --tail=100 -f
```

### Restart Container
```bash
docker compose restart
```

### Rebuild from Scratch
```bash
docker compose down
docker compose build --no-cache
docker compose up -d
```

## Network Configuration

The service creates its own Docker network (`tiktok_api_network`). To connect other services:

```yaml
services:
  other_service:
    networks:
      - tiktok_api_network

networks:
  tiktok_api_network:
    external: true
```

## Comparison with linkedin_scraper_service

Both services now follow the same deployment pattern:
- ✅ Dockerfile with production-ready configuration
- ✅ docker-compose.yml with proper networking
- ✅ Environment variable configuration via `.env`
- ✅ Volume mounts for persistence
- ✅ Platform specification for compatibility
- ✅ Restart policy: `unless-stopped`

## Next Steps

1. Configure your `.env` file with appropriate values
2. Customize `config.yaml` for your API settings
3. Set up reverse proxy (nginx) if needed
4. Configure SSL/TLS certificates for HTTPS
5. Set up monitoring and alerting
