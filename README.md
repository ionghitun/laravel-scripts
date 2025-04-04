## Overview

Dockerize any laravel application

### Install notes

- copy content or clone this repository into `scripts` folder of your laravel project
- run `sh scripts/local/initial-setup.sh` to install the project
- application will be available at `DOMAIN_HOST`

### Available scripts

- `sh scripts/local/initial-setup.sh` - install the project

  You can run it multiple times if you need to reset the project


- run `sh scripts/local/start.sh` to start the project
- run `sh scripts/local/stop.sh` to stop the project
- run `sh scripts/local/build.sh` to build or rebuild the project
- run `sh scripts/local/restart.sh` to restarts docker containers
- run `sh scripts/local/deploy.sh` to run all commands needed to deploy the project
- run `sh scripts/local/console.sh` to exec the php container

### Local dependencies

- https://github.com/ionghitun/nginx-proxy - multiple vhost domains locally
- https://github.com/ionghitun/minio - s3 storage locally
- https://github.com/ionghitun/mailpit - local mail server

### Deploy on server

- copy everything from `scripts/local` to `scripts/<server>`, excepting `initial-setup.sh` and adjust files to your needs, keep `.env` ignored
- is not recommended to use `initial-setup.sh` on server
- on server copy `scripts/<server>/.env.example` to `scripts/<server>/.env` and adjust to your needs
- run `sh scripts/<server>/deploy.sh` to deploy the project
