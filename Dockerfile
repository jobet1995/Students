# Stage 1: Base Image for Dependencies
FROM node:20 as dependencies

# Set working directory for frontend dependencies
WORKDIR /app/frontend

# Copy only package.json and package-lock.json for frontend
COPY frontend/package*.json ./
RUN npm install

# Set working directory for backend dependencies
WORKDIR /app/backend

# Copy only package.json and package-lock.json for backend
COPY backend/package*.json ./
RUN npm install

# Stage 2: Build Stage
FROM dependencies as build

# Set working directory for frontend build
WORKDIR /app/frontend
COPY frontend .
RUN npm run build

# Stage 3: Final Image for Production
FROM node:20-alpine as production

# Set working directory for backend
WORKDIR /app/backend

# Copy built frontend files from build stage
COPY --from=build /app/frontend/dist ./frontend/dist

# Copy backend source code
COPY backend .

# Install serve to run the production server (optional, adjust as needed)
RUN npm install -g serve

# Expose the port that serve will use
EXPOSE 3000

# Command to start the production server
CMD serve -s frontend/dist -p 3000