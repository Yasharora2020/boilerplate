# Project Boilerplate with CI/CD

A production-ready boilerplate template with GitHub Actions CI/CD, automated versioning, multi-platform Docker builds, and security scanning.

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

## Quick Start

### Option A: Use Setup Script (Recommended)

```bash
./scripts/setup.sh
```

This interactive script will:
- Help you choose Python or Next.js
- Ask about package manager (uv vs pip for Python)
- Copy appropriate files
- Provide next steps

### Option B: Manual Setup

### 1. Choose Your Project Type

**For Python with uv (fast, modern):**
```bash
cp Dockerfile.python.example Dockerfile
cp pyproject.example.toml pyproject.toml
# Edit pyproject.toml and uncomment dependencies
```

**For Python with pip (traditional):**
```bash
cp Dockerfile.python.example Dockerfile
cp requirements.example.txt requirements.txt
# Edit requirements.txt and add dependencies
```

**For Next.js:**
```bash
cp Dockerfile.nextjs.example Dockerfile
# Edit Dockerfile and add to next.config.js: output: 'standalone'
```

### 2. Configure GitHub Actions

Edit `.github/workflows/ci.yml` to add your test commands:

**Python:**
```yaml
- name: Run Python tests
  run: pytest tests/
```

**Next.js:**
```yaml
- name: Run Next.js tests
  run: npm test
```

### 3. Enable GitHub Permissions

1. Repository Settings → Actions → General
2. Workflow permissions: **Read and write permissions**
3. ✅ Allow GitHub Actions to create and approve pull requests

### 4. Create Branches

```bash
git checkout -b develop
git push origin develop

git checkout main
git push origin main
```

### 5. Start Developing

```bash
# Work on develop branch
git checkout develop
# Make changes...
git add .
git commit -m "feat: add new feature"
git push origin develop
```

→ CI automatically builds and pushes image tagged `develop`

### 6. Create Your First Release

```bash
# When ready for production
git checkout main
git merge develop
git push origin main

# Tag the release
git tag v1.0.0
git push origin v1.0.0
```

→ Release workflow builds multi-platform images and creates GitHub Release

## Workflows

### CI Pipeline (`ci.yml`)
**Triggers:** Push to `main`/`develop`, Pull requests

**What it does:**
- Runs tests and linting
- Builds Docker image
- Security scanning (Trivy)
- Pushes image with branch tag

**Image tags:** `develop`, `main`, `develop-sha-abc123f`

### Release Pipeline (`release.yml`)
**Triggers:** Push version tag (e.g., `v1.0.0`)

**What it does:**
- Multi-platform builds (amd64, arm64)
- Comprehensive security scanning
- Generates SBOM
- Creates GitHub Release with changelog

**Image tags:** `v1.0.0`, `1.0.0`, `1.0`, `1`, `latest`

## Versioning

We use **Semantic Versioning**: `MAJOR.MINOR.PATCH`

| Version | When to Use | Example |
|---------|-------------|---------|
| MAJOR | Breaking changes | `v1.0.0` → `v2.0.0` |
| MINOR | New features (compatible) | `v1.0.0` → `v1.1.0` |
| PATCH | Bug fixes | `v1.0.0` → `v1.0.1` |

**Creating a release:**
```bash
git tag v1.0.0 -m "Release 1.0.0: Initial release"
git push origin v1.0.0
```

## Using Your Images

### Pull from GHCR:
```bash
# Latest stable
docker pull ghcr.io/your-username/your-repo:latest

# Specific version
docker pull ghcr.io/your-username/your-repo:v1.0.0

# Development
docker pull ghcr.io/your-username/your-repo:develop
```

### Docker Compose:
```yaml
services:
  app:
    image: ghcr.io/your-username/your-repo:latest
    ports:
      - "8000:8000"
```

### Kubernetes:
```yaml
spec:
  containers:
  - name: app
    image: ghcr.io/your-username/your-repo:v1.0.0
```

## Project Structure

```
.
├── .github/
│   └── workflows/
│       ├── ci.yml              # CI pipeline
│       └── release.yml         # Release pipeline
├── docs/
│   ├── GITHUB_ACTIONS_SETUP.md # Detailed setup guide
│   └── VERSIONING_GUIDE.md     # Versioning guide
├── Dockerfile.python.example   # Python Dockerfile template
├── Dockerfile.nextjs.example   # Next.js Dockerfile template
└── README.md                   # This file
```

