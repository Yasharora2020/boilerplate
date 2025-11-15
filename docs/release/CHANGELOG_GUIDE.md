# Changelog Guide

How to maintain a CHANGELOG.md file for your project to document changes across versions.

## What is a Changelog?

A changelog is a file that documents all notable changes to your project. It helps users understand what changed, what was added, and what was fixed in each version.

**Benefits:**
- 📋 Users know what changed between versions
- 🔍 Easy to see bug fixes and features
- 🚀 Shows project activity and maturity
- 📖 Great for documentation

## Format

This boilerplate uses the **Keep a Changelog** format, which follows Semantic Versioning.

### File Location
```
CHANGELOG.md
```

### Basic Structure
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New features being worked on

### Changed
- Changes to existing functionality

### Deprecated
- Features to be removed soon

### Removed
- Features that are removed

### Fixed
- Bug fixes

### Security
- Security fixes and improvements

## [1.0.0] - 2024-01-15

### Added
- Initial release
- Core functionality

### Fixed
- Initial bugs
```

## Sections Explained

### [Unreleased]
Work-in-progress section for the next release. Update this as you develop.

### Added
New features, endpoints, or capabilities added in this version.

**Example:**
```markdown
### Added
- User authentication with JWT
- Email verification system
- Export to CSV functionality
```

### Changed
Changes to existing functionality (backwards compatible).

**Example:**
```markdown
### Changed
- Improved login performance
- Updated API response format
- Refactored database queries
```

### Deprecated
Features that will be removed in a future version. Warn users here.

**Example:**
```markdown
### Deprecated
- Old `/api/v1/users` endpoint (use `/api/v2/users` instead)
- XML export format (will be removed in v2.0.0)
```

### Removed
Features that are no longer available. List what users should do instead.

**Example:**
```markdown
### Removed
- Support for Python 3.8 (minimum now 3.9)
- Old XML export feature (use JSON instead)
- Deprecated `/api/v1/` endpoints
```

### Fixed
Bug fixes and patches.

**Example:**
```markdown
### Fixed
- Memory leak in image processing
- Login redirect issue
- Unicode handling in filenames
```

### Security
Security-related changes, patches, and vulnerability fixes.

**Example:**
```markdown
### Security
- Fixed SQL injection vulnerability in search
- Updated dependencies to patch CVE-2024-1234
- Improved password hashing algorithm
```

## Workflow

### During Development

As you work on features and fixes, add them to the `[Unreleased]` section:

```markdown
## [Unreleased]

### Added
- User profile customization
- Dark mode support

### Fixed
- Login button not responding on mobile
- Typo in documentation
```

### When Creating a Release

When you create a release tag (e.g., `v1.1.0`):

1. **Change `[Unreleased]` to version and date:**
```markdown
## [1.1.0] - 2024-01-15
```

2. **Create new empty `[Unreleased]` section:**
```markdown
## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [1.0.0] - 2024-01-01
...
```

3. **Commit before or after tagging:**
```bash
git add CHANGELOG.md
git commit -m "docs: update changelog for v1.1.0"
git tag v1.1.0
git push origin main --tags
```

## Full Example

Here's a complete CHANGELOG.md:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Dark mode toggle in settings
- Export to PDF feature

### Changed
- Improved search performance by 40%

### Fixed
- Memory leak in WebSocket connections

## [1.1.0] - 2024-01-15

### Added
- User authentication with JWT tokens
- Email verification system
- Dashboard analytics

### Changed
- Updated UI to new design system
- Improved API response times

### Fixed
- Login page styling issues
- Email notification delays

## [1.0.1] - 2024-01-08

### Fixed
- Critical security vulnerability in password reset
- Database connection timeout issues
- CSV export encoding problem

## [1.0.0] - 2024-01-01

### Added
- Initial release
- User registration and login
- Basic dashboard
- Profile management

### Changed
- N/A (initial release)

### Deprecated
- N/A (initial release)

### Removed
- N/A (initial release)

### Fixed
- N/A (initial release)

### Security
- N/A (initial release)
```

