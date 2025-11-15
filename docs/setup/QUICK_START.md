# Quick Start Guide

Get your boilerplate project running in minutes with automated CI/CD, Docker, and semantic versioning.

## Setup Options

### Option A: Use Setup Script (Recommended)

```bash
./scripts/setup.sh
```

The interactive script will:
- Help you choose between Python or Next.js
- Ask about package manager (uv vs pip for Python)
- Copy appropriate configuration files
- Provide next steps

### Option B: Manual Setup

#### 1. Choose Your Project Type

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

#### 2. Configure GitHub Actions

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

#### 3. Enable GitHub Permissions

1. Repository Settings → Actions → General
2. Workflow permissions: **Read and write permissions**
3. ✅ Allow GitHub Actions to create and approve pull requests

#### 4. Create Branches

```bash
git checkout -b develop
git push origin develop

git checkout main
git push origin main
```

#### 5. Start Developing

```bash
# Work on develop branch
git checkout develop
# Make changes...
git add .
git commit -m "feat: add new feature"
git push origin develop
```

→ CI automatically builds and pushes image tagged `develop`

#### 6. Create Your First Release

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

## What Was Created

### GitHub Actions Workflows
```
.github/workflows/
├── ci.yml          # Runs on push to main/develop
└── release.yml     # Runs on version tags (v*.*.*)
```

### Documentation
```
docs/
├── setup/          # Getting started guides
├── develop/        # Development standards
├── operate/        # Operations and CI/CD
└── release/        # Release and versioning
```

### Docker Templates
```
├── Dockerfile.python.example   # Python/FastAPI/Flask/Django
└── Dockerfile.nextjs.example   # Next.js applications
```

### Helper Files
```
├── .dockerignore                    # Files to exclude from builds
├── .gitignore                       # Files to exclude from git
├── pyproject.example.toml           # Python dependencies (uv)
├── requirements.example.txt         # Python dependencies (pip)
├── requirements-dev.example.txt     # Python dev dependencies (pip)
├── package.example.json             # Next.js dependencies
├── next.config.example.js           # Next.js config
└── CHANGELOG.example.md             # Changelog template
```

### Scripts
```
scripts/
├── setup.sh           # Interactive setup
└── create-release.sh  # Easy release creation
```

## What Happens When

### Push to `develop` or `main`
- ✅ Runs tests
- ✅ Builds Docker image
- ✅ Security scanning
- ✅ Pushes image with branch tag

**Image tags:**
- `develop` branch → `ghcr.io/you/repo:develop`
- `main` branch → `ghcr.io/you/repo:main`
- Any branch → `ghcr.io/you/repo:branch-sha-abc123f`

### Push version tag (v1.0.0)
- ✅ Multi-platform build (amd64, arm64)
- ✅ Comprehensive security scans
- ✅ Creates GitHub Release
- ✅ Generates changelog
- ✅ Pushes images: `v1.0.0`, `1.0`, `1`, `latest`

### Pull Request
- ✅ Runs tests
- ✅ Builds and scans
- ❌ No image push (test only)

## Available Images

Your images will be available at:
```
ghcr.io/YOUR_USERNAME/YOUR_REPO:latest    # Latest stable
ghcr.io/YOUR_USERNAME/YOUR_REPO:develop   # Latest dev
ghcr.io/YOUR_USERNAME/YOUR_REPO:v1.0.0    # Specific version
ghcr.io/YOUR_USERNAME/YOUR_REPO:1.0       # Minor version
ghcr.io/YOUR_USERNAME/YOUR_REPO:1         # Major version
```

## Using Your Images

### Docker
```bash
docker pull ghcr.io/your-username/your-repo:latest
docker run -p 8000:8000 ghcr.io/your-username/your-repo:latest
```

### Docker Compose
```yaml
services:
  app:
    image: ghcr.io/your-username/your-repo:latest
    ports:
      - "8000:8000"
```

### Kubernetes
```yaml
spec:
  containers:
  - name: app
    image: ghcr.io/your-username/your-repo:v1.0.0
```

## Versioning Quick Reference

| Change Type | Example | Version Change |
|------------|---------|----------------|
| Bug fix | Fix authentication | `v1.0.0` → `v1.0.1` |
| New feature | Add user profiles | `v1.0.0` → `v1.1.0` |
| Breaking change | Redesign API | `v1.0.0` → `v2.0.0` |

See [Versioning Guide](../release/VERSIONING_GUIDE.md) for detailed instructions.

## Monitoring

### View Workflows
```
Repository → Actions tab
```

### View Images
```
Repository → Packages (right sidebar)
Or: Profile → Packages
```

### View Releases
```
Repository → Releases tab
```

### View Security Scans
```
Repository → Security tab
```

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

## Best Practices

1. ✅ Use `develop` for active development
2. ✅ Keep `main` stable and production-ready
3. ✅ Test before creating releases
4. ✅ Write descriptive commit messages
5. ✅ Review security scan results
6. ✅ Document changes in commits
7. ✅ Use semantic versioning correctly

## Next Steps

Choose your tech stack and dive into development:

- **Python Developer?** → Read [Python Patterns Guide](../develop/PYTHON_PATTERNS.md)
- **Next.js Developer?** → Read [Next.js Patterns Guide](../develop/NEXTJS_PATTERNS.md)
- **Setting up CI/CD?** → Read [CI/CD Guide](../operate/CI_CD_GUIDE.md)
- **Ready to release?** → Read [Versioning Guide](../release/VERSIONING_GUIDE.md)

---

Happy coding! 🚀
