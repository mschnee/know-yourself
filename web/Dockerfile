# Create the dependencies stage
FROM node:12 AS build_stage
COPY package-lock.json /build/
COPY package.json /build/
COPY ./src /build/src
COPY ./webpack.config.js /build/
WORKDIR /build
RUN npm ci
RUN npm run build


FROM nginx
EXPOSE 8080
COPY --from=build_stage /build/dist /usr/share/nginx/html