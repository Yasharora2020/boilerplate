# Project Context for Claude

> This file provides project-specific context and conventions for Claude Code.

## Project Overview

This is a **boilerplate template** for starting new Python (FastAPI) or Next.js projects with production-ready CI/CD pipelines.

**Key Features:**
- Multi-platform Docker builds (amd64, arm64)
- GitHub Actions CI/CD with automated testing, security scanning, and releases
- Semantic versioning with automated changelog generation
- Support for both Python (FastAPI) and Next.js stacks

---

## Tech Stack & Documentation

### For Python Projects

📖 **See all guidelines:** `.docs/python-best-practices.md`

### For Next.js Projects

📖 **See all guidelines:** `.docs/nextjs-best-practices.md`

---

## Architecture

<!-- Add project-specific architecture details here -->

**Placeholder for project architecture:**
- System design and component interactions
- Database schema and relationships
- API design patterns
- Service boundaries and responsibilities
- Integration points with external services

---

## Universal Development Rules

1. **Test-Driven Development (TDD):**
   - Write tests before implementation
   - Follow Red-Green-Refactor cycle
   - Maintain high test coverage (>80%)

2. **Clean Code:**
   - Single responsibility principle
   - Meaningful names
   - Small, focused functions

3. **Documentation:**
   - Comprehensive docstrings/JSDoc for public APIs
   - Keep README and docs up-to-date

4. **Error Handling:**
   - Use specific exceptions/errors
   - Never catch generic `Exception`
   - Provide meaningful error messages

5. **Security:**
   - Validate all inputs
   - Sanitize outputs
   - Use environment variables for secrets

---

## CI/CD Pipeline

**Location:** `.github/workflows/` *** currently Disabled ***

### CI Pipeline (`ci.yml`)

**Triggers:** Push to `main`/`develop`, Pull Requests

**Process:**
1. **Test** - Runs unit/integration tests
2. **Build** - Creates Docker image
3. **Security Scan** - Trivy vulnerability scanning
4. **Push** - Pushes image to GHCR with branch tag (if not PR)

**Image Tags:** `develop`, `main`, `develop-sha-abc123f`

### Release Pipeline (`release.yml`)

**Triggers:** Version tag push (e.g., `v1.0.0`)

**Process:**
1. **Multi-platform Build** - Builds for amd64 & arm64
2. **Security Scan** - Comprehensive Trivy scanning
3. **SBOM Generation** - Creates Software Bill of Materials
4. **GitHub Release** - Automated release with changelog

**Image Tags:** `v1.0.0`, `1.0.0`, `1.0`, `1`, `latest`

**Creating a Release:**
```bash
git tag v1.0.0 -m "Release 1.0.0: Description"
git push origin v1.0.0
```

📖 **CI/CD Setup:** `.docs/GITHUB_ACTIONS_SETUP.md`
📖 **Versioning:** `docs/VERSIONING_GUIDE.md`

---

## Project Structure

### Python (FastAPI)
```
app/
├── main.py              # FastAPI app
├── api/v1/endpoints/    # API routes
├── models/              # Pydantic models
├── services/            # Business logic
├── repositories/        # Database operations
└── utils/               # Helpers

tests/
├── unit/
├── integration/
└── conftest.py          # pytest fixtures
```

### Next.js
```
src/
├── app/                 # App router pages
│   ├── api/            # API routes
│   └── (auth)/         # Route groups
├── components/
│   └── ui/             # Reusable components
├── lib/                # Utilities, API clients
├── hooks/              # Custom hooks
└── types/              # TypeScript types
```

---

## Development Workflow

### Git Branching

- `main` - Production-ready code
- `develop` - Active development
- `feature/*` - Feature branches

### Commit Convention

Use semantic commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `refactor:` - Code refactoring
- `test:` - Tests
- `chore:` - Maintenance

### Testing Before Commits

**Python:**
```bash
pytest tests/ --cov=app
black app/ tests/
isort app/ tests/
mypy app/
```

**Next.js:**
```bash
pnpm test
pnpm run lint
pnpm run type-check
```
