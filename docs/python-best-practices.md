# Python Best Practices

Quick reference for Python development standards in this boilerplate.

## Framework: FastAPI (Preferred)

**Why:** Fast, automatic validation with Pydantic, built-in API docs, async support, type hints throughout.

**Minimal Example:**
```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel, Field

app = FastAPI(title="My API", version="1.0.0")

class UserCreate(BaseModel):
    email: str = Field(..., regex=r"^[\w\.-]+@[\w\.-]+\.\w+$")
    name: str = Field(..., min_length=2)

@app.post("/users/", response_model=User, status_code=201)
async def create_user(user: UserCreate, db = Depends(get_db)) -> User:
    """Create a new user with validated data."""
    if await db.user_exists(user.email):
        raise HTTPException(400, "User exists")
    return await db.create_user(user)
```

**Key Practices:**
- Use Pydantic models for all request/response validation
- Leverage dependency injection (e.g., `Depends(get_db)`)
- Proper HTTP status codes (201 for create, 404 for not found)
- Group endpoints with `APIRouter` and tags

---

## Code Style

**Tools:** `black` (format), `isort` (imports), `ruff` (lint), `mypy` (types)

**Config (pyproject.toml):**
```toml
[tool.black]
line-length = 88

[tool.isort]
profile = "black"

[tool.mypy]
python_version = "3.11"
disallow_untyped_defs = true
```

**Clean Code Rules:**
1. **Meaningful names** - `calculate_total_price()` not `calc()`
2. **Single responsibility** - One function, one purpose
3. **Small functions** - Aim for <20 lines
4. **No magic numbers** - Use named constants
5. **Type hints everywhere**

---

## Testing with pytest

**Structure:**
```
tests/
├── conftest.py          # Shared fixtures
├── unit/
├── integration/
└── e2e/
```

**Example:**
```python
# conftest.py
@pytest.fixture
def client(test_db):
    """FastAPI test client."""
    app.dependency_overrides[get_db] = lambda: test_db
    return TestClient(app)

# test_api.py
def test_create_user_success(client):
    """Test successful user creation."""
    response = client.post("/users/", json={"email": "test@example.com", "name": "Test"})
    assert response.status_code == 201
    assert response.json()["email"] == "test@example.com"

@pytest.mark.parametrize("invalid_email", ["notanemail", "@test.com"])
def test_create_user_invalid_email(client, invalid_email):
    """Test invalid emails are rejected."""
    response = client.post("/users/", json={"email": invalid_email, "name": "Test"})
    assert response.status_code == 422
```

**Best Practices:**
- AAA pattern: Arrange, Act, Assert
- Descriptive test names explaining what's tested
- Use `@pytest.mark.parametrize` for multiple inputs
- Mock external dependencies
- Target >80% coverage: `pytest --cov=app --cov-report=html`

---

## Docstrings (Google Style)

```python
def fetch_user_data(user_id: int, include_orders: bool = False) -> dict:
    """
    Fetch user data from database.

    Args:
        user_id: Unique user identifier
        include_orders: Include order history. Defaults to False.

    Returns:
        Dictionary with user data including id, email, username.
        Optionally includes 'orders' list.

    Raises:
        UserNotFoundError: If user_id doesn't exist
        DatabaseError: If database connection fails

    Example:
        >>> user = fetch_user_data(123, include_orders=True)
        >>> print(user['username'])
    """
    pass
```

**Always document:** purpose, parameters, return value, exceptions, examples (if complex).

---

## Type Hints

```python
from typing import List, Dict, Optional, Union, Callable
from datetime import datetime

def process_items(items: List[str], multiplier: int = 1) -> Dict[str, int]:
    """Process items with type safety."""
    return {item: len(item) * multiplier for item in items}

def get_user(user_id: int) -> Optional[User]:
    """Return user or None."""
    return db.get(user_id)

class User:
    id: int
    email: str
    created_at: datetime
    metadata: Dict[str, Any]
```

**Rule:** Type hint all function signatures and class attributes.

---

## Error Handling

**Define specific exceptions:**
```python
class UserError(Exception):
    """Base exception for user operations."""

class UserNotFoundError(UserError):
    """User not found."""

# Usage
def get_user(user_id: int) -> User:
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise UserNotFoundError(f"User {user_id} not found")
    return user
```

**Catch specific exceptions:**
```python
# ❌ Bad
try:
    result = do_something()
except Exception:
    pass

# ✅ Good
try:
    user = get_user(user_id)
except UserNotFoundError:
    logger.warning(f"User {user_id} not found")
    return None
except DatabaseError as e:
    logger.error(f"Database error: {e}")
    raise
```

---

## Project Structure

```
app/
├── main.py              # FastAPI app initialization
├── config.py            # Settings (use pydantic-settings)
├── dependencies.py      # Shared dependencies
├── api/v1/endpoints/    # API routes (users.py, auth.py)
├── models/              # Pydantic & DB models
├── services/            # Business logic layer
├── repositories/        # Database operations
└── utils/               # Helper functions

tests/
├── conftest.py
├── unit/
└── integration/
```

**Separation of concerns:** Routes → Services → Repositories → Database

---

## Dependencies

**Prefer uv (faster):**
```toml
[project]
dependencies = [
    "fastapi>=0.104.0",
    "uvicorn[standard]>=0.24.0",
    "pydantic>=2.4.0",
    "sqlalchemy>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "black>=23.10.0",
    "mypy>=1.6.0",
    "ruff>=0.1.0",
]
```

**Install:** `uv pip install -e ".[dev]"`

---

## Quick Checklist

- [ ] Use FastAPI with Pydantic validation
- [ ] Type hints on all functions
- [ ] Google-style docstrings on public APIs
- [ ] pytest tests with >80% coverage
- [ ] Format with black, isort, ruff
- [ ] Specific exceptions (not generic `Exception`)
- [ ] Small, focused functions (<20 lines)
- [ ] Dependency injection for DB/auth
- [ ] Environment variables for secrets
- [ ] Input validation on all endpoints
