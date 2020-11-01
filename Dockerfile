FROM nginx:alpine as env
# fetch dependencies
RUN apk add --no-cache nodejs nodejs-npm && \
apk upgrade --no-cache --available && \
npm config set unsafe-perm true && \
npm install -g @angular/cli npm-snapshot && \
npm cache clean --force
# build step
FROM env as dev
COPY . src
WORKDIR src
RUN npm install && \
npm rebuild node-sass && \
ng build
# release stage
FROM nginx:latest AS release
COPY --from=dev src/dist/ /usr/share/nginx/html/