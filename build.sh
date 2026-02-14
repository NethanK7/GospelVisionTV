#!/bin/bash
set -e

# Fast setup
echo "Starting Gospel Vision TV Build..."
export BOT=true
export FLUTTER_SUPPRESS_ANALYTICS=true

# Use current directory for Flutter SDK to ensure it's in the build context
FLUTTER_SDK_DIR="$(pwd)/flutter_sdk"

setup_flutter() {
    echo "--- SETUP PHASE ---"
    if [ ! -d "$FLUTTER_SDK_DIR" ]; then
        echo "Installing Flutter SDK..."
        git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_SDK_DIR"
    else
        echo "Flutter SDK already exists."
    fi
    
    export PATH="$PATH:$FLUTTER_SDK_DIR/bin"
    
    echo "Configuring Flutter..."
    flutter config --no-analytics
    flutter precache --web
    
    echo "Getting dependencies..."
    flutter pub get
}

build_app() {
    echo "--- BUILD PHASE ---"
    export PATH="$PATH:$FLUTTER_SDK_DIR/bin"
    
    if ! command -v flutter &> /dev/null; then
        echo "Flutter not found in PATH. Re-running setup..."
        setup_flutter
    fi

    # Handle .env for Vercel
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

    echo "Building Flutter Web..."
    flutter build web --release --base-href / --pwa-strategy offline-first --no-wasm-dry-run

    if [ -f "build/web/index.html" ]; then
        echo "Build successful. Finalizing artifacts..."
        
        # Ensure .env is in assets for the web app to find
        mkdir -p build/web/assets
        if [ -f .env ]; then
            cp .env build/web/assets/.env
            echo "Environment file copied to assets."
        fi
        
        # Add a debug info file
        echo "Build Timestamp: $(date)" > build/web/build_info.txt
        echo "Commit: $(git rev-parse HEAD 2>/dev/null || echo 'unknown')" >> build/web/build_info.txt
        
        echo "Final build contents:"
        ls -la build/web/assets
    else
        echo "Error: Build failed to produce index.html"
        exit 1
    fi
}

case "$1" in
    "setup")
        setup_flutter
        ;;
    "build")
        build_app
        ;;
    *)
        setup_flutter
        build_app
        ;;
esac
