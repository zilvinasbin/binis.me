# Build stage
FROM node:20-alpine AS builder

# Install build dependencies for Sharp
RUN apk add --no-cache python3 make g++ vips-dev

WORKDIR /app

# Copy package files
COPY package.json ./

# Install dependencies (without lockfile to get correct platform binaries)
RUN npm install

# Copy source files
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:20-alpine AS runner

# Install runtime dependencies for Sharp
RUN apk add --no-cache vips

WORKDIR /app

# Copy built files and necessary config
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/astro.config.mjs ./
COPY --from=builder /app/node_modules ./node_modules

# Expose port 4323
EXPOSE 4323

# Set host to 0.0.0.0 to accept connections from outside the container
ENV HOST=0.0.0.0
ENV PORT=4323

# Start the preview server
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "4323"]

