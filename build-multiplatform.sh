#!/bin/bash

# Multi-platform Docker build script for masscan
# This script builds the Docker image for both AMD64 and ARM64 architectures

set -e

IMAGE_NAME="masscan"
TAG="${1:-latest}"
REGISTRY="${2:-}"

# Add registry prefix if provided
if [ -n "$REGISTRY" ]; then
    FULL_IMAGE_NAME="${REGISTRY}/${IMAGE_NAME}"
else
    FULL_IMAGE_NAME="${IMAGE_NAME}"
fi

echo "Building multi-platform Docker image: ${FULL_IMAGE_NAME}:${TAG}"

# Create and use a new builder instance that supports multi-platform builds
docker buildx create --name multiplatform-builder --use --bootstrap 2>/dev/null || docker buildx use multiplatform-builder

# Build for multiple platforms
docker buildx build \
    --file src/Dockerfile \
    --platform linux/amd64,linux/arm64 \
    --tag "${FULL_IMAGE_NAME}:${TAG}" \
    --push \
    .

echo "✅ Multi-platform build complete!"
echo "Image: ${FULL_IMAGE_NAME}:${TAG}"
echo "Platforms: linux/amd64, linux/arm64"
