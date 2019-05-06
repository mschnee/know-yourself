# Create the dependencies stage
FROM node:12 AS build_stage
COPY package.json /build/
COPY package-lock.json /build/
COPY tsconfig.json /build/
COPY ./src /build/src
WORKDIR /build
RUN npm ci
RUN npm run build

# Create prod dependencies
FROM node:12 AS dep_stage
COPY package.json /deps/
COPY package-lock.json /deps/
WORKDIR /deps
RUN npm ci --production

# Copy the distribution to a node-alpine base
FROM node:12-alpine
EXPOSE 3000
COPY --from=build_stage /build/dist /api/dist
COPY --from=build_stage /build/package.json /api/
COPY --from=build_stage /build/package-lock.json /api/
COPY --from=dep_stage /deps/node_modules /api/node_modules
WORKDIR /api
CMD npm run start