# CI/CD Troubleshooting Guide

Common issues and solutions for the GitHub Actions CI/CD workflows.

## Workflow Not Triggering

**Problem:** Pushed to branch but CI didn't run

**Solutions:**
- Check Actions tab → ensure workflows are enabled
- Verify branch name matches workflow trigger (`main`, `develop`)
- Check if workflows are disabled in repository settings

---

## Authentication Error Pushing to GHCR

**Problem:** `ERROR: failed to push: denied`

**Solutions:**
1. Check workflow permissions:
   - Settings → Actions → General
   - Enable "Read and write permissions"

2. Manually create token (if needed):
   - Settings → Developer settings → Personal access tokens
   - Create token with `write:packages` scope
   - Add as repository secret named `GHCR_TOKEN`
   - Update workflow to use secret

---

## Build Failing

**Problem:** Docker build fails in workflow

**Solutions:**
1. Test locally:
```bash
docker build -t test .
```

2. Check Dockerfile syntax
3. Verify all required files exist
4. Check workflow logs for specific error

---

## Trivy Scan Blocking Release

**Problem:** Security scan finds vulnerabilities

**Solutions:**
1. Update dependencies:
   - Python: Update `requirements.txt`
   - Node: Run `npm audit fix`

2. Review vulnerabilities:
   - Check Security tab
   - Assess severity
   - Update affected packages

3. Temporarily allow (not recommended):
   - Change `exit-code: '0'` in workflow

---

## Tag Not Creating Release

**Problem:** Pushed tag but release workflow didn't run

**Solutions:**
- Verify tag format: Must be `v*.*.*` (e.g., `v1.0.0`)
- Check tag was pushed: `git push origin v1.0.0`
- Check Actions tab for errors
- Ensure release.yml exists and is valid

---

## Image Not Pulling

**Problem:** `docker pull` fails with auth error

