FROM node:14-alpine

# Set build args
ARG XBROWSERSYNC_API_VERSION=1.1.13
ENV XBROWSERSYNC_API_VERSION=$XBROWSERSYNC_API_VERSION

WORKDIR /usr/src/api

# Uncomment L10 and comment out L11 after generating an private repo if you ever want to manually handle config
# in version control, which is an bad pratice if you commit secrets.
#COPY settings.json /usr/src/api/config/settings.json
COPY settings-template.json /usr/src/api/config/template.json
# Also copy the entrypoint script so we can amke to executable in later steps
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Download release and unpack
RUN wget -q -O release.tar.gz https://github.com/xBrowserSync/api/archive/v$XBROWSERSYNC_API_VERSION.tar.gz \
	&& tar -C . -xzf release.tar.gz \
	&& rm release.tar.gz \
	&& mv api-$XBROWSERSYNC_API_VERSION/* . \
	&& rm -rf api-$XBROWSERSYNC_API_VERSION/

# Install production-grade deps + dumb-init
RUN npm install --only=production; \
    apk add --no-cache dumb-init bash coreutils

# Expose port and start api with Dumb Init
EXPOSE 8080
ENTRYPOINT [ "dumb-init" ]
CMD [ "/usr/local/bin/entrypoint.sh" ]
