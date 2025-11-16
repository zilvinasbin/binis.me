# Build stage
FROM node:20-alpine AS builder

# Install pnpm
RUN corepack enable && corepack prepare pnpm@10.5.2 --activate

WORKDIR /app

# Copy package files
COPY package.json package-lock.json* pnpm-lock.yaml* ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source files
COPY . .

# Build the application
RUN pnpm run build

# Production stage
FROM node:20-alpine AS runner

# Install pnpm
RUN corepack enable && corepack prepare pnpm@10.5.2 --activate

WORKDIR /app

# Copy built files and necessary config
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/astro.config.mjs ./

# Install only production dependencies for preview server
RUN pnpm install --prod --frozen-lockfile

# Expose port 4323
EXPOSE 4323

# Set host to 0.0.0.0 to accept connections from outside the container
ENV HOST=0.0.0.0
ENV PORT=4323

# Start the preview server
CMD ["pnpm", "run", "preview", "--host", "0.0.0.0", "--port", "4323"]

