#!/bin/bash
set -e

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
  
  # Prepare Vercel output in the 'public' folder
  # We use 'public' instead of 'build/web' to avoid .gitignore issues
  echo "Organizing files for Vercel..."
  rm -rf public
  mkdir -p public
  cp -rv build/web/* public/
  
  # Ensure the .env file is available in the web build if it exists
  if [ -f ".env" ]; then
    cp .env public/
  fi
  
  echo "Build complete. Files in /public ready for deployment."
  exit 0
fi

echo "Usage: ./build.sh [setup|build]"
exit 1
