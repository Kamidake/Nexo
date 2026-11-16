# Stage 1: Clone and build from GitHub source
FROM node:22-alpine AS builder

RUN apk add --no-cache git python3 make g++

WORKDIR /app
RUN git clone --depth 1 https://github.com/joaosavi/nexotv.git .

# Install pnpm globally
RUN npm install -g pnpm

# Use pnpm to install workspace dependencies properly
RUN pnpm install --frozen-lockfile || pnpm install

# Build the pnpm monorepo packages
RUN pnpm build

# Stage 2: Production runtime
FROM node:22-alpine

WORKDIR /app

RUN npm install -g pnpm

# Copy the entire built monorepo structure from builder
COPY --from=builder /app /app

# Miget injects PORT=5000 automatically, fallback default here
ENV PORT=5000
ENV NODE_ENV=production

EXPOSE 5000

CMD ["pnpm", "--filter", "backend", "start"]
