#!/usr/bin/env bash
# Renders the README images into docs/images: the effect grids and transition frames in light and
# dark versions, and the animated preview.
#
# The images come from Tests/SwiftShadersTests/Screenshots.swift, which applies the effects in
# Examples/ShaderGallery/ShaderGallery/EffectCatalog.swift to the landscape drawn in
# SampleScene.swift and renders them with ImageRenderer. The suite runs only when SCREENSHOT_DIR
# is set, so `swift test` skips it.
#
# Usage: scripts/generate-screenshots.sh
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
output_dir="$repo_root/docs/images"
mkdir -p "$output_dir"

cd "$repo_root"
SCREENSHOT_DIR="$output_dir" swift test --filter Screenshots

ls -1 "$output_dir"
