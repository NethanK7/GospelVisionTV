#!/bin/bash
set -e
export BOT=true
export FLUTTER_SUPPRESS_ANALYTICS=true

# 1. Setup Phase
if [ "$1" == "setup" ]; then
  echo "Setting up Flutter..."
  if [ ! -d "flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
  fi
  exit 0
fi

# 2. Build Phase
if [ "$1" == "build" ]; then
  echo "Building App..."
  export PATH="$PATH:`pwd`/flutter/bin"
  flutter config --no-analytics
  flutter precache --web
  
  # Build web
  flutter build web --release --base-href / --no-wasm-dry-run
  
  exit 0
fi

echo "Usage: ./build.sh [setup|build]"
exit 1
