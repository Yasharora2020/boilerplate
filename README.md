# Project Boilerplate with CI/CD

A boilerplate template with GitHub Actions CI/CD, automated versioning, multi-platform Docker builds, claude commands,agents etc and security scanning.

> 📖 **New to this boilerplate?** Start with the [Quick Start Guide](docs/setup/QUICK_START.md) or the [Documentation Index](docs/INDEX.md).

## Features

- ✅ GitHub Actions CI/CD pipelines
- ✅ Multi-platform Docker builds (amd64, arm64)
- ✅ Automated security scanning with Trivy
- ✅ Semantic versioning with Git tags
- ✅ GitHub Container Registry (GHCR) integration
- ✅ Automated releases with changelogs
- ✅ SBOM (Software Bill of Materials) generation
- ✅ Support for Python (pip + uv) and Next.js projects
- ✅ Smart Dockerfile (auto-detects uv vs pip)

## Quick Links

### 🚀 Getting Started
- **[Quick Start Guide](docs/setup/QUICK_START.md)** - 5-minute setup
- **[Python Setup](docs/setup/PYTHON_SETUP.md)** - uv vs pip
- **[Documentation Index](docs/INDEX.md)** - Full documentation map

### 💻 Development
- **[Python Best Practices](docs/develop/PYTHON_PATTERNS.md)** - FastAPI patterns
- **[Next.js Best Practices](docs/develop/NEXTJS_PATTERNS.md)** - Next.js 15+
- **[Testing Guide](docs/develop/TESTING_GUIDE.md)** - Testing strategies

### 🔧 Operations
- **[CI/CD Setup Guide](docs/operate/CI_CD_GUIDE.md)** - GitHub Actions
- **[Docker Configuration](docs/operate/DOCKER_GUIDE.md)** - Docker setup
- **[Troubleshooting](docs/operate/TROUBLESHOOTING.md)** - Common issues

### 📦 Releases
- **[Versioning Guide](docs/release/VERSIONING_GUIDE.md)** - Creating releases
- **[Changelog Guide](docs/release/CHANGELOG_GUIDE.md)** - Maintaining changelog

## Quick Start

### Setup
```bash
./scripts/setup.sh
```

Or manually:
```bash
# For Python
cp Dockerfile.python.example Dockerfile
cp pyproject.example.toml pyproject.toml

# For Next.js
cp Dockerfile.nextjs.example Dockerfile
cp next.config.example.js next.config.js
```

### Develop
```bash
git checkout develop
git add .
git commit -m "feat: your feature"
git push origin develop
```
→ CI automatically builds and pushes `develop` image

### Release
```bash
git checkout main
git merge develop
git tag v1.0.0
git push origin v1.0.0
```
→ Release workflow builds multi-platform images and creates GitHub Release

See [Quick Start Guide](docs/setup/QUICK_START.md) for detailed instructions.

## Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| **CI** | Push to main/develop or PR | Build, test, scan, push images |
| **Release** | Version tag (v1.0.0) | Multi-platform build, create release |

Image tags: `develop`, `main`, `v1.0.0`, `1.0`, `1`, `latest`

See [CI/CD Guide](docs/operate/CI_CD_GUIDE.md) for full details.

## Tech Stack

- **CI/CD**: GitHub Actions
- **Containerization**: Docker + Buildx
- **Registry**: GitHub Container Registry (GHCR)
- **Security**: Trivy scanning + SBOM
- **Versioning**: Semantic Versioning (SemVer)
- **Python**: FastAPI + pytest + uv/pip
- **Next.js**: Next.js 15+ + React 19 + Zod

## Project Structure

```
docs/
├── setup/        # Getting started
├── develop/      # Development standards
├── operate/      # CI/CD & operations
└── release/      # Versioning & releases
```

All documentation is organized by workflow. See [Documentation Index](docs/INDEX.md).

## Common Commands

```bash
# Start developing
git checkout develop
git push origin develop

# Create release
git tag v1.0.0 && git push origin v1.0.0

# Pull images
docker pull ghcr.io/username/repo:latest
docker pull ghcr.io/username/repo:develop

# List versions
git tag
git describe --tags --abbrev=0

# Check workflows
gh run list
```

## Security

- 🔐 Trivy vulnerability scanning
- 📋 SBOM generation per release
- 🚫 Non-root container users
- 📦 Security headers in workflows

Results visible in: Repository → Security tab

## License

[Add your license here]

## Resources

- [Documentation Index](docs/INDEX.md) - Complete documentation map
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

**Ready to start?** 👉 [Quick Start Guide](docs/setup/QUICK_START.md)
