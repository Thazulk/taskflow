# Stage 1: Build the application
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies, including dev dependencies for the build step
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Run the TypeScript build
RUN npm run build

# Generate Prisma client for production build
# This needs access to schema.prisma and Prisma CLI
# Make sure Prisma schema is copied into backend/prisma/ or adjust path
COPY prisma ./prisma/
RUN npx prisma generate --data-proxy-provider javascript # Or node-api

# Stage 2: Create the production image
FROM node:18-alpine AS production

WORKDIR /app

# Copy only production dependencies from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy built application and Prisma files
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/package*.json ./

# Expose the port your backend listens on
EXPOSE 3001

# Command to start the application
CMD ["node", "dist/server.js"]