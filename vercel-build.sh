#!/bin/bash

# 1. Download Flutter
echo "Downloading Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# 2. Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Initialize Flutter
echo "Initializing Flutter..."
flutter config --no-analytics
flutter precache --web

# 4. Build the Web App
echo "Building Flutter Web App..."
flutter build web --release

# 5. Prepare for Vercel
# We use a 'public' directory which is Vercel's favorite default
echo "Preparing output in 'public' directory..."
mkdir -p public
cp -r build/web/* public/
cp vercel.json public/

echo "Build complete."