## Documentation

- **[GitHub Actions Setup Guide](./docs/GITHUB_ACTIONS_SETUP.md)** - Complete CI/CD setup
- **[Versioning Guide](./docs/VERSIONING_GUIDE.md)** - How to version your releases
- **[Python Setup Guide](./docs/PYTHON_SETUP.md)** - Using uv vs pip for Python projects

## Common Commands

### Development
```bash
# Work on feature
git checkout develop
git pull origin develop

# Make changes
git add .
git commit -m "feat: add new feature"
git push origin develop
```

### Create Release
```bash
# Merge to main
git checkout main
git merge develop
git push origin main

# Tag version
git tag v1.0.0
git push origin v1.0.0
```

### View Versions
```bash
# List all tags
git tag

# Show latest tag
git describe --tags --abbrev=0
```

### Check Workflow Status
```bash
# Via GitHub CLI
gh run list

# Or visit: https://github.com/your-username/your-repo/actions
```

## Security Features

- **Trivy Scanning**: Scans for vulnerabilities in images and dependencies
- **SARIF Upload**: Results visible in Security tab
- **SBOM Generation**: Software Bill of Materials for each release
- **Non-root User**: Docker images run as non-root user
- **Multi-stage Builds**: Smaller, more secure images

View security results:
1. Repository → Security tab
2. Code scanning alerts

## Monitoring

### View Workflow Runs
- Repository → Actions tab

### View Images
- Repository → Packages (right sidebar)
- Or: Profile → Packages

### View Releases
- Repository → Releases tab

## Customization

### Add Environment Variables
Repository → Settings → Secrets and variables → Actions

```yaml
# In workflow file
env:
  API_KEY: ${{ secrets.API_KEY }}
```

### Change Platforms
Edit `release.yml`:
```yaml
platforms: linux/amd64,linux/arm64,linux/arm/v7
```

### Adjust Security Scanning
Edit severity levels in workflows:
```yaml
severity: 'CRITICAL,HIGH,MEDIUM,LOW'
```

## Troubleshooting

### CI Not Running
- Check Actions tab → Ensure workflows enabled
- Verify branch names match triggers (`main`, `develop`)
- Check workflow permissions in settings

### Authentication Errors
- Settings → Actions → General
- Enable "Read and write permissions"

### Build Failures
- Test locally: `docker build -t test .`
- Check workflow logs for specific errors
- Verify all files exist

### Image Not Found
- Make package public: Profile → Packages → Settings
- Or login: `docker login ghcr.io -u USERNAME`

## Best Practices

1. ✅ Use `develop` for active development
2. ✅ Keep `main` stable and production-ready
3. ✅ Test before creating releases
4. ✅ Write descriptive commit messages
5. ✅ Review security scan results
6. ✅ Document changes in commits
7. ✅ Use semantic versioning correctly

## Example Workflow

```bash
# 1. Create feature branch
git checkout -b feature/new-feature

# 2. Make changes and test
git add .
git commit -m "feat: implement user authentication"

# 3. Push and create PR to develop
git push origin feature/new-feature
# Create PR on GitHub

# 4. After PR approval, merge to develop
# CI builds and tests automatically

# 5. When ready for release
git checkout main
git merge develop
git push origin main

# 6. Create release
git tag v1.0.0 -m "Release 1.0.0: Add user authentication"
git push origin v1.0.0

# 7. Monitor release workflow in Actions tab
# 8. Check Releases tab for published release
```

## Tech Stack

- **CI/CD**: GitHub Actions
- **Container Registry**: GitHub Container Registry (GHCR)
- **Security Scanning**: Trivy (Aqua Security)
- **Multi-platform Builds**: Docker Buildx with QEMU
- **Versioning**: Semantic Versioning (SemVer)
- **SBOM Format**: CycloneDX

## Contributing

When contributing to this boilerplate:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

[Add your license here]

## Support

- 📖 [GitHub Actions Setup Guide](./docs/GITHUB_ACTIONS_SETUP.md)
- 📖 [Versioning Guide](./docs/VERSIONING_GUIDE.md)
- 🐛 [Report Issues](https://github.com/your-username/your-repo/issues)
- 💬 [Discussions](https://github.com/your-username/your-repo/discussions)

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**Ready to start?** Follow the [Quick Start](#quick-start) guide above!
