#!/bin/bash
set -e

# Fast setup
echo "Starting Gospel Vision TV Build..."
export BOT=true
export FLUTTER_SUPPRESS_ANALYTICS=true

# 1. Setup Flutter
if [ "$1" == "setup" ]; then
  echo "Setting up Flutter SDK..."
  if [ ! -d "flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
  fi
  exit 0
fi

# 2. Build App
if [ "$1" == "build" ]; then
  echo "Building Flutter Web..."
  export PATH="$PATH:`pwd`/flutter/bin"
  flutter config --no-analytics
  flutter precache --web
  
  # Build
  flutter build web --release --base-href /
  
  # 3. Prepare 'dist' folder for Vercel
  echo "Organizing files for Vercel..."
  rm -rf dist
  mkdir -p dist
  cp -rv build/web/* dist/
  
  # Add a debug file we can check in the browser
  echo "Build Version: $(date)" > dist/build_info.txt
  
  echo "Build finished successfully."
  ls -la dist/index.html
  exit 0
fi

echo "Usage: ./build.sh [setup|build]"
exit 1
