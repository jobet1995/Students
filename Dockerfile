FROM node:20 as dependencies

WORKDIR /app .

COPY package*.json ./
RUN npm install

WORKDIR /app .

COPY package*.json ./
RUN npm install

FROM dependencies as build

WORKDIR /app .
COPY . .
RUN npm run build

FROM node:20-alpine as production

WORKDIR /app .

COPY --from=build /app/dist .

COPY . .

RUN npm install -g serve

EXPOSE 3000

CMD ["npm","run"]