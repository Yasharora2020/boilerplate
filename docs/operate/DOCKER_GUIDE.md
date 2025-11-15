# Docker Configuration Guide

Complete guide to Docker setup, multi-platform builds, and containerization best practices.

## Overview

Docker containerizes your application for consistent deployment across environments. This boilerplate includes smart Dockerfiles that auto-detect Python package managers and support multi-platform builds.

## Templates

### Python Dockerfile

**Location:** `Dockerfile.python.example`

**Features:**
- Auto-detects `pyproject.toml` (uv) vs `requirements.txt` (pip)
- Multi-stage build for smaller images
- Non-root user for security
- Health checks

**Copy and customize:**
```bash
cp Dockerfile.python.example Dockerfile
```

**Typical modifications:**
- Port numbers (default 8000)
- Start command
- Dependencies
- Environment setup

### Next.js Dockerfile

**Location:** `Dockerfile.nextjs.example`

**Features:**
- Multi-stage build
- Standalone output optimization
- Health checks
- Non-root user

**Copy and customize:**
```bash
cp Dockerfile.nextjs.example Dockerfile
```

**Requirements:**
- Add `output: 'standalone'` to `next.config.js`

## Building Images

### Local Development

**Python:**
```bash
# Build image
docker build -t my-app:local .

# Run container
docker run -p 8000:8000 my-app:local

# Run with environment variables
docker run -p 8000:8000 \
  -e DATABASE_URL="postgresql://..." \
  -e SECRET_KEY="secret" \
  my-app:local
```

**Next.js:**
```bash
# Build image
docker build -t my-app:local .

# Run container
docker run -p 3000:3000 my-app:local

# Run with env vars
docker run -p 3000:3000 \
  -e NEXT_PUBLIC_API_URL="http://localhost:3000" \
  my-app:local
```

### Testing Locally

```bash
# Build and run
docker build -t test .
docker run test

# Check if it starts
docker run test /bin/sh -c "echo 'Container works!'"

# Interactive shell
docker run -it test /bin/sh
```

## Docker Compose

### Development Setup

**docker-compose.yml:**
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql://user:password@db:5432/myapp
      DEBUG: "true"
    depends_on:
      - db
    volumes:
      - .:/app  # Hot reload

  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Running with Compose

```bash
# Start services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down

# Remove volumes
docker-compose down -v
```

## Multi-Platform Builds

### Setup Buildx

```bash
# Create builder (once)
docker buildx create --name mybuilder
docker buildx use mybuilder

# Or use default buildx
docker buildx use default
```

### Build for Multiple Platforms

```bash
# Build for amd64 and arm64
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myimage:latest \
  .

# Push to registry
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ghcr.io/username/myapp:latest \
  --push \
  .
```

### In GitHub Actions

The release workflow already handles this automatically. Platforms are configured in `.github/workflows/release.yml`:

```yaml
platforms: linux/amd64,linux/arm64
```

To add arm/v7:
```yaml
platforms: linux/amd64,linux/arm64,linux/arm/v7
```

## Image Size Optimization

### Check Current Size

```bash
# See image layers and sizes
docker history my-app:local

# See final size
docker images | grep my-app
```

### Optimization Techniques

**1. Use smaller base images:**
```dockerfile
# ❌ Large
FROM python:3.11

# ✅ Smaller (Alpine)
FROM python:3.11-alpine
```

**2. Multi-stage build:**
```dockerfile
# Build stage
FROM python:3.11 as builder
COPY requirements.txt .
RUN pip install -r requirements.txt

# Runtime stage (smaller)
FROM python:3.11-alpine
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
```

**3. Combine RUN commands:**
```dockerfile
# ❌ Creates separate layers
RUN apt-get update
RUN apt-get install -y python3

# ✅ Single layer
RUN apt-get update && apt-get install -y python3
```

**4. Remove build dependencies:**
```dockerfile
# Remove apt cache after install
RUN apt-get update && \
    apt-get install -y python3 && \
    rm -rf /var/lib/apt/lists/*
```

## Security Best Practices

### Non-Root User

```dockerfile
# Create user for running app
RUN useradd -m appuser
USER appuser

# Safer than running as root
```

### Health Checks

```dockerfile
# Python
HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import requests; requests.get('http://localhost:8000/health')"

# Next.js
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/api/health || exit 1
```

### Minimal Layers

```dockerfile
# Keep Dockerfile short
# Each RUN/COPY creates a layer
# More layers = larger image
```

## Troubleshooting

### Build Fails with "not found"
```bash
# Check file exists
ls -la requirements.txt

# Check relative paths
ls docs/  # Current working directory is /app
```

### Port Binding Error
```bash
# Port already in use
lsof -i :8000

# Use different port
docker run -p 8001:8000 my-app

# Or kill existing container
docker stop my-app
```

### Container Exits Immediately
```bash
# Check logs
docker logs container-id

# Run with interactive terminal
docker run -it my-app /bin/bash

# Check if start command exists
docker inspect my-app | grep Cmd
```

### Out of Memory
```bash
# Set memory limit
docker run -m 1g my-app

# Check memory usage
docker stats
```

## Image Registry (GHCR)

### Login to GHCR

```bash
# Using GitHub token
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Or use personal access token
docker login ghcr.io
# Enter username and token when prompted
```

### Push Image Manually

```bash
# Build image
docker build -t my-app:1.0.0 .

# Tag for GHCR
docker tag my-app:1.0.0 ghcr.io/username/repo:1.0.0

# Push
docker push ghcr.io/username/repo:1.0.0
```

### Pull From GHCR

```bash
# Login first (see above)
docker login ghcr.io

# Pull image
docker pull ghcr.io/username/repo:latest

# Run
docker run ghcr.io/username/repo:latest
```

## Environment Variables in Docker

### Build Time vs Runtime

```dockerfile
# Build time (used during build)
ARG BUILD_VERSION=1.0.0
RUN echo "Building ${BUILD_VERSION}"

# Runtime (available in running container)
ENV DATABASE_URL=default-value
ENV DEBUG=false
```

### Pass Environment Variables

```bash
# Using -e flag
docker run -e DATABASE_URL="..." my-app

# Using .env file
docker run --env-file .env my-app

# Using docker-compose
docker-compose env:
  DATABASE_URL: postgresql://...
```

## Volumes and Persistence

### Types of Volumes

**Named volume (recommended for data):**
```bash
docker run -v mydata:/data my-app
```

**Bind mount (for development):**
```bash
docker run -v /local/path:/container/path my-app
```

**Temporary filesystem:**
```bash
docker run --tmpfs /tmp my-app
```

### Data Persistence

```bash
# Create named volume
docker volume create myapp-data

# Use volume
docker run -v myapp-data:/var/lib/myapp my-app

# List volumes
docker volume ls

# Inspect volume
docker volume inspect myapp-data

# Remove volume
docker volume rm myapp-data
```

## Useful Commands

```bash
# Build
docker build -t myimage:tag .

# Run
docker run -it myimage:tag

# View logs
docker logs container-id
docker logs -f container-id  # Follow

# Shell into running container
docker exec -it container-id /bin/bash

# View images
docker images

# View containers
docker ps
docker ps -a

# Remove image
docker rmi image-id

# Remove container
docker rm container-id

# Stop container
docker stop container-id

# View image details
docker inspect image-id

# View image layers
docker history image-id

# Check resource usage
docker stats
```

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Multi-platform builds](https://docs.docker.com/build/building/multi-platform/)
- [GHCR Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
