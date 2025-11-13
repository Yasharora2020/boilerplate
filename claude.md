# Project Context for Claude

> This file provides project-specific context, conventions, and best practices for Claude Code.

## Project Overview

This is a **boilerplate template** for starting new Python (FastAPI) or Next.js projects with production-ready CI/CD pipelines.

**Key Features:**
- Multi-platform Docker builds (amd64, arm64)
- GitHub Actions CI/CD with automated testing, security scanning, and releases
- Semantic versioning with automated changelog generation
- Support for both Python (FastAPI) and Next.js stacks

---

## Tech Stack & Preferences

### For Python Projects

- **Framework:** FastAPI (preferred) - modern, fast, with automatic API docs
- **Package Manager:** `uv` (preferred) or `pip`
- **Testing:** pytest with >80% coverage target
- **Type Checking:** mypy with strict mode
- **Code Style:** black + isort + ruff
- **Validation:** Pydantic models for all data

📖 **See detailed guidelines:** `.claude/docs/python-best-practices.md`

### For Next.js Projects

- **Framework:** Next.js 15+ with App Router
- **Language:** TypeScript (strict mode)
- **Styling:** Tailwind CSS
- **Validation:** Zod for runtime validation
- **Data Fetching:** Server Actions (preferred for mutations), Server Components for data, React Query for client-side
- **Testing:** Jest + React Testing Library

📖 **See detailed guidelines:** `.claude/docs/nextjs-best-practices.md`

---

## Code Quality Standards

### Python
```python
# ✅ Always use type hints and docstrings
async def create_user(
    user_data: UserCreate,
    db: Database = Depends(get_db)
) -> User:
    """
    Create a new user.

    Args:
        user_data: User creation data with validated fields
        db: Database session dependency

    Returns:
        Created user object

    Raises:
        HTTPException: If user already exists
    """
    # Implementation...
```

### TypeScript/Next.js
```typescript
// ✅ Use TypeScript strict mode, Zod validation
const userSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
})

type User = z.infer<typeof userSchema>
```

### Universal Rules

1. **Clean Code:** Single responsibility, meaningful names, small functions
2. **Documentation:** Comprehensive docstrings/JSDoc for public APIs
3. **Testing:** Unit tests for business logic, integration tests for APIs
4. **Error Handling:** Specific exceptions/errors, never catch generic `Exception`
5. **Security:** Validate all inputs, sanitize outputs, use environment variables for secrets

---

## CI/CD Pipeline

**Location:** `.github/workflows/`

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

📖 **CI/CD Setup:** `docs/GITHUB_ACTIONS_SETUP.md`
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
npm test
npm run lint
npm run type-check
```

---

## Environment Variables

Never commit secrets. Use `.env.local` (git-ignored).

**Python Example:**
```bash
DATABASE_URL=postgresql://...
API_SECRET_KEY=...
```

**Next.js Example:**
```bash
DATABASE_URL=postgresql://...
NEXT_PUBLIC_API_URL=https://api.example.com
```

---

## Security Practices

1. **Input Validation:** Always validate with Pydantic (Python) or Zod (Next.js)
2. **Authentication:** Implement proper session management
3. **Environment Variables:** Use for all secrets, validate at startup
4. **Dependencies:** Regular scanning with Trivy in CI/CD
5. **Error Messages:** Don't expose sensitive information
6. **CORS:** Configure properly for production

---

## Docker

**Build:**
```bash
docker build -t my-app .
```

**Run:**
```bash
# Python/FastAPI (usually port 8000)
docker run -p 8000:8000 my-app

# Next.js (usually port 3000)
docker run -p 3000:3000 my-app
```

**Multi-platform:**
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t my-app .
```

---

## When Starting a New Project

1. **Choose Stack:** Run `./scripts/setup.sh` or manually copy files
2. **Configure:** Update `next.config.js` or `pyproject.toml`
3. **Add Tests:** Update `.github/workflows/ci.yml` with test commands
4. **Set Permissions:** Enable GitHub Actions write permissions
5. **Create Branches:**
   ```bash
   git checkout -b develop
   git push origin develop
   ```
6. **First Release:**
   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```

---

## Quick Reference

| Task | Python Command | Next.js Command |
|------|---------------|-----------------|
| Install deps | `uv pip install -e ".[dev]"` | `npm install` |
| Run dev | `uvicorn app.main:app --reload` | `npm run dev` |
| Run tests | `pytest` | `npm test` |
| Format code | `black .` | `npm run format` |
| Lint | `ruff check .` | `npm run lint` |
| Type check | `mypy .` | `npm run type-check` |

---

## Additional Resources

- 📖 **Python Best Practices:** `.claude/docs/python-best-practices.md`
- 📖 **Next.js Best Practices:** `.claude/docs/nextjs-best-practices.md`
- 📖 **CI/CD Setup Guide:** `docs/GITHUB_ACTIONS_SETUP.md`
- 📖 **Versioning Guide:** `docs/VERSIONING_GUIDE.md`
- 📖 **Python Setup (uv vs pip):** `docs/PYTHON_SETUP.md`

---

## Documentation Resources

**When you need to look up framework documentation:**

### Next.js Documentation
1. **Primary:** Use **context7 MCP server** for latest Next.js 15+ documentation
   - Provides official, up-to-date Next.js docs
   - Always check here first for Next.js questions

2. **Fallback:** Use **WebSearch** if context7 MCP is unavailable
   - Search: "Next.js 15 [feature] 2025"
   - Verify from official sources only

### Python/FastAPI Documentation
- Use **WebSearch** for FastAPI, pytest, Pydantic docs
- Prioritize official documentation over blog posts

---

## Notes for Claude

- This is a **template repository** - customize for each new project
- Always prefer existing conventions documented in `.claude/docs/`
- **For Next.js:** Use Server Actions for mutations, prefer Server Components
- **For Python:** Use FastAPI with Pydantic validation
- Run tests before committing
- Use type hints/types extensively
- Follow the CI/CD workflow for deployments
- Security scanning is automatic - review results in GitHub Security tab
- **Check context7 MCP for Next.js docs first**, fallback to WebSearch
