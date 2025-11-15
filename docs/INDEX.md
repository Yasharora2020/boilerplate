# Documentation Index

Welcome to the boilerplate documentation! This guide will help you find the right documentation for your needs.

## Quick Navigation

### 🚀 **Getting Started**
- **[Quick Start](./setup/QUICK_START.md)** - 5-minute setup guide for new projects
- **[Python Setup](./setup/PYTHON_SETUP.md)** - Choose between uv and pip package managers
- **[Environment Setup](./setup/ENVIRONMENT_SETUP.md)** - Configure environment variables and secrets

### 💻 **Development**
- **[Python Patterns](./develop/PYTHON_PATTERNS.md)** - Python/FastAPI best practices and patterns
- **[Next.js Patterns](./develop/NEXTJS_PATTERNS.md)** - Next.js 15+ best practices and patterns
- **[Testing Guide](./develop/TESTING_GUIDE.md)** - Writing and running tests for your application
- **[Claude Integration](./develop/CLAUDE_INTEGRATION.md)** - Using Claude Code with this boilerplate

### 🔧 **Operations & CI/CD**
- **[CI/CD Guide](./operate/CI_CD_GUIDE.md)** - Complete GitHub Actions setup and configuration
- **[Docker Guide](./operate/DOCKER_GUIDE.md)** - Docker configuration and multi-platform builds
- **[Troubleshooting](./operate/TROUBLESHOOTING.md)** - Common issues and solutions

### 📦 **Releases & Versioning**
- **[Versioning Guide](./release/VERSIONING_GUIDE.md)** - Semantic versioning and creating releases
- **[Changelog Guide](./release/CHANGELOG_GUIDE.md)** - Maintaining a changelog for your project

---

## By Use Case

### "I'm starting a new project"
1. Read [Quick Start](./setup/QUICK_START.md)
2. Choose your stack:
   - **Python?** → [Python Setup](./setup/PYTHON_SETUP.md) → [Python Patterns](./develop/PYTHON_PATTERNS.md)
   - **Next.js?** → [Next.js Patterns](./develop/NEXTJS_PATTERNS.md)
3. Read [CI/CD Guide](./operate/CI_CD_GUIDE.md) to understand workflows

### "I need to set up CI/CD"
1. Start with [Quick Start](./setup/QUICK_START.md) - Initial Setup section
2. Read [CI/CD Guide](./operate/CI_CD_GUIDE.md) for detailed configuration
3. Reference [Troubleshooting](./operate/TROUBLESHOOTING.md) if issues arise

### "I'm writing Python code"
1. Read [Python Patterns](./develop/PYTHON_PATTERNS.md)
2. See [Testing Guide](./develop/TESTING_GUIDE.md)
3. Follow examples for FastAPI, Pydantic, pytest

### "I'm writing Next.js code"
1. Read [Next.js Patterns](./develop/NEXTJS_PATTERNS.md)
2. See [Testing Guide](./develop/TESTING_GUIDE.md)
3. Follow examples for Server Components, Server Actions, Zod

### "I'm creating a release"
1. Read [Versioning Guide](./release/VERSIONING_GUIDE.md)
2. Update [CHANGELOG.md](../CHANGELOG.md) using [Changelog Guide](./release/CHANGELOG_GUIDE.md)
3. Create tag: `git tag v1.0.0 && git push origin v1.0.0`
4. Monitor in GitHub Actions

### "Something is broken"
1. Check [Troubleshooting](./operate/TROUBLESHOOTING.md)
2. Review workflow logs in GitHub Actions tab
3. Test locally first before debugging CI

### "I'm configuring Docker"
1. Read [Docker Guide](./operate/DOCKER_GUIDE.md)
2. Edit `Dockerfile` based on your stack
3. See [CI/CD Guide](./operate/CI_CD_GUIDE.md) for Docker in workflows

---

## Directory Structure

