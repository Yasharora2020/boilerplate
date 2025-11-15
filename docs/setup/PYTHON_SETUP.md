# Python Setup Guide

This boilerplate supports both traditional pip/requirements.txt and modern uv/pyproject.toml workflows.

## Quick Decision Guide

**Use `uv` + `pyproject.toml` if:**
- ✅ You want faster dependency installation (10-100x faster)
- ✅ You prefer modern Python packaging standards
- ✅ You want reproducible builds with lockfiles
- ✅ You're starting a new project

**Use `pip` + `requirements.txt` if:**
- ✅ You have an existing project with requirements.txt
- ✅ Your team is more familiar with pip
- ✅ You need maximum compatibility with older tools

## Option 1: Using uv (Recommended for New Projects)

### Setup

1. **Copy the example file:**
```bash
cp pyproject.example.toml pyproject.toml
```

2. **Edit pyproject.toml** and uncomment your dependencies:
```toml
[project]
name = "my-app"
version = "0.1.0"
dependencies = [
    "fastapi>=0.109.0",
    "uvicorn[standard]>=0.27.0",
]
```

3. **Copy the Dockerfile:**
```bash
cp Dockerfile.python.example Dockerfile
```

The Dockerfile will automatically detect `pyproject.toml` and use uv!

### Local Development with uv

```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create virtual environment
uv venv

# Activate (Linux/Mac)
source .venv/bin/activate

# Install dependencies including dev
uv pip install -e ".[dev]"

# Run your app
python main.py
```

### Adding Dependencies

```bash
# Add to pyproject.toml under [project.dependencies]
# Then sync:
uv pip install -e .

# Or install directly:
uv pip install package-name
# Then update pyproject.toml manually
```

### Docker Build

```bash
# The Dockerfile automatically detects pyproject.toml
docker build -t my-app .
docker run -p 8000:8000 my-app
```

## Option 2: Using pip (Traditional)

### Setup

1. **Copy the example files:**
```bash
cp requirements.example.txt requirements.txt
cp requirements-dev.example.txt requirements-dev.txt
```

2. **Edit requirements.txt** and add your dependencies:
```
fastapi==0.109.0
uvicorn==0.27.0
```

3. **Copy the Dockerfile:**
```bash
cp Dockerfile.python.example Dockerfile
```

The Dockerfile will automatically detect `requirements.txt` and use pip!

### Local Development with pip

```bash
# Create virtual environment
python -m venv venv

# Activate (Linux/Mac)
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Run your app
python main.py
```

### Adding Dependencies

```bash
# Install package
pip install package-name

# Update requirements
pip freeze > requirements.txt
```

### Docker Build

```bash
# The Dockerfile automatically detects requirements.txt
docker build -t my-app .
docker run -p 8000:8000 my-app
```

## How the Dockerfile Works

The Dockerfile intelligently detects which package manager to use:

```dockerfile
# Checks for pyproject.toml first
if [ -f "pyproject.toml" ]; then
    # Uses uv
elif [ -f "requirements.txt" ]; then
    # Uses pip
fi
```

**Priority:**
1. If `pyproject.toml` exists → uses `uv`
2. If `requirements.txt` exists → uses `pip`
3. If neither exists → build fails with error

## GitHub Actions CI

The CI workflow (`.github/workflows/ci.yml`) also supports both:

- Detects `pyproject.toml` → installs uv and uses it
- Detects `requirements.txt` → uses pip

No configuration needed!

## Comparison

| Feature | uv | pip |
|---------|-------|------|
| **Speed** | 10-100x faster | Standard speed |
| **Config File** | pyproject.toml | requirements.txt |
| **Standards** | PEP 621 (modern) | requirements.txt (classic) |
| **Lockfiles** | Yes (uv.lock) | No (use pip-tools) |
| **Learning Curve** | New tool | Familiar to all |
| **Best For** | New projects | Existing projects |

## Migration: pip → uv

### Convert requirements.txt to pyproject.toml

1. **Create pyproject.toml:**
```bash
cp pyproject.example.toml pyproject.toml
```

2. **Convert dependencies:**

**From requirements.txt:**
```
fastapi==0.109.0
uvicorn==0.27.0
sqlalchemy==2.0.25
```

**To pyproject.toml:**
```toml
[project]
dependencies = [
    "fastapi>=0.109.0",
    "uvicorn>=0.27.0",
    "sqlalchemy>=2.0.25",
]
```

3. **Test locally:**
```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create venv and install
uv venv
source .venv/bin/activate
uv pip install -e ".[dev]"

# Test your app
python main.py
```

4. **Test Docker build:**
```bash
docker build -t test .
docker run test
```

5. **Remove old files (optional):**
```bash
rm requirements.txt requirements-dev.txt
```

## Common Commands

### uv Commands

```bash
# Install package
uv pip install package-name

# Install from pyproject.toml
uv pip install -e .

# Install with dev dependencies
uv pip install -e ".[dev]"

# Update all packages
uv pip install --upgrade -e .

# Create virtual environment
uv venv

# List installed packages
uv pip list
```

### pip Commands

```bash
# Install package
pip install package-name

# Install from requirements.txt
pip install -r requirements.txt

# Update all packages
pip install --upgrade -r requirements.txt

# Create virtual environment
python -m venv venv

# List installed packages
pip list

# Export dependencies
pip freeze > requirements.txt
```

## Project Structure Examples

### Using uv
```
my-app/
├── pyproject.toml        # Dependencies and config
├── Dockerfile            # Auto-detects pyproject.toml
├── main.py
├── tests/
└── .venv/                # Virtual environment
```

### Using pip
```
my-app/
├── requirements.txt      # Production dependencies
├── requirements-dev.txt  # Development dependencies
├── Dockerfile            # Auto-detects requirements.txt
├── main.py
├── tests/
└── venv/                 # Virtual environment
```

## Troubleshooting

### uv not found in Docker
The Dockerfile installs uv automatically. If you see errors, ensure curl is installed in the builder stage.

### Wrong package manager used
The Dockerfile prioritizes `pyproject.toml` over `requirements.txt`. If you have both:
- Remove `requirements.txt` to use uv
- Remove `pyproject.toml` to use pip

### CI failing with uv
Check that the GitHub Actions workflow has the uv installation step:
```yaml
- name: Install uv (if using pyproject.toml)
  if: hashFiles('pyproject.toml') != ''
  run: curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Virtual environment issues
Ensure you activate the virtual environment:
```bash
# uv
source .venv/bin/activate

# pip
source venv/bin/activate
```

## Resources

- [uv Documentation](https://github.com/astral-sh/uv)
- [PEP 621 - Storing project metadata in pyproject.toml](https://peps.python.org/pep-0621/)
- [Python Packaging Guide](https://packaging.python.org/)

## Recommendation

**For this boilerplate, we recommend:**
- 🆕 **New projects**: Use `uv` + `pyproject.toml`
- 📦 **Existing projects**: Keep using `pip` + `requirements.txt` (or migrate when ready)
- 🚀 **Performance critical**: Use `uv` (significantly faster builds)

Both are fully supported with zero configuration needed! The Dockerfile and CI workflows handle everything automatically.
