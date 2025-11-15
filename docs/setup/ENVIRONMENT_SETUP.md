# Environment Setup Guide

How to configure environment variables, secrets, and environment-specific settings for your application.

## Overview

Environment variables store sensitive information and configuration that differs between environments (development, staging, production).

**Never commit:**
- API keys
- Database passwords
- Authentication tokens
- Private credentials

## Setting Up Environment Variables

### Local Development

#### Python with uv
```bash
# Create .env file (git-ignored)
cat > .env << EOF
DATABASE_URL=sqlite:///./test.db
SECRET_KEY=dev-secret-key-change-in-production
DEBUG=true
EOF

# Load in your app
from dotenv import load_dotenv
import os

load_dotenv()
database_url = os.getenv("DATABASE_URL")
```

#### Python with pip
```bash
# Create .env file
echo "DATABASE_URL=sqlite:///./test.db" > .env
echo "SECRET_KEY=dev-secret-key" >> .env

# Install python-dotenv
pip install python-dotenv
```

#### Next.js
```bash
# Create .env.local (git-ignored)
cat > .env.local << EOF
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
NEXT_PUBLIC_API_URL=http://localhost:3000
STRIPE_SECRET_KEY=sk_test_xyz
EOF

# Use in code
const apiUrl = process.env.NEXT_PUBLIC_API_URL
```

### GitHub Actions Secrets

For CI/CD workflows, use GitHub Secrets:

1. Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add secret name and value

**Example:**
```yaml
- name: Deploy
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    API_KEY: ${{ secrets.API_KEY }}
  run: ./deploy.sh
```

### Environment-Specific Configuration

#### Python (FastAPI)

```python
# config.py
from pydantic import BaseSettings
import os

class Settings(BaseSettings):
    app_name: str = "My API"
    debug: bool = os.getenv("DEBUG", "false").lower() == "true"
    database_url: str
    secret_key: str
    log_level: str = os.getenv("LOG_LEVEL", "info")

    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()

# main.py
from config import settings

app = FastAPI(title=settings.app_name, debug=settings.debug)
```

#### Next.js

```typescript
// lib/env.ts
import { z } from 'zod'

const envSchema = z.object({
  NEXT_PUBLIC_API_URL: z.string().url(),
  DATABASE_URL: z.string().url(),
  STRIPE_SECRET_KEY: z.string().min(1),
  NODE_ENV: z.enum(['development', 'production', 'test']),
})

export const env = envSchema.parse({
  NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL,
  DATABASE_URL: process.env.DATABASE_URL,
  STRIPE_SECRET_KEY: process.env.STRIPE_SECRET_KEY,
  NODE_ENV: process.env.NODE_ENV,
})
```

## Common Environment Variables

### Database
```bash
# PostgreSQL
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# MySQL
DATABASE_URL=mysql://user:password@localhost:3306/dbname

# SQLite
DATABASE_URL=sqlite:///./test.db
```

### API Keys
```bash
STRIPE_SECRET_KEY=sk_test_xyz
STRIPE_PUBLISHABLE_KEY=pk_test_xyz
OPENAI_API_KEY=sk-proj-xyz
GITHUB_TOKEN=ghp_xyz
```

### Authentication
```bash
SECRET_KEY=your-secret-key-min-32-chars
JWT_SECRET=jwt-secret-key
OAUTH_CLIENT_ID=client-id
OAUTH_CLIENT_SECRET=client-secret
```

### URLs & Hosts
```bash
# Next.js
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_ANALYTICS_URL=https://analytics.example.com

# General
API_BASE_URL=https://api.example.com
FRONTEND_URL=https://example.com
```

### Feature Flags
```bash
ENABLE_ANALYTICS=true
ENABLE_STRIPE=false
DEBUG=true
LOG_LEVEL=debug
```

## GitHub Actions Secrets Setup

### Adding Secrets for CI/CD

1. **Get your credentials:**
   - Database URL from hosting provider
   - API keys from service dashboards
   - Authentication tokens from platforms

2. **Add to GitHub:**
   - Go to: Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Add each one:
     - `DATABASE_URL`
     - `API_KEY`
     - `STRIPE_SECRET_KEY`
     - etc.

3. **Use in workflows:**
   ```yaml
   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
         - name: Deploy to production
           env:
             DATABASE_URL: ${{ secrets.DATABASE_URL }}
             API_KEY: ${{ secrets.API_KEY }}
           run: ./scripts/deploy.sh
   ```

### Secret Naming Convention

Use UPPERCASE_WITH_UNDERSCORES for clarity:
```yaml
# Good
DATABASE_URL
STRIPE_SECRET_KEY
JWT_SECRET_KEY

# Avoid
db_url
stripe_key
jwt
```

## Security Best Practices

