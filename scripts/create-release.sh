#!/bin/bash

# Script to create a new release
# Usage: ./scripts/create-release.sh [version]
# Example: ./scripts/create-release.sh 1.0.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Release Creation Script ===${NC}\n"

# Check if version is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Version number required${NC}"
    echo "Usage: ./scripts/create-release.sh [version]"
    echo "Example: ./scripts/create-release.sh 1.0.0"
    exit 1
fi

VERSION=$1

# Add 'v' prefix if not present
if [[ ! $VERSION =~ ^v ]]; then
    VERSION="v$VERSION"
fi

# Validate version format
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format${NC}"
    echo "Version must be in format: v1.0.0"
    exit 1
fi

echo -e "${YELLOW}Version:${NC} $VERSION"

# Check if we're on main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}Error: Must be on main branch to create release${NC}"
    echo -e "Current branch: ${YELLOW}$CURRENT_BRANCH${NC}"
    echo ""
    read -p "Switch to main branch? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git checkout main
    else
        exit 1
    fi
fi

# Check if working directory is clean
if [[ -n $(git status -s) ]]; then
    echo -e "${RED}Error: Working directory is not clean${NC}"
    echo "Please commit or stash your changes first"
    git status -s
    exit 1
fi

# Pull latest changes
echo -e "\n${YELLOW}Pulling latest changes...${NC}"
git pull origin main

# Check if tag already exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo -e "${RED}Error: Tag $VERSION already exists${NC}"
    exit 1
fi

# Get previous tag for changelog
PREVIOUS_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -z "$PREVIOUS_TAG" ]; then
    echo -e "\n${YELLOW}This will be the first release${NC}"
else
    echo -e "\n${YELLOW}Previous version:${NC} $PREVIOUS_TAG"
    echo -e "\n${YELLOW}Changes since last release:${NC}"
    git log $PREVIOUS_TAG..HEAD --oneline --no-merges | head -10

    COMMIT_COUNT=$(git rev-list $PREVIOUS_TAG..HEAD --count --no-merges)
    if [ "$COMMIT_COUNT" -gt 10 ]; then
        echo "... and $((COMMIT_COUNT - 10)) more commits"
    fi
fi

# Confirm release
echo ""
echo -e "${YELLOW}Ready to create release $VERSION${NC}"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Release cancelled"
    exit 0
fi

# Ask for release message
echo ""
echo "Enter release message (press Enter for default):"
read -r RELEASE_MESSAGE

if [ -z "$RELEASE_MESSAGE" ]; then
    RELEASE_MESSAGE="Release $VERSION"
fi

# Create and push tag
echo -e "\n${YELLOW}Creating tag...${NC}"
git tag -a "$VERSION" -m "$RELEASE_MESSAGE"

echo -e "${YELLOW}Pushing tag to remote...${NC}"
git push origin "$VERSION"

echo -e "\n${GREEN}✅ Release $VERSION created successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Check GitHub Actions for build status:"
echo "   https://github.com/$(git config --get remote.origin.url | sed 's/.*:\(.*\)\.git/\1/')/actions"
echo ""
echo "2. View the release when ready:"
echo "   https://github.com/$(git config --get remote.origin.url | sed 's/.*:\(.*\)\.git/\1/')/releases"
echo ""
echo "3. Pull the image:"
echo "   docker pull ghcr.io/$(git config --get remote.origin.url | sed 's/.*:\(.*\)\.git/\1/' | tr '[:upper:]' '[:lower:]'):$VERSION"
