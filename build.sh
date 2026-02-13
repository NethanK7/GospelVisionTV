#!/bin/bash

# Setup logic
if [ "$1" == "setup" ]; then
  echo "Setting up Flutter..."
  if [ ! -d "flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
  fi
  exit 0
fi

# Build logic
if [ "$1" == "build" ]; then
  echo "Building Gospel Vision TV..."
  export PATH="$PATH:`pwd`/flutter/bin"
  flutter config --no-analytics
  flutter precache --web
  flutter build web --release --web-renderer canvaskit
  
  # Prepare output
  mkdir -p dist
  cp -rv build/web/* dist/
  cp vercel.json dist/
  echo "Build complete."
  exit 0
fi

echo "Usage: ./build.sh [setup|build]"
exit 1