### DO
✅ Store sensitive data in environment variables
✅ Use `.env` files locally (git-ignored)
✅ Use GitHub Secrets for CI/CD
✅ Rotate secrets periodically
✅ Use strong, random secret keys
✅ Limit secret scope (only where needed)
✅ Log when secrets are accessed (don't log values)
✅ Use different secrets per environment

### DON'T
❌ Commit `.env` files to git
❌ Log sensitive values
❌ Share secrets in chat/email
❌ Use the same secret across environments
❌ Hardcode API keys in code
❌ Use weak secret keys
❌ Expose secrets in error messages
❌ Commit secret examples in plaintext

## Example Setups

### Python FastAPI with PostgreSQL
```bash
# .env (local development)
DATABASE_URL=postgresql://user:password@localhost:5432/myapp_dev
SECRET_KEY=dev-secret-key-12345
DEBUG=true
LOG_LEVEL=debug
CORS_ORIGINS=http://localhost:3000,http://localhost:8000
```

### Next.js with Stripe
```bash
# .env.local
NEXT_PUBLIC_API_URL=http://localhost:3000
DATABASE_URL=postgresql://user:password@localhost:5432/myapp
STRIPE_SECRET_KEY=sk_test_12345
STRIPE_PUBLISHABLE_KEY=pk_test_12345
NEXT_PUBLIC_STRIPE_KEY=pk_test_12345
```

### Multi-Environment Setup
```bash
# .env (shared defaults for local dev)
LOG_LEVEL=info
DEBUG=false

# .env.local (your local overrides)
DATABASE_URL=postgresql://localhost/myapp_local
DEBUG=true
LOG_LEVEL=debug

# .env.production (production values - never commit!)
# Instead, use GitHub Secrets for production
```

## Managing Secrets in Team

### Safe Practices
1. Never share secrets via chat/email
2. Use 1password/LastPass/vault for team secrets
3. Rotate secrets if someone leaves team
4. Each developer has their own local `.env`
5. Use different secrets per environment

### Onboarding New Developers
```bash
# Don't do this:
# - Email them the .env file
# - Share secrets in Slack

# Do this:
# 1. Create template file
cp .env.example .env

# 2. They fill in their own values from documentation
# 3. For CI/CD, add to GitHub Secrets

# .env.example
DATABASE_URL=postgresql://user:pass@localhost/dbname
SECRET_KEY=change-me-locally
DEBUG=true
```

## Troubleshooting

### Environment Variables Not Loaded
```python
# Check if .env exists
import os
from pathlib import Path

env_path = Path('.env')
if env_path.exists():
    print("✅ .env file found")
else:
    print("❌ .env file not found")

# Load explicitly
from dotenv import load_dotenv
load_dotenv()

# Verify
print(os.getenv('DATABASE_URL'))
```

### Secrets Not Available in CI/CD
1. Check GitHub Secrets are added
2. Verify secret name matches in workflow
3. Check workflow has permission to access secrets
4. Use correct syntax: `${{ secrets.SECRET_NAME }}`

### .env File in Git
```bash
# If you accidentally committed it:
# 1. Remove from git history
git rm --cached .env

# 2. Add to .gitignore
echo ".env" >> .gitignore
echo ".env.local" >> .gitignore

# 3. Commit
git add .gitignore
git commit -m "Remove .env from tracking"
```

## Example .env Files

### Python API
```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/myapp
DATABASE_MAX_CONNECTIONS=20

# Security
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
CORS_ORIGINS=http://localhost:3000,https://myapp.com

# Logging
LOG_LEVEL=info
LOG_FILE=/var/log/myapp.log

# Features
ENABLE_REGISTRATION=true
ENABLE_EMAIL_VERIFICATION=false
ENABLE_STRIPE=true

# Third-party APIs
STRIPE_SECRET_KEY=sk_test_xyz
SENDGRID_API_KEY=SG.xyz
```

### Next.js App
```bash
# Public URLs (visible in client code)
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_APP_NAME="My App"
NEXT_PUBLIC_VERSION=1.0.0

# Private (server-only)
DATABASE_URL=postgresql://user:pass@localhost:5432/myapp
DATABASE_POOL_SIZE=10

# Stripe
STRIPE_SECRET_KEY=sk_test_xyz
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_xyz

# Email
SENDGRID_API_KEY=SG.xyz
EMAIL_FROM=noreply@myapp.com

# Analytics
NEXT_PUBLIC_ANALYTICS_ID=UA-xyz
ANALYTICS_SECRET=xyz
```

## Resources

- [Pydantic Settings](https://docs.pydantic.dev/latest/concepts/pydantic_settings/)
- [Node.js dotenv](https://www.npmjs.com/package/dotenv)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [12 Factor App - Config](https://12factor.net/config)
