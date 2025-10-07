# GitHub Actions CI/CD Setup Guide

This guide explains how to set up and use the GitHub Actions workflows in this boilerplate.

## Table of Contents
- [Overview](#overview)
- [Initial Setup](#initial-setup)
- [Workflows Explained](#workflows-explained)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

## Overview

This boilerplate includes two main workflows:

1. **CI Pipeline** (`.github/workflows/ci.yml`)
   - Runs on push to `main` or `develop` branches
   - Runs on pull requests
   - Tests, builds, scans, and pushes images

2. **Release Pipeline** (`.github/workflows/release.yml`)
   - Runs when you push a version tag (e.g., `v1.0.0`)
   - Builds multi-platform images
   - Creates GitHub releases
   - Comprehensive security scanning

## Initial Setup

### Step 1: Choose Your Project Type

Copy the appropriate Dockerfile:

**For Python projects:**
```bash
cp Dockerfile.python.example Dockerfile
```

**For Next.js projects:**
```bash
cp Dockerfile.nextjs.example Dockerfile
```

### Step 2: Customize the Dockerfile

Edit `Dockerfile` to match your project:
- Update port numbers
- Add dependencies
- Configure start commands
- Adjust health checks

### Step 3: Update Workflow Test Commands

Edit `.github/workflows/ci.yml`:

**For Python:**
```yaml
- name: Run Python tests
  run: |
    pytest tests/
    # or: python -m unittest discover
```

**For Next.js:**
```yaml
- name: Run linting
  run: npm run lint

- name: Run Next.js tests
  run: npm test
```

### Step 4: Configure GitHub Container Registry

#### Enable GitHub Container Registry:
1. Go to your repository settings
2. Navigate to "Actions" → "General"
3. Under "Workflow permissions", select:
   - ✅ Read and write permissions
   - ✅ Allow GitHub Actions to create and approve pull requests

#### Make packages public (optional):
After first push, go to:
1. Your GitHub profile
2. "Packages" tab
3. Select your package
4. "Package settings" → Change visibility to "Public"

### Step 5: Create Branches

```bash
# Create develop branch if it doesn't exist
git checkout -b develop
git push origin develop

# Main branch should already exist
git checkout main
git push origin main
```

### Step 6: Set Up Branch Protection (Recommended)

1. Repository → Settings → Branches
2. Add rule for `main`:
   - ✅ Require pull request reviews
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date

## Workflows Explained

### CI Workflow (ci.yml)

**Triggers:**
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

**Jobs:**

1. **Test Job**
   - Sets up Python or Node.js
   - Installs dependencies
   - Runs tests and linting

2. **Build and Scan Job**
   - Builds Docker image
   - Runs Trivy security scanner
   - Uploads results to GitHub Security tab
   - Pushes image with branch tag (e.g., `develop`, `main`)

3. **Dependency Scan Job**
   - Scans for vulnerable dependencies
   - Reports to GitHub Security tab

**Image Tags Created:**
- `develop` - Latest from develop branch
- `main` - Latest from main branch
- `develop-sha-abc123f` - Specific commit from develop
- `main-sha-abc123f` - Specific commit from main

### Release Workflow (release.yml)

**Triggers:**
- Push of version tag (e.g., `v1.0.0`, `v2.1.3`)

**Jobs:**

1. **Build and Push Job**
   - Builds for multiple platforms (amd64, arm64)
   - Comprehensive security scanning
   - Generates SBOM (Software Bill of Materials)
   - Creates GitHub Release with:
     - Automated changelog
     - Docker pull commands
     - Security scan results
     - SBOM attachment

**Image Tags Created:**
For tag `v1.2.3`:
- `v1.2.3` - Exact version
- `1.2.3` - Without v prefix
- `1.2` - Minor version line
- `1` - Major version line
- `latest` - Latest stable

## Configuration

### Environment Variables in Workflows

Located at the top of each workflow file:

```yaml
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}
```

**IMAGE_NAME** automatically uses your repository name (username/repo).

### Customizing Security Scans

**Trivy Severity Levels:**

Edit the workflow files to adjust:
```yaml
severity: 'CRITICAL,HIGH,MEDIUM,LOW'
```

**Fail Build on Vulnerabilities:**

Add to Trivy scan:
```yaml
exit-code: '1'  # Fail if vulnerabilities found
```

### Adding More Platforms

Edit `release.yml`:
```yaml
platforms: linux/amd64,linux/arm64,linux/arm/v7
```

### Customizing Changelog

The release workflow auto-generates changelogs from git commits.

For better changelogs, use conventional commits:
```bash
git commit -m "feat: add user authentication"
git commit -m "fix: resolve login bug"
git commit -m "docs: update README"
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

## Usage

### Development Workflow

1. **Work on develop branch:**
```bash
git checkout develop
# Make changes
git add .
git commit -m "feat: add new feature"
git push origin develop
```
→ CI runs, image pushed as `develop`

2. **Test the image:**
```bash
docker pull ghcr.io/your-username/your-repo:develop
docker run ghcr.io/your-username/your-repo:develop
```

3. **When stable, merge to main:**
```bash
git checkout main
git merge develop
git push origin main
```
→ CI runs, image pushed as `main`

4. **Create release:**
```bash
git tag v1.0.0
git push origin v1.0.0
```
→ Release workflow runs, multi-platform images created

### Pull Request Workflow

1. **Create feature branch:**
```bash
git checkout -b feature/new-feature
# Make changes
git push origin feature/new-feature
```

2. **Open Pull Request** to `develop` or `main`
   - CI automatically runs tests
   - Build and security scan executed
   - No image pushed (PR only tests)

3. **After merge** to `develop` or `main`:
   - CI runs again
   - Image pushed with branch tag

### Production Release Workflow

1. **Ensure main is stable:**
```bash
git checkout main
git pull origin main
```

2. **Run final tests locally** (optional)

3. **Create and push tag:**
```bash
git tag -a v1.0.0 -m "Release 1.0.0: Initial production release"
git push origin v1.0.0
```

4. **Monitor workflow:**
   - Go to Actions tab
   - Watch Release workflow
   - Check for any errors

5. **Verify release:**
   - Check Releases tab for new release
   - Pull and test image:
```bash
docker pull ghcr.io/your-username/your-repo:v1.0.0
docker run ghcr.io/your-username/your-repo:v1.0.0
```

6. **Check security results:**
   - Repository → Security tab
   - View Trivy scan results

## Viewing Your Images

### Via GitHub Web Interface:
1. Go to your repository
2. Click "Packages" (right side)
3. View all versions and tags

### Via Docker CLI:
```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Pull image
docker pull ghcr.io/your-username/your-repo:latest

# List available tags
# (Use GitHub web interface or API)
```

### Using Images in Docker Compose:

```yaml
services:
  app:
    image: ghcr.io/your-username/your-repo:latest
    ports:
      - "8000:8000"
```

## Monitoring and Logs

### View Workflow Runs:
1. Repository → Actions tab
2. Select workflow run
3. Click on job to see logs

### View Security Results:
1. Repository → Security tab
2. "Dependabot alerts" for dependency issues
3. "Code scanning alerts" for vulnerability scans

### View Releases:
1. Repository → Releases tab
2. Each release shows:
   - Changelog
   - Docker pull commands
   - SBOM download
   - Available tags

## Troubleshooting

### Workflow Not Triggering

**Problem:** Pushed to branch but CI didn't run

**Solutions:**
- Check Actions tab → ensure workflows are enabled
- Verify branch name matches workflow trigger (`main`, `develop`)
- Check if workflows are disabled in repository settings

---

### Authentication Error Pushing to GHCR

**Problem:** `ERROR: failed to push: denied`

**Solutions:**
1. Check workflow permissions:
   - Settings → Actions → General
   - Enable "Read and write permissions"

2. Manually create token (if needed):
   - Settings → Developer settings → Personal access tokens
   - Create token with `write:packages` scope
   - Add as repository secret named `GHCR_TOKEN`
   - Update workflow to use secret

---

### Build Failing

**Problem:** Docker build fails in workflow

**Solutions:**
1. Test locally:
```bash
docker build -t test .
```

2. Check Dockerfile syntax
3. Verify all required files exist
4. Check workflow logs for specific error

---

### Trivy Scan Blocking Release

**Problem:** Security scan finds vulnerabilities

**Solutions:**
1. Update dependencies:
   - Python: Update `requirements.txt`
   - Node: Run `npm audit fix`

2. Review vulnerabilities:
   - Check Security tab
   - Assess severity
   - Update affected packages

3. Temporarily allow (not recommended):
   - Change `exit-code: '0'` in workflow

---

### Tag Not Creating Release

**Problem:** Pushed tag but release workflow didn't run

**Solutions:**
- Verify tag format: Must be `v*.*.*` (e.g., `v1.0.0`)
- Check tag was pushed: `git push origin v1.0.0`
- Check Actions tab for errors
- Ensure release.yml exists and is valid

---

### Image Not Pulling

**Problem:** `docker pull` fails with auth error

**Solutions:**
1. Login to GHCR:
```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

2. Make package public:
   - Profile → Packages → Select package
   - Settings → Change visibility

3. Use correct image name:
```bash
ghcr.io/username/repo:tag  # All lowercase
```

---

### Multi-platform Build Slow

**Problem:** Release takes too long

**Solutions:**
- Use Docker layer caching (already enabled)
- Reduce number of platforms if not needed
- Optimize Dockerfile:
  - Minimize layers
  - Use smaller base images
  - Order commands by change frequency

---

## Advanced Configuration

### Adding Secrets

For API keys, tokens, etc.:

1. Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add secret name and value

Use in workflow:
```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}
```

### Matrix Builds

Test multiple versions:

```yaml
jobs:
  test:
    strategy:
      matrix:
        python-version: [3.9, 3.10, 3.11]
        # or node-version: [18, 20, 22]
    steps:
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
```

### Conditional Steps

Run steps only on certain conditions:

```yaml
- name: Deploy to production
  if: github.ref == 'refs/heads/main'
  run: ./deploy.sh
```

### Caching Dependencies

Already configured, but here's how it works:

```yaml
- uses: actions/setup-python@v5
  with:
    cache: 'pip'  # Caches pip dependencies

- uses: actions/setup-node@v4
  with:
    cache: 'npm'  # Caches npm dependencies
```

### Running Workflows Manually

Add to workflow:

```yaml
on:
  workflow_dispatch:  # Enables manual trigger
```

Then: Actions tab → Select workflow → "Run workflow"

## Best Practices

1. **Keep workflows fast**
   - Run tests in parallel
   - Use caching
   - Fail fast (quick checks first)

2. **Secure your workflows**
   - Use specific action versions (`@v5`, not `@main`)
   - Review third-party actions
   - Use secrets for sensitive data
   - Scan for vulnerabilities

3. **Monitor your workflows**
   - Set up notifications for failures
   - Review security scan results
   - Check workflow run times

4. **Document customizations**
   - Comment workflow changes
   - Update this guide
   - Keep CHANGELOG.md

5. **Test before releasing**
   - Use develop branch
   - Test images before tagging
   - Review logs

## Next Steps

1. ✅ Complete initial setup above
2. ✅ Push to trigger first CI run
3. ✅ Create first release tag
4. 📖 Read [Versioning Guide](./VERSIONING_GUIDE.md)
5. 🚀 Start developing!

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
- [Trivy Scanner](https://github.com/aquasecurity/trivy)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
