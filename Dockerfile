# To build the image, from the root of your project (where the Dockerfile is) run:
#      
#      docker build -t joes-robot-shop .
#
# Run a container from the image: (see locally available images: docker images )
#	Note:  '-d' is for detached mode.  Else, it'll occupy your local terminal.  Doesn't matter in Azure pipeline, I guess. 
#      
#      	docker run -p 4200:4200 -p 8081:8081 joes-robot-shop -d
#		docker run -p 8080:80 joes-robot-shop
#      
# This should now correctly build the Angular application with the production configuration and start the Express server on port 8081.
#
#	http://localhost:4200 
#	http://localhost:8081
#
# POZOR: Port 80 is the only port exposed to the public internet in a Linux App Service Plan.
#	To fix that, 
#	Option 1: run Angular on Port 80 (in this Dockerfile) instead of port 4200
#	Option 2: run a small reverse proxy (like Nginx or a node-based proxy) to forward port 80 → 4200
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
#
# Remove all images from my system (gets all image IDs) then force delete each image (rmi -f)
#	
#	docker rmi -f $(docker images -q)
#	
# Better (more thorough) use prune to Clean Up Everything (Containers + Volumes + Images)
#	
#	docker system prune -a
#	
#	
#	
#	
#	
#	

## ======================================================================
## production version, for Azure pipeline
# Stage 1: Build Angular App
FROM node:18 AS builder

WORKDIR /app
COPY . .

# Install dependencies and build Angular app
RUN npm install
RUN npm run build --prod

# Stage 2: Serve Angular App with Nginx
FROM nginx:alpine

# Copy built Angular files to Nginx's default public folder
COPY --from=builder /app/dist/joes-robot-shop /usr/share/nginx/html

# Expose port 80 for Azure to access
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]




## ======================================================================
## development version, for localhost
#FROM node:18
#
## Set working directory for the Angular application
#WORKDIR /app/joes-robot-shop
#
## Copy everything into the image
#COPY ./ .
#
## Install Angular CLI and dependencies
#RUN npm install -g @angular/cli \
#    && npm install
#
## Expose ports for frontend and backend (the Express server)
#EXPOSE 4200 8081
#
## Run Angular dev server and Express API (for localhost)
#CMD ["sh", "-c", "ng serve --host 0.0.0.0 --port 4200 & cd api-server && node index.js"]












































