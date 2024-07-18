# Stage 1: Build the Vue.js Frontend
FROM node:20 as frontend-build

WORKDIR /app/frontend

# Copy only the package.json and package-lock.json first to leverage Docker cache
COPY frontend/package*.json ./
RUN npm install

# Copy the rest of the frontend files and build
COPY frontend .
RUN npm run build


# Stage 2: Build the Node.js Backend
FROM node:20 as backend-build

WORKDIR /app/backend

# Copy only the package.json and package-lock.json first to leverage Docker cache
COPY backend/package*.json ./
RUN npm install

# Copy the rest of the backend files
COPY backend .


# Stage 3: Combine Frontend and Backend into Production Image
FROM nginx:latest

# Set environment variables
ENV NGINX_PORT=80
ENV NGINX_SERVER_NAME=localhost

# Copy built frontend files from frontend-build stage to NGINX html directory
COPY --from=frontend-build /app/frontend/dist /usr/share/nginx/html

# Copy backend files from backend-build stage (if needed)
COPY --from=backend-build /app/backend /usr/share/nginx/html/backend

# Copy custom NGINX configuration file
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Expose NGINX port
EXPOSE $NGINX_PORT

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]