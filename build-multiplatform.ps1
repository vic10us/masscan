# Multi-platform Docker build script for masscan (PowerShell)
# This script builds the Docker image for both AMD64 and ARM64 architectures

param(
    [string]$Tag = "latest",
    [string]$Registry = ""
)

$ImageName = "masscan"
$ErrorActionPreference = "Stop"

# Add registry prefix if provided
if ($Registry) {
    $FullImageName = "${Registry}/${ImageName}"
} else {
    $FullImageName = $ImageName
}

Write-Host "Building multi-platform Docker image: ${FullImageName}:${Tag}" -ForegroundColor Green

# Create and use a new builder instance that supports multi-platform builds
try {
    docker buildx create --name multiplatform-builder --use --bootstrap 2>$null
} catch {
    docker buildx use multiplatform-builder
}

# Build for multiple platforms
docker buildx build `
    --file src/Dockerfile `
    --platform linux/amd64,linux/arm64 `
    --tag "${FullImageName}:${Tag}" `
    --push `
    .

Write-Host "✅ Multi-platform build complete!" -ForegroundColor Green
Write-Host "Image: ${FullImageName}:${Tag}" -ForegroundColor Yellow
Write-Host "Platforms: linux/amd64, linux/arm64" -ForegroundColor Yellow
