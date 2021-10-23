# xBrowserSync API Server on Railway

xBrowserSync is a free tool for syncing browser data between different browsers and devices, built for privacy and anonymity. For full details, [see the project's homepage](https://www.xbrowsersync.org).

This Railway starter contains the necessary Dockerfile and other niffty gitty stuff in order for you to successfully configure and run your own xBrowserSync API server.

## Deployment instructions

1. Create an new project with this template using the deploy button below.

  [![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https%3A%2F%2Fgithub.com%2Fajhalili2006%2Fxbrowsersync-railwayapp-starter&plugins=mongodb&envs=API_HOSTNAME&optionalEnvs=API_HOSTNAME&API_HOSTNAMEDesc=If+you+ever+use+custom+domains+in+Railway%2C+please+set+it+now.+Otherwise%2C+leave+this+blank+so+the+default+domain+will+be+detected.&referralCode=ajhalili2006)

2. After everything is provisioned, [install `mongosh`](https://docs.mongodb.com/mongodb-shell/install/#std-label-mdb-shell-install), connect to your MongoDB instance with `mongosh <railwayapp-mongodb-url-here>` and run the following inside the shell, one by one:

    ```js
    use admin
    db.createUser({ user: "xbrowsersyncdb", pwd: "[password]", roles: [ { role: "readWrite", db: "xbrowsersync" }, { role: "readWrite", db: "xbrowsersynctest" } ] })
    use xbrowsersync
    db.newsynclogs.createIndex( { "expiresAt": 1 }, { expireAfterSeconds: 0 } )
    db.newsynclogs.createIndex({ "ipAddress": 1 })
    ```

    > Remember to generate an secure secret using the `Generate a 32-character secret` in the Command Patlete (Cmd+K) and replace `[password]` with that generated secret.

3. Go to Variables and set `XBROWSERSYNC_DB_PWD` into that generated secret you set for `xbrowsersyncdb` user.

4. Wait for the deployment to be restarted. Once successfully deployed, welcome aboard! If your server is also public, the xBrowserSync project maintainers recommend you
to add a TTL index on bookmarks.lastAccessed to delete syncs that have not been accessed for atleast 3 weeks using the following command:

    ```js
    use xbrowsersync
    db.bookmarks.createIndex( { "lastAccessed": 1 }, { expireAfterSeconds: 21*86400 } )
    ```

## Customizing configuration

> It's advisable to ensure your repository is private. DO NOT DO THIS on public repos and instead edit the template file instead.

1. Copy the contents of `settings-template.json` to `settings.json` and edit as needed. Remember to replace the environment variables with its real values since the entrypoint scipt won't parse them all!
2. Comment out L11 and uncomment L10 in Dockerfile to make use of your config.
3. Don't forget to commit and push so Railway can catch these changes.

## Upgrading to latest versions

> :warning: Remember not to downgrade versions as this might be an cause for downtime shitshows of your service.

1. Visit <https://github.com/xbrowsersync/api/releases> and find the latest version. As of writing of the docs, it's `1.1.13`.
2. In the variables page, set `XBROWSERSYNC_API_VERSION` into that version. This will trigger an redeploy so please hold on.

## License

MIT
