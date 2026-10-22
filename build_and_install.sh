#!/usr/bin/env bash
# Build and install the Apple TV style launcher on the TV
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export TV_HOST="${TV_HOST:-192.168.29.18}"
export PATH="/opt/homebrew/opt/openjdk@17/bin:/opt/homebrew/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"

echo "Building and installing launcher to TV at $TV_HOST..."
cd "$SCRIPT_DIR/launcher"
./build-and-install.sh

