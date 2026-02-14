#!/bin/bash
set -e

# Fast setup
echo "--- GOSPEL VISION TV BUILD SCRIPT ---"
export BOT=true
export FLUTTER_SUPPRESS_ANALYTICS=true

# Local SDK
FLUTTER_SDK_DIR="$(pwd)/flutter_sdk"

# 1. Setup
if [ ! -d "$FLUTTER_SDK_DIR" ]; then
    echo "Cloning Flutter SDK..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_SDK_DIR"
fi
export PATH="$PATH:$FLUTTER_SDK_DIR/bin"
flutter --version
flutter config --no-analytics
flutter precache --web

# 2. Dependencies
flutter pub get

# 3. Build
echo "Building Flutter Web..."
flutter build web --release --base-href / --pwa-strategy offline-first --no-wasm-dry-run --web-renderer canvaskit

# 4. Finalize for Vercel
echo "Finalizing build structure in 'public/' directory..."
rm -rf public
mkdir -p public
cp -rv build/web/* public/

# Ensure critical files are in assets/ (where Flutter looks) AND root (where Vercel might put them)
mkdir -p public/assets
for f in FontManifest.json AssetManifest.json AssetManifest.bin AssetManifest.bin.json version.json; do
    if [ -f "public/$f" ]; then
        cp "public/$f" "public/assets/$f"
        echo "Copied $f to assets/"
    elif [ -f "public/assets/$f" ]; then
        cp "public/assets/$f" "public/$f"
        echo "Copied assets/$f to root"
    fi
done

# Handle .env
if [ ! -f .env ]; then
    echo "Creating .env from system environment..."
    touch .env
    vars=("STRIPE_KEY" "OPENAI_API_KEY" "CLIENT_ID_WEB" "CLIENT_ID_IOS" "REVERSED_CLIENT_ID")
    for var in "${vars[@]}"; do
        if [ ! -z "${!var}" ]; then
            echo "$var=${!var}" >> .env
        fi
    done
fi

if [ -f .env ]; then
    cp .env public/assets/.env
    cp .env public/.env
    echo ".env file copied to both root and assets/"
fi

# Add debug info
TIMESTAMP=$(date)
echo "Build Timestamp: $TIMESTAMP" > public/build_info.txt
echo "Commit: $(git rev-parse HEAD 2>/dev/null || echo 'unknown')" >> public/build_info.txt
cp public/build_info.txt public/assets/build_info.txt

echo "Verify public/assets/ structure:"
ls -la public/assets/

echo "Build successful."
