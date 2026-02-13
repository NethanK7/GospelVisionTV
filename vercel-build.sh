#!/bin/bash

# 1. Download Flutter (Portable & Fast)
echo "Setting up Flutter..."
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi
export PATH="$PATH:`pwd`/flutter/bin"

# 2. Configure for Web
flutter config --no-analytics
flutter precache --web

# 3. Build for Production
echo "Building Web App..."
flutter build web --release

# 4. Move output to root (This is what Vercel needs)
echo "Deploying files to project root..."
# Move everything from build/web to the root directory
# We use a temporary folder to avoid conflicts during the move
mkdir -p temp_deploy
cp -rv build/web/* temp_deploy/
cp vercel.json temp_deploy/
cp -rv temp_deploy/* .
rm -rf temp_deploy

echo "Build and pre-deployment complete."
