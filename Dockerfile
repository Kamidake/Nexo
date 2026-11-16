# Stage 1: Clone and build from GitHub source
FROM node:22-alpine AS builder

RUN apk add --no-cache git python3 make g++

WORKDIR /app
RUN git clone --depth 1 https://github.com/joaosavi/nexotv.git .

RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile || pnpm install
RUN pnpm build

# Stage 2: Production runtime
FROM node:22-alpine

WORKDIR /app

RUN npm install -g pnpm

# Copy built files and node_modules from builder
COPY --from=builder /app /app

ENV PORT=5000
ENV NODE_ENV=production

EXPOSE 5000

# Directly point to the compiled backend entrypoint or run it via workspace scope without a custom start script
WORKDIR /app/backend
CMD ["node", "dist/index.js"]
