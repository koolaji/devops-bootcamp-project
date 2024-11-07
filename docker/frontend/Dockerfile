# Stage 1: Build the React app
FROM registry.docker.ir/node:16 AS builder
WORKDIR /app

# Copy only package.json to install dependencies and generate yarn.lock
COPY package.json ./

# Install dependencies, which creates yarn.lock if it doesn't exist
RUN yarn install --frozen-lockfile || yarn install

# Copy the rest of the application files
COPY . .

# Build the React application
RUN yarn build

# Stage 2: Serve the React app with NGINX
FROM nginx:latest
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80