**Solutions:**
1. Login to GHCR:
```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

2. Make package public:
   - Profile → Packages → Select package
   - Settings → Change visibility

3. Use correct image name:
```bash
ghcr.io/username/repo:tag  # All lowercase
```

---

## Multi-platform Build Slow

**Problem:** Release takes too long

**Solutions:**
- Use Docker layer caching (already enabled)
- Reduce number of platforms if not needed
- Optimize Dockerfile:
  - Minimize layers
  - Use smaller base images
  - Order commands by change frequency

---

## Docker Image Not Found

**Problem:** Can't pull image after successful build

**Solutions:**
1. Wait a few seconds for image to be available
2. Check that push step didn't fail (check workflow logs)
3. Verify GHCR push step in workflow completed
4. Make package public if it's private
5. Use exact tag name that was pushed

---

## Tests Failing in CI

**Problem:** Tests pass locally but fail in workflow

**Solutions:**
1. Check that test setup is identical:
   - Same Python/Node version
   - Same dependency versions
   - Same environment variables

2. Ensure test databases or services are set up:
   - Check if Docker services needed
   - Verify connection strings in CI environment

3. Add verbose logging:
   - Use `-v` or `--verbose` flags in test command
   - Check workflow logs for specific failure

4. Test locally with same environment:
   ```bash
   # Simulate GitHub Actions environment
   python -m pip install -r requirements.txt
   pytest -v
   ```

---

## Workflow Timeout

**Problem:** Workflow takes too long and times out

**Solutions:**
1. Check job-level timeout in workflow:
   ```yaml
   jobs:
     test:
       timeout-minutes: 60  # Increase if needed
   ```

2. Optimize slow steps:
   - Enable caching for dependencies
   - Run tests in parallel
   - Skip unnecessary steps for certain branches

3. Check for hanging processes:
   - Add timeouts to test commands
   - Ensure no infinite loops in code

---

## Cache Not Working

**Problem:** Dependencies not cached between runs

**Solutions:**
1. Check cache setup in workflow is correct:
   ```yaml
   - uses: actions/setup-python@v5
     with:
       cache: 'pip'  # For Python

   - uses: actions/setup-node@v4
     with:
       cache: 'npm'  # For Node
   ```

2. Verify cache key hasn't changed:
   - Cache busts if `requirements.txt` or `package.json` changes (which is good!)
   - First run after dependency update will be slow

3. Clear cache manually if needed:
   - Settings → Actions → Caches
   - Delete problematic cache entries

---

## Environment Variables Not Available

**Problem:** `${{ env.VAR }}` is empty in workflow

**Solutions:**
1. Verify env variable is defined in workflow file:
   ```yaml
   env:
     MY_VAR: value
   ```

2. For secrets, use proper syntax:
   ```yaml
   env:
     MY_SECRET: ${{ secrets.MY_SECRET }}
   ```

3. Check that secret exists in repository settings:
   - Settings → Secrets and variables → Actions
   - Verify secret name matches exactly

---

## GitHub Release Not Created

**Problem:** Tag pushed but no release created

**Solutions:**
1. Verify release workflow completed:
   - Check Actions tab
   - Look for any errors in release.yml

2. Check release tag format:
   - Must be `v*.*.*` (e.g., `v1.0.0`)
   - Cannot have other characters

3. Manually check releases:
   - Repository → Releases tab
   - If not there, workflow failed

4. Check workflow file:
   - `.github/workflows/release.yml` should exist
   - Should be valid YAML

---

## Changelog Not Generated

**Problem:** Release created but no changelog in description

**Solutions:**
1. Use conventional commits for better changelog:
   ```bash
   git commit -m "feat: add new feature"
   git commit -m "fix: resolve bug"
   ```

2. Check that commits exist between releases:
   - Changelog generated from commit messages since last tag

3. Check release.yml for changelog generation step:
   - Should have step that parses conventional commits

---

## Security Scan Results Not Showing

**Problem:** Trivy scan completes but results not in Security tab

**Solutions:**
1. Check workflow has SARIF upload step:
   ```yaml
   - name: Upload SARIF
     uses: github/codeql-action/upload-sarif@v2
   ```

2. Verify SARIF format is correct in workflow

3. Check repository security settings:
   - Security tab is enabled
   - Dependency scanning is enabled

4. Wait a few minutes for results to appear

---

## Image Size Too Large

**Problem:** Docker image takes too long to push/pull

**Solutions:**
1. Optimize Dockerfile:
   - Use multi-stage builds (already in template)
   - Remove build dependencies in final image
   - Use smaller base images (Alpine if possible)

2. Reduce layer count:
   - Combine RUN commands
   - Remove unnecessary files

3. Example optimization:
   ```dockerfile
   # Bad: 2 layers
   RUN apt-get update
   RUN apt-get install -y python3

   # Good: 1 layer
   RUN apt-get update && apt-get install -y python3
   ```

---

## Workflow File Syntax Error

**Problem:** `Invalid workflow file` error

**Solutions:**
1. Validate YAML syntax:
   - Use online YAML validators
   - Check for indentation (spaces, not tabs)

2. Check workflow file:
   - `.github/workflows/ci.yml` and `release.yml`
   - Verify structure matches examples

3. Run locally:
   ```bash
   # Install GitHub CLI
   gh workflow view .github/workflows/ci.yml
   ```

---

## Permission Denied on Checkout

**Problem:** `fatal: could not read Username/Password` during checkout

**Solutions:**
1. Check `GITHUB_TOKEN` is available:
   ```yaml
   - uses: actions/checkout@v4
     with:
       token: ${{ secrets.GITHUB_TOKEN }}
   ```

2. Verify repository permissions are correct:
   - Settings → Actions → General
   - Check "Read and write permissions"

3. For private repositories, ensure token has right scope:
   - Personal access token with `repo` scope

---

## Multi-arch Image Issues

**Problem:** arm64 build fails but amd64 succeeds

**Solutions:**
1. Test on both architectures:
   ```bash
   docker buildx build --platform linux/amd64,linux/arm64 .
   ```

2. Check Dockerfile for architecture-specific issues:
   - Some packages may only exist for x86_64
   - Use architecture-agnostic base images

3. Reduce platforms temporarily to debug:
   ```yaml
   platforms: linux/amd64  # Just test amd64 first
   ```

---

## Container Fails to Start

**Problem:** Image builds successfully but fails when running

**Solutions:**
1. Test image locally:
   ```bash
   docker build -t test .
   docker run test
   ```

2. Check logs:
   ```bash
   docker run test  # See error output
   docker logs <container-id>
   ```

3. Verify:
   - Working directory exists
   - Port mappings correct
   - Environment variables set
   - All dependencies installed

---

## Getting Help

If you're stuck:

1. **Check workflow logs:**
   - Repository → Actions → Select workflow run
   - Click failed job for detailed logs

2. **Check Security tab:**
   - Repository → Security → Code scanning alerts
   - May show dependency or code issues

3. **Enable debug logging:**
   - Add to workflow step: `runner-debug: true`
   - Provides more verbose output

4. **Resources:**
   - [GitHub Actions Docs](https://docs.github.com/en/actions)
   - [Docker Docs](https://docs.docker.com)
   - [Trivy Scanner Issues](https://github.com/aquasecurity/trivy/issues)

5. **Debugging locally:**
   - Reproduce issue locally first
   - Simplify to minimal test case
   - Check exact error message
