# To build the image, from the root of your project (where the Dockerfile is) run:
#      
#      docker build -t joes-robot-shop .
#
# Run a container from the image: (see locally available images: docker images )
#	Note:  '-d' is for detached mode.  Else, it'll occupy your local terminal.  Doesn't matter in Azure pipeline, I guess. 
#      
#      docker run -p 4200:4200 -p 8081:8081 joes-robot-shop -d
#      
# This should now correctly build the Angular application with the production configuration and start the Express server on port 8081.
#
#	http://localhost:4200 
#	http://localhost:8081
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

FROM node:18

# Set working directory for the Angular application
WORKDIR /app/joes-robot-shop

# Copy everything into the image
COPY ./ .

# Install Angular CLI and dependencies
RUN npm install -g @angular/cli \
    && npm install

# Expose ports for frontend and backend (the Express server)
EXPOSE 4200 8081

# Run Angular dev server and Express API
CMD ["sh", "-c", "ng serve --host 0.0.0.0 --port 4200 & cd api-server && node index.js"]
