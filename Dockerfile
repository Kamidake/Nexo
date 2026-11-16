# Stage 1: Build
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

# Copy the entire workspace from builder
COPY --from=builder /app /app

ENV PORT=5000
ENV NODE_ENV=production

EXPOSE 5000

# Stay at root (/app) and run the backend using pnpm filter
CMD ["pnpm", "--filter", "backend", "run", "start"]
