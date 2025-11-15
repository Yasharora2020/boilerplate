# Claude Code Integration Guide

How to use this boilerplate effectively with Claude Code, the official Claude AI IDE.

## Overview

This boilerplate is optimized for Claude Code, with proper context, instructions, and documentation for AI-assisted development.

## Key Files for Claude

### CLAUDE.md (Project Context)
```
CLAUDE.md
```

Located at the root, this file provides Claude with:
- Project overview and features
- Architecture patterns
- Development rules and conventions
- CI/CD pipeline explanations
- Project structure for both Python and Next.js
- Development workflow
- Commit conventions

**Keep this updated** when you:
- Change architecture patterns
- Add new conventions
- Modify CI/CD setup
- Change project structure

### Documentation Structure

All documentation is organized in `/docs/`:

```
docs/
├── setup/      # Getting started guides
├── develop/    # Development standards and patterns
├── operate/    # Operations, CI/CD, troubleshooting
└── release/    # Versioning and release management
```

Claude can reference these docs directly:
- `docs/develop/PYTHON_PATTERNS.md` - Python standards
- `docs/develop/NEXTJS_PATTERNS.md` - Next.js standards
- `docs/develop/TESTING_GUIDE.md` - Testing strategies
- `docs/operate/CI_CD_GUIDE.md` - GitHub Actions setup
- `docs/operate/TROUBLESHOOTING.md` - Common issues

## Using Claude Code

### Starting with Claude

1. **Reference this boilerplate:**
   ```
   Please help me set up this boilerplate for my project
   ```

2. **Ask about patterns:**
   ```
   How should I structure a new API endpoint following
   the Python patterns in docs/develop/PYTHON_PATTERNS.md?
   ```

3. **Get code assistance:**
   ```
   Add a new user authentication endpoint to the FastAPI app
   following the patterns in PYTHON_PATTERNS.md
   ```

4. **Reference documentation:**
   ```
   Help me debug this CI/CD issue.
   See: docs/operate/TROUBLESHOOTING.md
   ```

### Best Practices When Using Claude

1. **Be specific about documentation:**
   ```
   ✅ Good
   Following the patterns in docs/develop/PYTHON_PATTERNS.md,
   please create a new service for user management.

   ❌ Vague
   Help me write a user service.
   ```

2. **Reference CLAUDE.md for context:**
   ```
   ✅ Good
   I'm following the project conventions in CLAUDE.md.
   Please implement a feature that handles user authentication.

   ❌ Missing context
   Add authentication.
   ```

3. **Ask for multiple approaches:**
   ```
   I need to handle errors in my API.
   Show me how to implement custom exceptions
   according to the patterns in docs/develop/PYTHON_PATTERNS.md
   ```

4. **Test Claude's code locally:**
   ```bash
   # Before committing, always test
   pytest tests/
   npm test
   docker build -t test .
   ```

## Workflow Examples

### Example 1: Adding a Python Endpoint

```
Hi Claude, I need to add a new endpoint to get user profiles.

The project follows the patterns in docs/develop/PYTHON_PATTERNS.md
and the code structure in docs/develop/PYTHON_PATTERNS.md.

Please:
1. Create a UserProfile Pydantic model
2. Add a GET endpoint in the users router
3. Include proper error handling and validation
4. Write tests following the patterns in docs/develop/TESTING_GUIDE.md
```

### Example 2: Creating a Next.js Component

```
I need to create a user settings form in Next.js.

This project follows:
- Next.js patterns from docs/develop/NEXTJS_PATTERNS.md
- Using Server Actions for mutations
- Zod validation for all inputs

Please create:
1. A server action for updating user settings
2. A client component for the form
3. Proper error handling and loading states
4. Tests following docs/develop/TESTING_GUIDE.md
```

### Example 3: Debugging CI/CD

```
The GitHub Actions workflow is failing.

Details:
- Error: [insert error message]
- Workflow: [ci.yml or release.yml]

Please help debug this following the troubleshooting
guide at docs/operate/TROUBLESHOOTING.md
```

## Claude-Specific Settings

### .claude/settings.json

You can customize Claude Code behavior:

```json
{
  "ignore": [
    "node_modules/",
    ".venv/",
    "dist/",
    ".git/"
  ],
  "contextLength": "auto"
}
```

