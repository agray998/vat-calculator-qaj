FROM node:26-alpine AS build
WORKDIR /app

COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# new stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
