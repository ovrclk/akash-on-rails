# Akash on Rails (Pinterest Clone)

Demo: [pin.akash.host](https://pin.akash.host)

This is an example Rails Pinterest clone hosted on Akash. There are a few extra features to make the most of decentralised hosting:

- Database backup/restore to [Sia](https://sia.tech) via [Filebase](https://filebase.com)
- User image uploads to [Sia](https://sia.tech) via [Filebase](https://filebase.com)
- [Auth0](https://auth0.com) user authentication
- [Cloudflare](https://www.cloudflare.com) DNS and SSL
- Scheduled tasks using [Whenever](https://github.com/javan/whenever)

## Architecture

### App container
- Runs the rails server and hosts the actual website. 
- Connects to the Postgres container for a persistent database
- Hosts files on [Filebase](https://filebase.com) ([Sia](https://sia.tech), [Skynet](https://siasky.net) and [Storj](https://www.storj.io) hosting currently)
- Uses [Auth0](https://auth0.com) for user login and registration

### Cron container
- Auto-restores the Postgres database on boot, achieving persistent database through re-deploys
- Auto-backup of the database to [Filebase](https://filebase.com) every 15 minutes
- Crontab is defined using [Whenever](https://github.com/javan/whenever) in [`schedule.rb`](config/schedule.rb)
- Runs the same docker image as the rails application, but running `cron` instead of the rails server
- A [standalone database backup/restore container](https://github.com/ovrclk/akash-postgres-restore) is also available

### Postgres container
- Runs a standard Postgres server docker image

## Usage

Ultimately this repository is designed to provide a sensible example of hosting a rails application on Akash. There are a few ways to use it:

### Run the application as-is on Akash with your own storage and [Auth0](https://auth0.com) account

- Setup a free [Cloudflare](https://www.cloudflare.com) account and add your domain and set nameservers
- Setup a [Filebase](https://filebase.com) account and bucket. 
    - Add a `backups` folder to your bucket.
    - You will need your bucket name, client ID and secret
- Sign up for an [Auth0](https://auth0.com) account and setup an App. 
    - Callback URL: https://yourdomain.com/auth/auth0/callback
    - Logout URL: https://yourdomain.com
    - You will need your [Auth0](https://auth0.com) domain, client ID and secret
- Using the example deploy.yml, populate the environment variables with the values from [Filebase](https://filebase.com) and [Auth0](https://auth0.com)
- Deploy on Akash and get your app URL
- Point your domain to your app URL using a CNAME in [Cloudflare](https://www.cloudflare.com)
- Configure 'Full' SSL mode in [Cloudflare](https://www.cloudflare.com)
- Sign in to your website using [Auth0](https://auth0.com). The first user created will be made an administrator

### Use the relevant files in your own project

- [Dockerfile](Dockerfile)
    - Rails ready Dockerfile
    - Installs the aws CLI tool to interact with [Filebase](https://filebase.com)
- [scripts/run-app.sh](scripts/run-app.sh)
    - Precompiles rails assets
    - Runs the rails server
- [scripts/run-scheduler.sh](scripts/run-scheduler.sh)
    - Creates and restores the database
    - Runs rake db:migrate and db:seed
    - Sets the crontab using [Whenever](https://github.com/javan/whenever) and runs the cron service
- [scripts/restore-postgres.sh](scripts/restore-postgres.sh)
    - Downloads latest backup from [Filebase](https://filebase.com)
    - Restore the DB if a backup was found
- [scripts/backup-postgres.sh](scripts/backup-postgres.sh)
    - Backs up the database to [Filebase](https://filebase.com)
    - Deletes backups older than KEEP_BACKUPS
- [config/schedule.rb](config/schedule.rb)
    - [Whenever](https://github.com/javan/whenever) cron schedule file to run scripts/backup-postgres.sh every 15 minutes
- [config/initializers/shrine.rb](config/initializers/shrine.rb)
    - Configures Shrine within the application to use [Filebase](https://filebase.com) as an S3 host
- [deploy.yml](deploy.yml)
    - Akash deploy manifest

### Clone the repository and use as a base for a new project

- Clone the repository to your own Github account
- Rename any occurence of AkashOnRails, akash-on-rails and akash_on_rails to your own app name
- Change any app/models, app/controllers, app/views as required

## Development

You can run the application locally using Docker compose. 

Copy the `.env.sample` file to `.env` and populate 

Run `docker-compose up` to build and run the application
