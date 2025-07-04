# Stage 1: Dependency installation
FROM node:18-alpine AS deps

WORKDIR /app
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
    if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
    elif [ -f pnpm-lock.yaml ]; then npm install -g pnpm && pnpm fetch --prod; \
    else npm ci; \
    fi

# Stage 2: Builder
FROM node:18-alpine AS builder

WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED 1
ENV NODE_ENV production

RUN npm run build

# Stage 3: Runner
FROM node:18-alpine AS runner

WORKDIR /app

# Copy necessary files from builder stage
# Next.js 13+ with output: 'standalone' copies everything into .next/standalone
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Optional: Set a non-root user for security (recommended in prod)
# ARG UID=1000
# RUN adduser --system --uid ${UID} nextjs
# USER nextjs

EXPOSE 3000

CMD ["node", "server.js"]