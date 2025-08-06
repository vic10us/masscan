# Release Candidate Build Script (PowerShell)
# This script helps create and push release candidate tags

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [int]$RcNumber = 1,
    
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# Validate version format
if (-not ($Version -match '^\d+\.\d+\.\d+$')) {
    Write-Error "Version must be in format x.y.z (e.g., 1.0.0)"
}

$RcTag = "v${Version}-rc${RcNumber}"

Write-Host "🚀 Creating Release Candidate: $RcTag" -ForegroundColor Green

if ($DryRun) {
    Write-Host "🔍 DRY RUN - No changes will be made" -ForegroundColor Yellow
    Write-Host "Would create tag: $RcTag"
    Write-Host "Would push to origin"
    exit 0
}

# Check if tag already exists
$existingTag = git tag -l $RcTag
if ($existingTag) {
    Write-Error "Tag $RcTag already exists. Use a different RC number or delete the existing tag."
}

# Create and push the tag
Write-Host "📝 Creating tag: $RcTag"
git tag $RcTag

Write-Host "⬆️  Pushing tag to origin..."
git push origin $RcTag

Write-Host "✅ Release candidate tag created and pushed!" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 Check the build progress at:" -ForegroundColor Cyan
Write-Host "   https://github.com/vic10us/masscan-docker/actions"
Write-Host ""
Write-Host "📦 Once built, the image will be available as:" -ForegroundColor Cyan
Write-Host "   ghcr.io/vic10us/masscan:${Version}-rc${RcNumber}"
