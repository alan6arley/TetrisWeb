FROM node:latest as build
WORKDIR /tetris
COPY package.json package-lock.json .
RUN npm install
COPY . .
RUN npm run build
FROM nginx:latest
COPY --from=build /tetris/dist/angular-tetris /usr/share/nginx/html
EXPOSE 80

# Steps explained
# 1. Set base image to build app
# 2. Create the workdir "/tetris" in host
# 3. Copy specified files from local dir to the set workdir in host
# 4. install required libraries
# 5. Copy source code to the set workdir in host
# 6. Exec command to build app
# 7. Set base image to run app
# 8. Copy build artifacts to host
# 9. Expose 80 port on container

# Host OS type: Linux

# Commands
# docker build -t tetris:1.00.0 .
# docker run -dp 3001:80 --name tetrisweb tetris:1.00.0