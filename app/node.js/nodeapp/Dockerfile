# Use an official Node.js runtime as a parent image
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /app

# Copy all files from the current directory to the working directory
COPY . .

# Install app dependencies
RUN npm install

# Set port as argument
ARG PORT=3000

# Expose the port the app runs on
EXPOSE $PORT

# Command to run the application
CMD ["npm", "run", "start"]