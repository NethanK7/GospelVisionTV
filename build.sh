#!/bin/bash
set -e
export BOT=true

# Setup phase: Download Flutter
if [ "$1" == "setup" ]; then
  echo "Setting up Flutter..."
  if [ ! -d "flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
  fi
  exit 0
fi

# Build phase: Compile Web
if [ "$1" == "build" ]; then
  echo "Building Production Web App..."
  export PATH="$PATH:`pwd`/flutter/bin"
  flutter config --no-analytics
  flutter precache --web
  flutter build web --release --base-href /
  
  # Ensure manifest.json is in the right place (it should be in build/web)
  ls -F build/web/
  exit 0
fi

echo "Usage: ./build.sh [setup|build]"
exit 1
