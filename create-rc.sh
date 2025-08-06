#!/bin/bash
# Release Candidate Build Script (Bash)

set -euo pipefail

VERSION=""
RC_NUMBER=1
DRY_RUN=false

usage() {
    echo "Usage: $0 -v VERSION [-r RC_NUMBER] [-d]"
    echo "  -v VERSION     Version in x.y.z format (required)"
    echo "  -r RC_NUMBER   Release candidate number (default: 1)"
    echo "  -d             Dry run - show what would be done"
    echo ""
    echo "Examples:"
    echo "  $0 -v 1.0.0"
    echo "  $0 -v 1.0.0 -r 2"
    echo "  $0 -v 1.0.0 -d"
    exit 1
}

while getopts "v:r:dh" opt; do
    case $opt in
        v) VERSION="$OPTARG" ;;
        r) RC_NUMBER="$OPTARG" ;;
        d) DRY_RUN=true ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -z "$VERSION" ]]; then
    echo "Error: Version is required"
    usage
fi

# Validate version format
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format x.y.z (e.g., 1.0.0)"
    exit 1
fi

RC_TAG="v${VERSION}-rc${RC_NUMBER}"

echo "🚀 Creating Release Candidate: $RC_TAG"

if [[ "$DRY_RUN" == true ]]; then
    echo "🔍 DRY RUN - No changes will be made"
    echo "Would create tag: $RC_TAG"
    echo "Would push to origin"
    exit 0
fi

# Check if tag already exists
if git tag -l | grep -q "^$RC_TAG$"; then
    echo "Error: Tag $RC_TAG already exists. Use a different RC number or delete the existing tag."
    exit 1
fi

# Create and push the tag
echo "📝 Creating tag: $RC_TAG"
git tag "$RC_TAG"

echo "⬆️  Pushing tag to origin..."
git push origin "$RC_TAG"

echo "✅ Release candidate tag created and pushed!"
echo ""
echo "🔗 Check the build progress at:"
echo "   https://github.com/vic10us/masscan-docker/actions"
echo ""
echo "📦 Once built, the image will be available as:"
echo "   ghcr.io/vic10us/masscan:${VERSION}-rc${RC_NUMBER}"
