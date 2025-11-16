# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy source files
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:20-alpine AS runner

WORKDIR /app

# Copy built files and necessary config
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/astro.config.mjs ./

# Install only production dependencies for preview server
RUN npm ci --omit=dev

# Expose port 4323
EXPOSE 4323

# Set host to 0.0.0.0 to accept connections from outside the container
ENV HOST=0.0.0.0
ENV PORT=4323

# Start the preview server
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "4323"]

