#!/bin/bash

# Fast setup
echo "Starting Gospel Vision TV Build..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"
flutter config --no-analytics
flutter precache --web

# Build
flutter build web --release

# Move to a folder Vercel definitely sees
mkdir -p dist
cp -rv build/web/* dist/
cp vercel.json dist/

echo "Build complete. Files are in 'dist/'"
