# Use a lightweight Node.js image as the base image
FROM node:14-alpine

# Set the working directory
WORKDIR /app

# Copy package.json to the working directory
COPY package.json ./

# Install dependencies, which creates yarn.lock if it doesn't exist
RUN yarn install --frozen-lockfile || yarn install

# Copy the rest of your application files
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Command to run your application
CMD ["node", "server.js"]

