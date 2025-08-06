# Multi-Platform Docker Build Guide

This guide shows how to build the masscan Docker image for both AMD64 and ARM64 architectures.

## Prerequisites

- Docker Desktop with Buildx enabled
- PowerShell (Windows) or Bash (Linux/macOS)

## Quick Start

### 1. Set up Docker Buildx

```powershell
# Create a new builder instance for multi-platform builds
docker buildx create --name multiplatform-builder --use --bootstrap
```

### 2. Build for Multiple Platforms

#### Option A: Build and Push to Registry

```powershell
# Build for both platforms and push to registry
docker buildx build `
    --file src/Dockerfile `
    --platform linux/amd64,linux/arm64 `
    --tag your-registry/masscan:latest `
    --push `
    .
```

#### Option B: Build for Local Testing

```powershell
# Build for AMD64 (local testing)
docker buildx build `
    --file src/Dockerfile `
    --platform linux/amd64 `
    --tag masscan:latest-amd64 `
    --load `
    .

# Build for ARM64 (local testing)
docker buildx build `
    --file src/Dockerfile `
    --platform linux/arm64 `
    --tag masscan:latest-arm64 `
    --load `
    .
```

### 3. Test the Images

```powershell
# Test AMD64 image (will work on x86 machines)
docker run --rm masscan:latest-amd64 --help

# ARM64 image will show platform warning on x86 but confirms it's built correctly
docker run --rm masscan:latest-arm64 --help
```

## Automated Builds with GitHub Actions

The repository includes a GitHub Actions workflow that automatically builds multi-platform images when you create a new release tag.

### To trigger an automated build:

1. Create and push a new tag:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

2. The workflow will automatically:
   - Build for `linux/amd64` and `linux/arm64`
   - Push to GitHub Container Registry
   - Tag with the version number

## Using the Scripts

### PowerShell Scripts (Windows)

1. **`build-multiplatform.ps1`** - Build and push to registry
   ```powershell
   .\build-multiplatform.ps1 -Tag "v1.0.1" -Registry "ghcr.io/vic10us"
   ```

2. **`build-local-test.ps1`** - Build for local testing
   ```powershell
   .\build-local-test.ps1 -Tag "test"
   ```

### Bash Scripts (Linux/macOS)

1. **`build-multiplatform.sh`** - Build and push to registry
   ```bash
   ./build-multiplatform.sh v1.0.1 ghcr.io/vic10us
   ```

## Platform-Specific Usage

### AMD64 (Intel/AMD x86_64)
- Works on most development machines
- Fast build times
- Direct execution without emulation

### ARM64 (Apple Silicon, AWS Graviton, etc.)
- Works on Apple Silicon Macs, ARM-based servers
- Slower build times when cross-compiling
- Better performance on native ARM hardware

## Supported Platforms

- `linux/amd64` - Intel/AMD 64-bit
- `linux/arm64` - ARM 64-bit (Apple Silicon, AWS Graviton, etc.)

## Build Times

- **AMD64**: ~1-2 minutes
- **ARM64**: ~7-10 minutes (when cross-compiling on x86)
- **Both platforms**: ~10-12 minutes total

## Registry Examples

### GitHub Container Registry
```powershell
docker buildx build `
    --platform linux/amd64,linux/arm64 `
    --tag ghcr.io/vic10us/masscan:latest `
    --push `
    .
```

### Docker Hub
```powershell
docker buildx build `
    --platform linux/amd64,linux/arm64 `
    --tag dockerhub-username/masscan:latest `
    --push `
    .
```

### AWS ECR
```powershell
docker buildx build `
    --platform linux/amd64,linux/arm64 `
    --tag 123456789012.dkr.ecr.us-west-2.amazonaws.com/masscan:latest `
    --push `
    .
```

## Troubleshooting

### "exec format error"
This is normal when trying to run an ARM64 image on x86 hardware. The image built successfully but can't run without emulation.

### Slow ARM64 builds
ARM64 builds use emulation on x86 machines, which is slower. This is expected behavior.

### Builder not found
Run the setup command again:
```powershell
docker buildx create --name multiplatform-builder --use --bootstrap
```

## Verification

To verify your multi-platform image was built correctly:

```powershell
# Check image details
docker buildx imagetools inspect your-registry/masscan:latest
```

This will show both `linux/amd64` and `linux/arm64` manifests if successful.