### .claude/docs/ (Optional)

You can add additional documentation for Claude:

```
.claude/docs/
├── custom-patterns.md      # Your custom coding patterns
├── deployment-guide.md     # Your deployment process
└── team-conventions.md     # Your team's specific conventions
```

## Helpful Prompts

### For Code Review
```
Please review this code following the standards in docs/develop/[PYTHON/NEXTJS]_PATTERNS.md.

Check for:
- Type hints and documentation
- Error handling
- Code organization
- Test coverage
```

### For Bug Fixes
```
This test is failing: [test name]

According to docs/develop/TESTING_GUIDE.md, please help me:
1. Understand what the test expects
2. Fix the implementation
3. Add missing tests if needed
```

### For New Features
```
I need to implement [feature].

This project follows:
- CLAUDE.md for conventions
- docs/develop/[FRAMEWORK]_PATTERNS.md for patterns
- docs/develop/TESTING_GUIDE.md for testing

Please implement with:
1. Code following the patterns
2. Comprehensive tests
3. Documentation in docstrings
```

### For Documentation
```
Create documentation for [feature] following the style of
the existing guides in docs/

Include:
- Overview and purpose
- Usage examples
- Best practices
- Troubleshooting
```

## Sharing Context with Claude

### Method 1: Reference Documentation
Instead of copying long code/docs into chat:
```
Please review my implementation against the patterns
in docs/develop/PYTHON_PATTERNS.md
```

### Method 2: Reference Specific Files
```
Based on the testing patterns in docs/develop/TESTING_GUIDE.md,
help me write tests for [feature]
```

### Method 3: Use File Context
Claude can see files in your project. You can ask:
```
Looking at the structure in app/api/v1/endpoints/users.py,
please create a similar endpoint for [feature]
```

## Keeping Claude in Sync

### Update CLAUDE.md When:
- Adding new project conventions
- Changing code organization
- Updating development rules
- Modifying CI/CD significantly

### Update docs/ When:
- Adding new patterns or best practices
- Creating guides for complex features
- Documenting new tools/libraries
- Adding team-specific conventions

### Tell Claude About Changes:
```
I've updated CLAUDE.md with new conventions.
Please review and follow these from now on:
[key changes]
```

## Limitations and Tips

### Be Specific About Requirements
❌ "Add authentication"
✅ "Add JWT-based authentication following the patterns in PYTHON_PATTERNS.md"

### Test Everything Claude Writes
```bash
# Always test before committing
pytest tests/
npm test
docker build -t test .
```

### Verify Documentation References
```
The pattern I mentioned is in docs/develop/PYTHON_PATTERNS.md
section "Error Handling"
```

### Use Conventional Commits
```bash
# Claude will understand commit conventions in CLAUDE.md
git commit -m "feat: add user authentication system"
git commit -m "fix: resolve login redirect issue"
```

## Troubleshooting Claude

### Claude Suggests Non-Standard Code
```
That doesn't follow the pattern in docs/develop/PYTHON_PATTERNS.md.
Please revise to use [specific pattern].
```

### Claude Forgets Project Context
```
Remember that this project:
1. Uses [convention from CLAUDE.md]
2. Follows patterns in docs/develop/[framework]_PATTERNS.md
3. [Another key detail]

Please revise with this context.
```

### Claude Creates Tests Incorrectly
```
Please write tests following the structure in docs/develop/TESTING_GUIDE.md.

Specifically:
- Use [testing framework] fixtures
- Follow the AAA pattern
- Include [specific test case]
```

## Best Practices

1. **Keep CLAUDE.md updated** - It's Claude's main reference
2. **Reference docs consistently** - Use the same paths
3. **Test all code** - Don't trust Claude without verification
4. **Review for patterns** - Ensure code follows your standards
5. **Commit atomically** - Small, focused commits with good messages
6. **Add docstrings** - Help Claude (and humans) understand code
7. **Keep tests passing** - CI/CD is your safety net

## Resources

- [Claude Code Documentation](https://code.claude.com/)
- [CLAUDE.md](../../CLAUDE.md) - Project context
- [docs/INDEX.md](../INDEX.md) - Documentation index
- [docs/develop/](../) - All development guides
