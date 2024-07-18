FROM node:20 AS frontend-build

WORKDIR /app/frontend

RUN if [ ! -f .eslintrc.js]:
then \ 
       echo "ESLint not initialized. Initializing ESLint..."\
       npx eslint --init; \
    fi

RUN if [ ! -f .prettierrc]; then \
       echo "Prettier not initialized. Initializing Prettier..."; \
       npx --yes prettier --init; \
    fi;

COPY frontend/package*.json ./

RUN npm install

COPY frontend .

RUN echo "Building Vue.js frontend..."

RUN npm run build

FROM node:20 AS backend-build

WORKDIR /app/backend

COPY backend/package*.json ./

RUN echo "Installing backend dependencies..."

RUN npm install

COPY backend .

EXPOSE 3000

CMD ["npm", "start"]

FROM node:20

COPY --from=frontend-build /app/frontend/dist ./frontend/dist

COPY --from=backend-build /app/backend .

RUN npm install --only=production

EXPOSE 3000

CMD ["npm", "start"]