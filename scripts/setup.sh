#!/bin/bash

# Interactive setup script for boilerplate
# Usage: ./scripts/setup.sh

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════╗
║   Boilerplate Setup Script            ║
╚═══════════════════════════════════════╝
EOF
echo -e "${NC}"

# Check if git is initialized
if [ ! -d .git ]; then
    echo -e "${YELLOW}Git repository not initialized${NC}"
    read -p "Initialize git repository? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git init
        echo -e "${GREEN}✅ Git repository initialized${NC}"
    fi
fi

# Select project type
echo -e "\n${BLUE}Step 1: Select your project type${NC}"
echo "1) Python"
echo "2) Next.js"
read -p "Enter choice (1 or 2): " project_type

if [ "$project_type" == "1" ]; then
    echo -e "${YELLOW}Setting up Python project...${NC}"

    # Copy Dockerfile
    if [ ! -f Dockerfile ]; then
        cp Dockerfile.python.example Dockerfile
        echo -e "${GREEN}✅ Dockerfile created${NC}"
    else
        echo -e "${YELLOW}⚠ Dockerfile already exists, skipping${NC}"
    fi

    # Ask for package manager preference
    echo -e "\n${BLUE}Choose package manager:${NC}"
    echo "1) uv + pyproject.toml (faster, modern - recommended)"
    echo "2) pip + requirements.txt (traditional)"
    read -p "Enter choice (1 or 2): " pkg_manager

    if [ "$pkg_manager" == "1" ]; then
        # Setup uv
        if [ ! -f pyproject.toml ]; then
            cp pyproject.example.toml pyproject.toml
            echo -e "${GREEN}✅ pyproject.toml created${NC}"
        fi
        echo -e "\n${YELLOW}Next steps for Python + uv:${NC}"
        echo "1. Install uv: curl -LsSf https://astral.sh/uv/install.sh | sh"
        echo "2. Edit pyproject.toml and uncomment dependencies"
        echo "3. Run: uv venv && source .venv/bin/activate"
        echo "4. Run: uv pip install -e \".[dev]\""
        echo "5. Update Dockerfile port and start command"
    else
        # Setup pip
        if [ ! -f requirements.txt ]; then
            cp requirements.example.txt requirements.txt
            echo -e "${GREEN}✅ requirements.txt created${NC}"
        fi
        if [ ! -f requirements-dev.txt ]; then
            cp requirements-dev.example.txt requirements-dev.txt
            echo -e "${GREEN}✅ requirements-dev.txt created${NC}"
        fi
        echo -e "\n${YELLOW}Next steps for Python + pip:${NC}"
        echo "1. Edit requirements.txt and add your dependencies"
        echo "2. Create venv: python -m venv venv"
        echo "3. Activate: source venv/bin/activate"
        echo "4. Install: pip install -r requirements.txt"
        echo "5. Update Dockerfile port and start command"
    fi

elif [ "$project_type" == "2" ]; then
    echo -e "${YELLOW}Setting up Next.js project...${NC}"

    # Copy Dockerfile
    if [ ! -f Dockerfile ]; then
        cp Dockerfile.nextjs.example Dockerfile
        echo -e "${GREEN}✅ Dockerfile created${NC}"
    else
        echo -e "${YELLOW}⚠ Dockerfile already exists, skipping${NC}"
    fi

    # Copy next.config.js if doesn't exist
    if [ ! -f next.config.js ] && [ ! -f next.config.mjs ]; then
        cp next.config.example.js next.config.js
        echo -e "${GREEN}✅ next.config.js created${NC}"
    fi

    # Copy package.json if doesn't exist
    if [ ! -f package.json ]; then
        cp package.example.json package.json
        echo -e "${GREEN}✅ package.json created (template)${NC}"
    fi

    echo -e "\n${YELLOW}Next steps for Next.js:${NC}"
    echo "1. Ensure next.config.js has: output: 'standalone'"
    echo "2. Update package.json with your dependencies"
    echo "3. Edit .github/workflows/ci.yml to add test commands"
else
    echo -e "${YELLOW}Invalid choice, skipping project setup${NC}"
fi

# Copy CHANGELOG if doesn't exist
if [ ! -f CHANGELOG.md ]; then
    echo -e "\n${BLUE}Step 2: Create CHANGELOG.md?${NC}"
    read -p "Create CHANGELOG.md? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp CHANGELOG.example.md CHANGELOG.md
        echo -e "${GREEN}✅ CHANGELOG.md created${NC}"
    fi
fi

# Create branches
echo -e "\n${BLUE}Step 3: Create branches${NC}"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

if [ -n "$CURRENT_BRANCH" ]; then
    echo -e "Current branch: ${YELLOW}$CURRENT_BRANCH${NC}"

    # Check if develop branch exists
    if ! git show-ref --verify --quiet refs/heads/develop; then
        read -p "Create develop branch? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git checkout -b develop 2>/dev/null || git checkout develop
            echo -e "${GREEN}✅ Develop branch created${NC}"
        fi
    else
        echo -e "${GREEN}✅ Develop branch already exists${NC}"
    fi
fi

# Summary
echo -e "\n${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════╗
║   Setup Complete!                     ║
╚═══════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo "1. Push to GitHub:"
echo "   git add ."
echo "   git commit -m \"chore: initial setup\""
echo "   git push origin main"
echo "   git push origin develop"
echo ""
echo "2. Configure GitHub:"
echo "   - Go to repository Settings → Actions → General"
echo "   - Enable 'Read and write permissions'"
echo ""
echo "3. Start developing:"
echo "   git checkout develop"
echo "   # Make your changes"
echo "   git push origin develop"
echo ""
echo "4. Create your first release:"
echo "   ./scripts/create-release.sh 1.0.0"
echo ""
echo -e "${BLUE}📖 Documentation:${NC}"
echo "   - README.md - Quick start guide"
echo "   - docs/GITHUB_ACTIONS_SETUP.md - CI/CD setup"
echo "   - docs/VERSIONING_GUIDE.md - Versioning guide"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
