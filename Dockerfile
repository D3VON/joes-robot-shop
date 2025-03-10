# Run from **parent** directory of the Angular directory
#      
# Build the Docker image: Not sure where to put dockerfile.  Moved into the robotshop directory.
#      
#      docker build -f dockerfile.joes-robot-shop -t joes-rebot-shop .
#
# Run a container from the image: (see locally available images: docker images )
#      
#      docker run -p 8081:8081 -p 4200:4200 -d joes-robot-shop
#      
# This should now correctly build the Angular application with the production configuration and start the Express server on port 8081.
#
# To stop the container: (may need to do `docker ps` to get the name or CONTAINER ID)
#
#      docker stop joes-robot-shop
#
# Stop all the containers
#
#      docker stop $(docker ps -a -q)
#
# To ssh into the container, find the container ID or name with ps, then:
#
#      docker exec -it <container_id_or_name> /bin/bash


## Use the Eclipse Temurin 17 base image
FROM eclipse-temurin:17

# Set environment variables
ENV NODE_VERSION=18.x

# Update the package list and install required packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    software-properties-common \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION | bash - \
    && apt-get install -y nodejs

# Install Angular CLI
RUN npm install -g @angular/cli

# Set the working directory for the Angular application
WORKDIR /app/joes-robot-shop

# Copy the entire joes-robot-shop directory
# original dockerfile was outside of joes-robot-shop dir.
#COPY joes-robot-shop/ .
# not sure if this will work: (haven't tried yet)
COPY ./ .

# Install Angular dependencies
RUN npm install

# Expose the port the Express server runs on
EXPOSE 8081

# Expose the port the Angular app runs on
EXPOSE 4200

# Command to run both the Angular development server and the Express server
CMD ["sh", "-c", "ng serve --host 0.0.0.0 --port 4200 & cd /app/joes-robot-shop/api-server && node index.js"]

