# ─── Stage 1: Build Flutter Web ───────────────────────────────────────────────
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Clone Flutter stable SDK
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 ${FLUTTER_HOME}

# Warm up Flutter web tooling
RUN flutter config --no-analytics && flutter precache --web

WORKDIR /app

# Copy dependency files first for layer caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the source
COPY . .

# Build Flutter web (release, base href = /)
RUN flutter build web --release --base-href /

# ─── Stage 2: Serve with nginx ────────────────────────────────────────────────
FROM nginx:alpine

# Install envsubst (part of gettext) for runtime PORT substitution
RUN apk add --no-cache gettext

# Copy built app
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy nginx config template
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Default port - Railway overrides this with $PORT at runtime
ENV PORT=8080

EXPOSE 8080

# envsubst replaces ${PORT} in the nginx config template at container start
CMD ["/bin/sh", "-c", "envsubst '${PORT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
