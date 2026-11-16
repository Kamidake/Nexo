# Stage 1: Clone and build from GitHub source
FROM node:22-alpine AS builder

RUN apk add --no-cache git python3 make g++

WORKDIR /app
RUN git clone --depth 1 https://github.com/joaosavi/nexotv.git .

RUN npm ci || npm install
RUN npm run build

# Stage 2: Production runtime
FROM node:22-alpine

WORKDIR /app

# Copy built artifacts and dependencies
COPY --from=builder /app .

# Miget injects PORT=5000 automatically, setting default here as fallback
ENV PORT=5000
ENV NODE_ENV=production

EXPOSE 5000

CMD ["npm", "start"]
