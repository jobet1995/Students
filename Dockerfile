# Stage 1: Build the Vue.js Frontend
FROM node:14 as frontend-build

WORKDIR /app/frontend

# Check if ESLint and Prettier are initialized
RUN if [ ! -f .eslintrc.js ]; then \
        echo "ESLint not initialized. Initializing ESLint..."; \
        npx eslint --init; \
    fi

RUN if [ ! -f .prettierrc ]; then \
        echo "Prettier not initialized. Initializing Prettier..."; \
        npx --yes prettier --init; \
    fi

COPY frontend/package*.json ./

RUN npm install

COPY frontend .

RUN echo "Building Vue.js frontend..."
RUN npm run build


# Stage 2: Build the Node.js Backend
FROM node:14 as backend-build

WORKDIR /app/backend

COPY backend/package*.json ./

RUN echo "Installing backend dependencies..."
RUN npm install

COPY backend .

EXPOSE 3000

CMD ["npm", "start"]


# Stage 3: Combine Frontend and Backend into Production Image
FROM node:14 as production

WORKDIR /app

COPY --from=frontend-build /app/frontend/dist ./frontend/dist

COPY --from=backend-build /app/backend .

RUN npm install --only=production


# Install NGINX
FROM nginx:latest

COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy built frontend files from production stage
COPY --from=production /app/frontend/dist /usr/share/nginx/html

# Expose NGINX port
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]