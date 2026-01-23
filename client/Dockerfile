# Multi-stage Dockerfile for frontend (OPTIMIZED)
# Updated: 2026-01-23 - Using npm install instead of npm ci
# Best practices applied:
# - Multi-stage build (Node build + Nginx serve)
# - Alpine base images
# - Nginx for optimized static file serving
# - Non-root user for security
# - Custom nginx configuration
# - Smaller final image (only dist files)

# Stage 1: Build
FROM node:22-alpine AS builder

WORKDIR /app

# Copy dependency manifests first (layer caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build React application
RUN npm run build

# Stage 2: Production with Nginx
FROM nginx:1.27-alpine

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built static files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Configure permissions for existing nginx user
RUN chown -R nginx:nginx /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Switch to non-root user (nginx user already exists in base image)
USER nginx

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
