# Testing Guide

Comprehensive guide to testing strategies, frameworks, and best practices for both Python and Next.js applications.

## Overview

Testing ensures your code works correctly and prevents regressions. This guide covers unit, integration, and end-to-end testing.

**Test Coverage Target:** >80%

## Python Testing with pytest

### Setup

```bash
# Install pytest and plugins
pip install pytest pytest-cov pytest-asyncio pytest-mock

# Or with uv
uv pip install pytest pytest-cov pytest-asyncio pytest-mock
```

### Test Structure

```
tests/
├── conftest.py              # Shared fixtures
├── unit/                    # Unit tests
│   ├── test_models.py
│   ├── test_services.py
│   └── test_utils.py
├── integration/             # Integration tests
│   ├── test_api.py
│   └── test_database.py
└── e2e/                     # End-to-end tests
    └── test_workflows.py
```

### Writing Tests

**Basic Test:**
```python
# test_models.py
from app.models import User

def test_user_creation():
    """Test creating a user."""
    user = User(email="test@example.com", name="Test User")
    assert user.email == "test@example.com"
    assert user.name == "Test User"
```

**Using Fixtures:**
```python
# conftest.py
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.database import get_db

@pytest.fixture
def client(test_db):
    """FastAPI test client."""
    app.dependency_overrides[get_db] = lambda: test_db
    return TestClient(app)

# test_api.py
def test_create_user(client):
    """Test API endpoint."""
    response = client.post(
        "/users/",
        json={"email": "test@example.com", "name": "Test"}
    )
    assert response.status_code == 201
```

**Parametrized Tests:**
```python
@pytest.mark.parametrize("email,expected", [
    ("valid@example.com", True),
    ("invalid-email", False),
    ("", False),
])
def test_email_validation(email, expected):
    """Test email validation with multiple inputs."""
    result = validate_email(email)
    assert result == expected
```

**Async Tests:**
```python
@pytest.mark.asyncio
async def test_async_operation():
    """Test async function."""
    result = await fetch_data()
    assert result is not None
```

### Running Tests

```bash
# Run all tests
pytest tests/

# Run specific file
pytest tests/unit/test_models.py

# Run specific test
pytest tests/unit/test_models.py::test_user_creation

# With coverage
pytest tests/ --cov=app --cov-report=html

# Watch mode
pytest-watch tests/

# Verbose output
pytest -v tests/

# Stop on first failure
pytest -x tests/

# Show print statements
pytest -s tests/
```

### Coverage Reports

```bash
# Generate HTML report
pytest tests/ --cov=app --cov-report=html

# View report
open htmlcov/index.html

# Check coverage by file
pytest tests/ --cov=app --cov-report=term-missing
```

## Next.js Testing

### Setup

```bash
npm install -D @testing-library/react @testing-library/jest-dom jest @types/jest
```

### Test Configuration

**jest.config.js:**
```javascript
const nextJest = require('next/jest')

const createJestConfig = nextJest({
  dir: './',
})

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
}

module.exports = createJestConfig(customJestConfig)
```

**jest.setup.js:**
```javascript
import '@testing-library/jest-dom'
```

### Test Structure

```
__tests__/
├── components/
│   ├── Button.test.tsx
│   └── Form.test.tsx
├── lib/
│   └── utils.test.ts
└── api/
    └── users.test.ts
```

### Writing Tests

**Component Test:**
```typescript
// __tests__/components/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from '@/components/Button'

describe('Button', () => {
  it('renders button text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByText('Click me')).toBeInTheDocument()
  })

  it('calls onClick handler', () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>Click</Button>)

    fireEvent.click(screen.getByText('Click'))
    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('disables when loading', () => {
    render(<Button isLoading>Loading</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })
})
```

**Server Action Test:**
```typescript
// __tests__/api/users.test.ts
import { createUser } from '@/app/actions'

describe('createUser', () => {
  it('creates user with valid data', async () => {
    const formData = new FormData()
    formData.append('email', 'test@example.com')
    formData.append('name', 'Test User')

    const result = await createUser(formData)

    expect(result.success).toBe(true)
    expect(result.user.email).toBe('test@example.com')
  })

  it('returns error with invalid data', async () => {
    const formData = new FormData()
    formData.append('email', 'invalid')
    formData.append('name', '')

    const result = await createUser(formData)

    expect(result.errors).toBeDefined()
    expect(result.success).toBe(false)
  })
})
```

### Running Tests

```bash
# Run all tests
npm test

# Watch mode
npm test -- --watch

# Coverage
npm test -- --coverage

# Specific file
npm test Button.test.tsx
```

## Best Practices (Both)

### AAA Pattern
```python
# Arrange - Set up test data
user_data = {"email": "test@example.com", "name": "Test"}

# Act - Perform the action
user = create_user(user_data)

# Assert - Verify the result
assert user.email == "test@example.com"
```

### Descriptive Names
```python
# Good
def test_create_user_with_valid_email_succeeds():
    pass

# Bad
def test_user():
    pass
```

### Test Isolation
```python
# Each test should be independent
# Use fixtures to reset state
@pytest.fixture
def reset_database():
    clear_all_data()
    yield
    clear_all_data()
```

### Mock External Services
```python
# Don't test Stripe API, mock it
from unittest.mock import patch

@patch('stripe.Charge.create')
def test_payment(mock_stripe):
    mock_stripe.return_value = {'id': 'ch_123'}
    result = process_payment()
    assert result['id'] == 'ch_123'
```

### Test Database
```python
# Use separate test database
@pytest.fixture
def test_db():
    db = create_test_database()
    yield db
    cleanup_test_database()
```

## Testing Checklist

### Unit Tests
- [ ] All functions tested
- [ ] Edge cases covered
- [ ] Error paths tested
- [ ] >80% coverage

### Integration Tests
- [ ] API endpoints work
- [ ] Database queries correct
- [ ] External service mocks work
- [ ] Error handling tested

### End-to-End Tests
- [ ] User workflows work
- [ ] Critical paths tested
- [ ] Data persists correctly
- [ ] Error states handled

## CI/CD Integration

### Python
```yaml
# .github/workflows/ci.yml
- name: Run tests
  run: |
    pip install pytest pytest-cov
    pytest tests/ --cov=app --cov-report=xml

- name: Upload coverage
  uses: codecov/codecov-action@v3
```

### Next.js
```yaml
- name: Run tests
  run: |
    npm install
    npm test -- --coverage

- name: Upload coverage
  uses: codecov/codecov-action@v3
```

## Resources

- [pytest Documentation](https://docs.pytest.org/)
- [Testing Library](https://testing-library.com/)
- [Jest Documentation](https://jestjs.io/)
- [FastAPI Testing](https://fastapi.tiangolo.com/advanced/testing-dependencies/)
- [Next.js Testing](https://nextjs.org/docs/testing)