```
docs/
├── INDEX.md                          # This file
│
├── setup/                            # Getting started
│   ├── QUICK_START.md               # 5-minute setup
│   ├── PYTHON_SETUP.md              # Python package managers
│   └── ENVIRONMENT_SETUP.md         # Environment variables & secrets
│
├── develop/                          # Development standards
│   ├── PYTHON_PATTERNS.md           # Python best practices
│   ├── NEXTJS_PATTERNS.md           # Next.js best practices
│   ├── TESTING_GUIDE.md             # Testing strategies
│   └── CLAUDE_INTEGRATION.md        # Using with Claude Code
│
├── operate/                          # Operations & CI/CD
│   ├── CI_CD_GUIDE.md               # GitHub Actions setup
│   ├── DOCKER_GUIDE.md              # Docker configuration
│   └── TROUBLESHOOTING.md           # Common issues
│
└── release/                          # Releases & versioning
    ├── VERSIONING_GUIDE.md          # Semantic versioning
    └── CHANGELOG_GUIDE.md           # Changelog management
```

---

## Document Quick Reference

| Document | Audience | Read Time | Purpose |
|----------|----------|-----------|---------|
| [Quick Start](./setup/QUICK_START.md) | Everyone | 5 min | Get running in minutes |
| [Python Setup](./setup/PYTHON_SETUP.md) | Python developers | 10 min | Choose package manager |
| [Environment Setup](./setup/ENVIRONMENT_SETUP.md) | DevOps/Backend | 5 min | Configure env vars |
| [Python Patterns](./develop/PYTHON_PATTERNS.md) | Python developers | 15 min | Code standards |
| [Next.js Patterns](./develop/NEXTJS_PATTERNS.md) | Next.js developers | 20 min | Code standards |
| [Testing Guide](./develop/TESTING_GUIDE.md) | Developers | 15 min | Test strategies |
| [Claude Integration](./develop/CLAUDE_INTEGRATION.md) | Claude Code users | 10 min | AI assistant setup |
| [CI/CD Guide](./operate/CI_CD_GUIDE.md) | DevOps/CI-CD | 20 min | Workflows & setup |
| [Docker Guide](./operate/DOCKER_GUIDE.md) | Devops/Backend | 15 min | Docker configuration |
| [Troubleshooting](./operate/TROUBLESHOOTING.md) | Everyone | Varies | Problem solving |
| [Versioning Guide](./release/VERSIONING_GUIDE.md) | Release managers | 15 min | Creating releases |
| [Changelog Guide](./release/CHANGELOG_GUIDE.md) | Everyone | 10 min | Changelog management |

---

## Key Concepts

### Project Structure
The boilerplate is organized by **user workflow**, not by file type:

- **setup/** - Everything needed to get started
- **develop/** - Standards and patterns for writing code
- **operate/** - Running and maintaining the application
- **release/** - Versioning and release management

### Two Main Branches
- **develop** - Active development branch
- **main** - Production-ready code (only for releases)

### Image Tags
- `develop` - Latest from develop branch
- `main` - Latest from main branch
- `v1.0.0` - Specific version release
- `latest` - Latest stable release

### Supported Stacks
- **Python:** FastAPI with Pydantic
- **Next.js:** Next.js 15+ with React Server Components

---

## Frequently Asked Questions

### Q: Which Python package manager should I use?
**A:** See [Python Setup](./setup/PYTHON_SETUP.md) for detailed comparison. TL;DR: Use `uv` for new projects, `pip` for existing ones.

### Q: How do I create a release?
**A:** Read [Versioning Guide](./release/VERSIONING_GUIDE.md). Quick: `git tag v1.0.0 && git push origin v1.0.0`

### Q: Where's the Docker configuration?
**A:** See [Docker Guide](./operate/DOCKER_GUIDE.md) for Dockerfile templates and configuration.

### Q: How do I use this with Claude Code?
**A:** Read [Claude Integration](./develop/CLAUDE_INTEGRATION.md).

### Q: What if the CI/CD workflow fails?
**A:** See [Troubleshooting](./operate/TROUBLESHOOTING.md) for common issues and solutions.

### Q: How do I configure environment variables?
**A:** Read [Environment Setup](./setup/ENVIRONMENT_SETUP.md).

### Q: What testing framework is recommended?
**A:** See [Testing Guide](./develop/TESTING_GUIDE.md).

---

## Updates & Contributing

If you find issues or want to improve documentation:
1. Report issues on GitHub
2. Submit PRs with improvements
3. Check the main README.md for contribution guidelines

---

## Related Files

- **[README.md](../README.md)** - Project overview and quick links
- **[CLAUDE.md](../CLAUDE.md)** - Project context for Claude Code
- **[CHANGELOG.md](../CHANGELOG.md)** - Project version history

---

**Happy developing!** 🚀

If you have questions, check the document that matches your task. Each one has examples and best practices.
