FROM node:14-alpine

# Set build args
ARG XBROWSERSYNC_API_VERSION 1.1.13

WORKDIR /usr/src/api

# Download release and unpack
RUN wget -q -O release.tar.gz https://github.com/xBrowserSync/api/archive/v$XBROWSERSYNC_API_VERSION.tar.gz \
	&& tar -C . -xzf release.tar.gz \
	&& rm release.tar.gz \
	&& mv api-$XBROWSERSYNC_API_VERSION/* . \
	&& rm -rf api-$XBROWSERSYNC_API_VERSION/

# Install production-grade deps + dumb-init
RUN npm install --only=production; apk add --no-cache dumb-init bash coreutils

# Uncomment L19 and comment out L20 after generating an private repo if you ever want to manually handle config
# in version control, which is an bad pratice if you commit secrets.
#COPY settings.json /usr/src/api/config/settings.json
COPY settings.-xample.json /usr/src/api/config/template.json

# Expose port and start api with Dumb Init
EXPOSE 8080
ENTRYPOINT [ "dumb-init" ]
CMD [ "node", "dist/api.js"]