## Tips for Good Changelogs

### ✅ DO:

- **Be specific**
  - "Fixed memory leak in image processing" ✓
  - "Fixed bugs" ✗

- **Group related changes**
  - Organize by feature/area
  - Keep similar changes together

- **Use clear language**
  - Write for end users, not developers
  - Avoid technical jargon where possible

- **Include breaking changes**
  - Always call out breaking changes
  - Suggest migration path if possible

- **Link to more details**
  - Reference issue/PR numbers
  - Link to migration guides

- **Keep it chronological**
  - Newest versions at top
  - Oldest at bottom

### ❌ DON'T:

- **Forgot to update**
  - Update changelog when you make changes
  - Don't do it all at release time

- **Include too much**
  - Only notable changes
  - Skip internal refactors unless important

- **Make it too technical**
  - Remember most users aren't developers
  - "Refactored cache layer" vs "Improved performance"

- **Forget the date**
  - Always include release date
  - Format: YYYY-MM-DD (ISO 8601)

## Automated Changelog Generation

The GitHub Actions release workflow can automatically generate part of the changelog from commit messages.

**To use this feature:**

1. **Use conventional commits**
   ```bash
   git commit -m "feat: add user profiles"
   git commit -m "fix: resolve login bug"
   ```

2. **Commit types:**
   - `feat:` - New feature (→ Added)
   - `fix:` - Bug fix (→ Fixed)
   - `security:` - Security fix (→ Security)
   - `docs:` - Documentation (not usually in changelog)
   - `refactor:` - Code refactoring (usually not in changelog)

3. **The release workflow** will parse these and create initial changelog entries

You can then refine them manually in the release.

## Linking to Release

When you create a release via Git tags, GitHub automatically:
1. Creates a release page
2. Can include changelog excerpt
3. Shows download links

Make your changelog readable on GitHub Releases!

## Multi-Project Changelogs

If you have multiple projects in one repo (monorepo):

```markdown
# Changelog

## [Backend]

### [1.1.0] - 2024-01-15
...

## [Frontend]

### [1.1.0] - 2024-01-15
...
```

Or keep separate `CHANGELOG.md` files in each project folder.

## Version Links

Add links at bottom for easier navigation:

```markdown
---

[Unreleased]: https://github.com/user/repo/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/user/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/user/repo/releases/tag/v1.0.0
```

This makes it easy to compare versions!

## Templates

### Quick Template

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- Feature 1
- Feature 2

### Changed
- Change 1

### Fixed
- Bug 1
- Bug 2

### Security
- Security fix 1
```

### Release Template

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- User authentication

### Changed
- Improved performance

### Deprecated
- Old endpoint (use new one)

### Removed
- Removed deprecated feature

### Fixed
- Security issue

### Security
- Updated vulnerable dependency
```

## Integration with Releases

When creating a release on GitHub:
1. Copy relevant section from CHANGELOG.md
2. Paste into release notes
3. Include link to full changelog
4. Add installation/upgrade instructions

## Best Practices

1. **Update frequently**
   - Add entries as changes are made
   - Don't wait until release time

2. **Be consistent**
   - Use same format throughout
   - Check formatting before release

3. **Include context**
   - Why was it changed?
   - What's the impact?

4. **Be user-focused**
   - What does this mean for users?
   - How does it affect them?

5. **Link to details**
   - Reference issues/PRs
   - Link to documentation

6. **Proofread**
   - Check for typos
   - Ensure clarity

## Tools

Some tools can help manage changelogs:

- **conventional-changelog** - Auto-generate from commits
- **cliff** - Rust tool for changelog generation
- **git-cliff** - Another changelog generator

Or just maintain manually - it's often clearer!

## Resources

- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Release Notes Best Practices](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
