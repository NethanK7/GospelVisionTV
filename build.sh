#!/bin/bash

# If the command is 'setup', we clone Flutter and run pub get
if [ "$1" == "setup" ]; then
    echo "Starting Flutter setup..."
    if [ ! -d "flutter" ]; then
        git clone https://github.com/flutter/flutter.git -b stable
    fi
    export PATH="$PATH:`pwd`/flutter/bin"
    flutter config --enable-web
    flutter pub get
    exit 0
fi

# Otherwise, we just build the app
export PATH="$PATH:`pwd`/flutter/bin"
flutter build web --release
