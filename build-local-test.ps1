# Local multi-platform build test script (PowerShell)
# This script builds the Docker image for both platforms but loads it locally for testing

param(
    [string]$Tag = "test",
    [string]$MasscanCommit = ""  # empty = commit pinned in src/Dockerfile
)

$ImageName = "masscan"
$ErrorActionPreference = "Stop"
$BuildDate = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
$VcsRef = (git rev-parse HEAD)
$CommitArg = if ($MasscanCommit) { @("--build-arg", "MASSCAN_COMMIT=${MasscanCommit}") } else { @() }

Write-Host "Building multi-platform Docker image locally: ${ImageName}:${Tag}" -ForegroundColor Green

# Create and use a new builder instance that supports multi-platform builds
try {
    docker buildx create --name multiplatform-builder --use --bootstrap 2>$null
} catch {
    docker buildx use multiplatform-builder
}

# Build for multiple platforms and load to local Docker
# Note: --load only works with single platform, so we'll build each separately
Write-Host "Building for AMD64..." -ForegroundColor Yellow
docker buildx build `
    --file src/Dockerfile `
    --platform linux/amd64 `
    --tag "${ImageName}:${Tag}-amd64" `
    --build-arg VERSION="${Tag}" `
    --build-arg BUILD_DATE="${BuildDate}" `
    --build-arg VCS_REF="${VcsRef}" `
    @CommitArg `
    --load `
    .

Write-Host "Building for ARM64..." -ForegroundColor Yellow
docker buildx build `
    --file src/Dockerfile `
    --platform linux/arm64 `
    --tag "${ImageName}:${Tag}-arm64" `
    --build-arg VERSION="${Tag}" `
    --build-arg BUILD_DATE="${BuildDate}" `
    --build-arg VCS_REF="${VcsRef}" `
    @CommitArg `
    --load `
    .

Write-Host "✅ Multi-platform build complete!" -ForegroundColor Green
Write-Host "Images built:" -ForegroundColor Yellow
Write-Host "  - ${ImageName}:${Tag}-amd64 (linux/amd64)" -ForegroundColor Cyan
Write-Host "  - ${ImageName}:${Tag}-arm64 (linux/arm64)" -ForegroundColor Cyan

Write-Host "`nTesting AMD64 image..." -ForegroundColor Yellow
docker run --rm "${ImageName}:${Tag}-amd64" --help | Select-Object -First 5
