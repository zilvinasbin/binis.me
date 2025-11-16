# Build stage
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache python3 make g++ vips-dev

WORKDIR /app

# Copy package files
COPY package.json ./
RUN npm install

# Copy source and build
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine AS runner

# Install runtime dependencies
RUN apk add --no-cache vips

WORKDIR /app

# Install serve for static files (no host checking)
RUN npm install -g serve

# Copy built static files
COPY --from=builder /app/dist ./dist

# Expose port 4323
EXPOSE 4323

# Serve static files on all interfaces
CMD ["serve", "dist", "-l", "4323", "--no-port-switching", "--no-clipboard"]
