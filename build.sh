#!/bin/bash

# Bypasses the "Woah! You are root" warning
export BOT=true
export FLUTTER_SUPPRESS_ANALYTICS=true

# Setup logic
if [ "$1" == "setup" ]; then
  echo "Setting up Flutter SDK..."
  if [ ! -d "flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
  fi
  exit 0
fi

# Build logic
if [ "$1" == "build" ]; then
  echo "Building Gospel Vision TV for Production..."
  export PATH="$PATH:`pwd`/flutter/bin"
  
  # Initialize
  flutter config --no-analytics
  flutter precache --web
  
  # Build web
  flutter build web --release --base-href /
  
  # Ensure .env is in the build output for the app to find it
  if [ -f ".env" ]; then
    cp .env build/web/
  fi
  
  echo "Build complete. Deployment starting..."
  exit 0
fi

echo "Usage: ./build.sh [setup|build]"
exit 1
