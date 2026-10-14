#!/usr/bin/env bash
# Captures README screenshots of the ShaderGallery example app on an iPhone simulator.
#
# The script builds and installs the app, opens one screen with `-page <name>`, and takes a
# simulator screenshot in light and dark appearance, cropped to the page title, the picture and
# its controls. Unlike the images from generate-screenshots.sh, these show the effect running in
# a real app.
#
# Usage: scripts/capture-gallery.sh [simulator name or UDID] [page]
# Without arguments it uses an "iPhone 17 Pro" simulator and the "Halftone" page. The crop below
# is measured on that screen size (1206 x 2622 pixels); other devices need other numbers.
# Output: docs/images/gallery-light.png and docs/images/gallery-dark.png
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
device="${1:-iPhone 17 Pro}"
page="${2:-Halftone}"

bundle_id="io.github.muhittincamdali.ShaderGallery"
output_dir="$repo_root/docs/images"
build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT
mkdir -p "$output_dir"

destination="platform=iOS Simulator,name=$device"
if [[ "$device" =~ ^[0-9A-F-]{36}$ ]]; then
  destination="platform=iOS Simulator,id=$device"
fi
echo "Building ShaderGallery for '$device'"
xcodebuild build \
  -project "$repo_root/Examples/ShaderGallery/ShaderGallery.xcodeproj" \
  -scheme ShaderGallery \
  -destination "$destination" \
  -derivedDataPath "$build_dir" \
  -quiet
app="$(find "$build_dir/Build/Products" -maxdepth 2 -name 'ShaderGallery.app' -path '*iphonesimulator*' | head -1)"

xcrun simctl boot "$device" 2>/dev/null || true
xcrun simctl bootstatus "$device" -b >/dev/null
xcrun simctl install "$device" "$app"

# The first launch after an install is slow; on a cold start the first screenshot caught the
# launch animation, so open the app once before taking any.
xcrun simctl launch --terminate-running-process "$device" "$bundle_id" -page "$page" >/dev/null
sleep 6

for appearance in light dark; do
  xcrun simctl ui "$device" appearance "$appearance"
  xcrun simctl launch --terminate-running-process "$device" "$bundle_id" -page "$page" >/dev/null
  sleep 4 # let the navigation push and the first frames draw
  file="$output_dir/gallery-$appearance.png"
  xcrun simctl io "$device" screenshot --type=png "$file" >/dev/null 2>&1
  # Keep the area from below the status bar to below the controls. sips treats a zero offset as
  # "centered", so the crop starts one pixel in from the left and is two pixels narrower than
  # the screen. Half the width keeps the README light.
  sips --cropToHeightWidth 1450 1204 --cropOffset 170 1 "$file" >/dev/null
  sips --resampleWidth 602 "$file" >/dev/null
  echo "$file"
done
