#!/bin/bash

if [[ $API_HOSTNAME == "" ]]; then
  export API_HOSTNAME=$RAILWAY_STATIC_URL
fi

if [[ -f "/usr/src/api/config/settings.json"]] && [[ -f "/usr/src/api/config/template.json" ]]; then
  echo "warning: You have both the template and custom settings JSOn files! Please comment out line 10"
  echo "warning: of your Dockerfile, as the entrypoint script will not overwrite them!"
elif [[ ! -f "/usr/src/api/config/settings.json"]] && [[ -f "/usr/src/api/config/template.json" ]]; then
  envsubst < /usr/src/api/config/template.json > /usr/src/api/config/settings.json
fi
sleep 3

# then exec to the dist binary
exec node dist/api.js