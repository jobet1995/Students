# Stage 1: Build the Vue.js Frontend
FROM node:20 as frontend-build

WORKDIR /app/frontend

# Copy only the package.json and package-lock.json first to leverage Docker cache
COPY frontend/package*.json ./
RUN npm install

# Copy the rest of the frontend files and build
COPY frontend .
RUN npm run build


# Stage 2: Prepare NGINX to Serve Frontend
FROM nginx:latest

# Remove default NGINX configuration
RUN rm /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy custom NGINX configuration and SSL certificates
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/nginx.crt /etc/nginx/nginx.crt
COPY nginx/nginx.key /etc/nginx/nginx.key

# Set working directory for static files
WORKDIR /usr/share/nginx/html

# Copy built frontend files from frontend-build stage to NGINX html directory
COPY --from=frontend-build /app/frontend/dist .

# Expose NGINX ports (HTTP and HTTPS)
EXPOSE 80
EXPOSE 443

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]