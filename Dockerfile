# Use Node.js 16 slim as the base image
FROM node:16

RUN apt-get update && apt-get install -y xdg-utils

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Give full permissions to .bin folder (not recommended for production)
RUN chmod -R 777 node_modules/.bin/react-scripts

RUN chmod -R +x node_modules/.bin/react-scripts

# Build the React app
RUN npm run build

# Expose port 3000 (or the port your app is configured to listen on)
EXPOSE 3000

# Start your Node.js server (assuming it serves the React app)
CMD ["npm", "start"]
