#!/bin/bash

echo "🚀 Setting up TaskFlow development environment..."

# Make script executable
chmod +x .devcontainer/post-create.sh
chmod +x .devcontainer/post-start.sh

# Install root dependencies
echo "📦 Installing root dependencies..."
npm install

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd backend && npm install && cd ..

# Install frontend dependencies  
echo "📦 Installing frontend dependencies..."
cd frontend && npm install && cd ..

# Set up Git hooks (if using husky)
echo "🔧 Setting up Git hooks..."
npx husky install 2>/dev/null || echo "Husky not configured yet"

# Create necessary directories
echo "📁 Creating project directories..."
mkdir -p {docs,scripts,shared/types,database/migrations,database/seeds}

# Set up environment files if they don't exist
echo "⚙️ Setting up environment files..."
if [ ! -f backend/.env ]; then
    cp backend/.env.example backend/.env 2>/dev/null || echo "No backend .env.example found"
fi

if [ ! -f frontend/.env.local ]; then
    cp frontend/.env.example frontend/.env.local 2>/dev/null || echo "No frontend .env.example found"
fi

# Generate Prisma client
echo "🗄️ Setting up Prisma..."
cd backend
if [ -f prisma/schema.prisma ]; then
    npx prisma generate
fi
cd ..

echo "✅ Post-create setup complete!"
echo ""
echo "🎯 Next steps:"
echo "1. Start the database: npm run db:start"
echo "2. Run migrations: npm run db:migrate"
echo "3. Seed the database: npm run db:seed"
echo "4. Start development: npm run dev"