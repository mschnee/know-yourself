# Create the dependencies stage
FROM node:12 AS build_stage
COPY package.json /build/
COPY tsconfig.json /build/
COPY ./src /build/src
WORKDIR /build
RUN npm ci
RUN npm run build

# Copy the distribution to a node-alpine base
FROM node:12-alpine
EXPOSE 3000
COPY --from=build_stage /build/dist /api/dist
COPY --from=build_stage /build/package.json /api/
WORKDIR /api
RUN npm ci --production
CMD npm run start