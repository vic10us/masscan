# Recommended GitHub Repository Settings

## Branch Protection Rules
Set up branch protection for `main` branch:

### Protection Settings:
- ✅ Require pull request reviews before merging
- ✅ Require status checks to pass before merging
- ✅ Required status checks:
  - `test` (from CI workflow)
  - `dockerfile-lint` (from CI workflow)
- ✅ Require branches to be up to date before merging
- ✅ Require signed commits
- ✅ Include administrators
- ✅ Allow force pushes (disabled)
- ✅ Allow deletions (disabled)

## GitHub Environment Settings

### Production Environment:
- **Environment name:** `production`
- **Protection rules:**
  - Required reviewers: Repository admins
  - Wait timer: 0 minutes
  - Deployment branches: Only protected branches

### Environment Secrets:
- `DOCKER_REGISTRY_TOKEN` (if using external registry)
- `SLACK_WEBHOOK` (for notifications)

## Repository Secrets:
- `GITHUB_TOKEN` (automatically provided)
- Any additional registry tokens if needed

## Repository Settings:
- ✅ Enable vulnerability alerts
- ✅ Enable automated security updates
- ✅ Enable secret scanning
- ✅ Enable push protection for secrets
- ✅ Allow auto-merge pull requests
- ✅ Delete head branches automatically

## Code Security & Analysis:
- ✅ Enable CodeQL analysis
- ✅ Enable Dependabot alerts
- ✅ Enable Dependabot security updates
- ✅ Enable Dependabot version updates
