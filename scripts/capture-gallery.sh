#!/usr/bin/env bash
# Captures README screenshots of the ShaderGallery example app on an iPhone simulator.
#
# The script builds and installs the app, opens one screen with `-page <name>`, and takes a
# simulator screenshot in light and dark appearance with a fixed status bar. Unlike the images
# from generate-screenshots.sh, these show the effect running in a real app, with its controls.
#
# Usage: scripts/capture-gallery.sh [simulator name or UDID] [page]
# Without arguments it uses the first available iPhone simulator and the "Halftone" page.
# Output: docs/images/gallery-light.png and docs/images/gallery-dark.png
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
device="${1:-}"
page="${2:-Halftone}"
if [[ -z "$device" ]]; then
  device="$(xcrun simctl list devices available | grep -m1 -oE 'iPhone [^(]+' | sed 's/ *$//')"
fi
if [[ -z "$device" ]]; then
  echo "No available iPhone simulator found." >&2
  exit 1
fi

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
xcrun simctl status_bar "$device" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularBars 4 --wifiBars 3 --operatorName ""
xcrun simctl install "$device" "$app"

for appearance in light dark; do
  xcrun simctl ui "$device" appearance "$appearance"
  xcrun simctl launch --terminate-running-process "$device" "$bundle_id" -page "$page" >/dev/null
  sleep 4 # let the navigation push and the first frames draw
  file="$output_dir/gallery-$appearance.png"
  xcrun simctl io "$device" screenshot --type=png "$file" >/dev/null 2>&1
  # Half the width of an iPhone 17 Pro screenshot keeps the README light; keep the top 680
  # points of it, where the picture and its controls are.
  sips --resampleWidth 603 "$file" >/dev/null
  sips --cropToHeightWidth 680 603 --cropOffset 0 0 "$file" >/dev/null
  echo "$file"
done
