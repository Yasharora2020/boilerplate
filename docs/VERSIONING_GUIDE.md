# Versioning Guide

This guide explains how to version your application using semantic versioning and Git tags.

## Table of Contents
- [Quick Start](#quick-start)
- [Understanding Versions](#understanding-versions)
- [Creating a Release](#creating-a-release)
- [Version Decision Tree](#version-decision-tree)
- [Docker Image Tags](#docker-image-tags)
- [Common Scenarios](#common-scenarios)

## Quick Start

### First Release
```bash
git checkout main
git pull origin main
git tag v1.0.0
git push origin v1.0.0
```

### Subsequent Releases
1. Decide version number (see [Version Decision Tree](#version-decision-tree))
2. Create and push tag:
```bash
git tag v1.x.x
git push origin v1.x.x
```

## Understanding Versions

We use **Semantic Versioning** (SemVer): `MAJOR.MINOR.PATCH`

### Format: `v1.2.3`

- **MAJOR (1.x.x)** - Breaking changes
  - API changes that break existing functionality
  - Database schema changes requiring migration
  - Removal of deprecated features
  - Example: `v1.0.0` → `v2.0.0`

- **MINOR (x.2.x)** - New features (backwards compatible)
  - New API endpoints
  - New features added
  - Performance improvements
  - Example: `v1.0.0` → `v1.1.0`

- **PATCH (x.x.3)** - Bug fixes
  - Security patches
  - Bug fixes
  - Documentation updates
  - Example: `v1.0.0` → `v1.0.1`

## Creating a Release

### Step 1: Ensure your code is on main branch
```bash
git checkout main
git pull origin main
```

### Step 2: Determine the version number
See [Version Decision Tree](#version-decision-tree) below.

### Step 3: Create the tag
```bash
# Create annotated tag with message
git tag -a v1.0.0 -m "Release version 1.0.0: Initial release"

# Or simple tag
git tag v1.0.0
```

### Step 4: Push the tag
```bash
git push origin v1.0.0
```

### Step 5: GitHub Actions takes over
- Builds multi-platform Docker image (amd64, arm64)
- Runs security scans
- Pushes to GitHub Container Registry
- Creates GitHub Release with changelog
- Generates SBOM (Software Bill of Materials)

## Version Decision Tree

```
Did I make changes?
├─ YES → What kind of changes?
│  ├─ Bug fixes only
│  │  └─ Increment PATCH: v1.0.0 → v1.0.1
│  │
│  ├─ New features (nothing breaks)
│  │  └─ Increment MINOR: v1.0.0 → v1.1.0
│  │
│  └─ Breaking changes
│     └─ Increment MAJOR: v1.0.0 → v2.0.0
│
└─ NO → Don't create a new version
```

### Quick Examples

| Current | Change | New Version |
|---------|--------|-------------|
| v1.0.0 | Fixed login bug | v1.0.1 |
| v1.0.1 | Added user profiles | v1.1.0 |
| v1.1.0 | Security patch | v1.1.1 |
| v1.1.1 | Changed API format | v2.0.0 |
| v2.0.0 | Added export feature | v2.1.0 |

## Docker Image Tags

When you push tag `v1.2.3`, GitHub Actions creates multiple Docker tags:

```
ghcr.io/your-username/your-repo:v1.2.3    # Exact version
ghcr.io/your-username/your-repo:1.2.3     # Without 'v' prefix
ghcr.io/your-username/your-repo:1.2       # Minor version
ghcr.io/your-username/your-repo:1         # Major version
ghcr.io/your-username/your-repo:latest    # Latest stable
```

### Branch-based tags (from CI workflow):
```
ghcr.io/your-username/your-repo:main      # Latest from main
ghcr.io/your-username/your-repo:develop   # Latest from develop
ghcr.io/your-username/your-repo:develop-sha-abc123f  # Specific commit
```

## Common Scenarios

### Scenario 1: First Release

**Situation**: You've built your app and it's ready for production.

```bash
# Make sure you're on main
git checkout main
git pull origin main

# Create first release
git tag v1.0.0 -m "Initial release"
git push origin v1.0.0
```

**Result**:
- Image available as `v1.0.0`, `1.0`, `1`, `latest`
- GitHub Release created automatically

---

### Scenario 2: Bug Fix

**Situation**: Critical bug in production (v1.0.0).

```bash
# Fix the bug in your code, commit, merge to main
git checkout main
git pull origin main

# Create patch release
git tag v1.0.1 -m "Fix critical authentication bug"
git push origin v1.0.1
```

**Result**:
- Image available as `v1.0.1`, `1.0`, `1`, `latest`
- Users on `1` or `latest` get the fix automatically

---

### Scenario 3: New Feature

**Situation**: Added payment integration (v1.0.1 current).

```bash
# Feature is merged to main
git checkout main
git pull origin main

# Create minor release
git tag v1.1.0 -m "Add payment integration"
git push origin v1.1.0
```

**Result**:
- Image available as `v1.1.0`, `1.1`, `1`, `latest`
- Tag `1.0` still points to `v1.0.1` for users who want to stay on that line

---

### Scenario 4: Breaking Change

**Situation**: Redesigned API (v1.5.2 current).

```bash
git checkout main
git pull origin main

# Create major release
git tag v2.0.0 -m "API redesign - Breaking changes"
git push origin v2.0.0
```

**Result**:
- Image available as `v2.0.0`, `2.0`, `2`, `latest`
- Tag `1` still points to `v1.5.2` for users who aren't ready to upgrade

---

### Scenario 5: Testing Before Release

**Situation**: Want to test before creating official release.

```bash
# Push to develop branch
git checkout develop
git push origin develop

# CI builds image tagged as 'develop'
# Test using: docker pull ghcr.io/your-username/your-repo:develop

# Once satisfied, merge to main and tag
git checkout main
git merge develop
git tag v1.2.0
git push origin main --tags
```

---

### Scenario 6: Mistake in Version Tag

**Situation**: Tagged wrong version by mistake.

```bash
# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin :refs/tags/v1.0.0

# Create correct tag
git tag v1.1.0
git push origin v1.1.0
```

**Note**: Avoid deleting tags that users might already be using.

---

## Best Practices

1. **Always test before tagging**
   - Use `develop` branch for testing
   - Merge to `main` only when stable

2. **Write descriptive tag messages**
   ```bash
   git tag -a v1.0.0 -m "Release 1.0.0: Add user authentication and profiles"
   ```

3. **Keep a CHANGELOG.md** (optional but recommended)
   - Document what changed in each version
   - Makes it easier for users to understand updates

4. **Never reuse version numbers**
   - Once pushed, consider it permanent
   - If mistake, create new version

5. **Use develop branch for active development**
   - Keep `main` stable
   - Only merge tested code to `main`

6. **Tag only from main branch**
   - Ensures releases are from stable code

## Checking Current Version

```bash
# List all tags
git tag

# List tags matching pattern
git tag -l "v1.*"

# Show latest tag
git describe --tags --abbrev=0

# Show tag with message
git show v1.0.0
```

## Troubleshooting

### Tag not triggering workflow
- Check tag format: Must be `v*.*.*` (e.g., `v1.0.0`)
- Check GitHub Actions tab for errors
- Ensure you pushed the tag: `git push origin v1.0.0`

### Build failing
- Check workflow logs in GitHub Actions tab
- Ensure Dockerfile exists and is valid
- Check if tests are passing

### Image not appearing in GHCR
- Check GitHub Container Registry permissions
- Ensure `GITHUB_TOKEN` has package write permissions
- Wait a few minutes for image to appear

## Need Help?

- Check GitHub Actions logs: Repository → Actions tab
- View releases: Repository → Releases tab
- View images: Repository → Packages tab
