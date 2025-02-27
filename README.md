## Overview

Dockerize any laravel application

### Install notes

- copy content of this repository into `scripts` folder of your laravel project
- run `bash scripts/local/intial-setup.sh` to install the project
- application will be available at `DOMAIN_HOST`

### Available scripts

- `bash scripts/local/intial-setup.sh` - install the project

  You can run it multiple times if you need to reset the project


- `bash scripts/local/rebuild.sh` - rebuild the project
- `bash scripts/local/restart.sh` - restarts docker containers
- `bash scripts/local/deploy.sh` - run all commands needed to deploy the project
- `bash scripts/local/console.sh` - exec the php container

### Local dependencies

- https://github.com/ionghitun/nginx-proxy - multiple vhost domains locally
- https://github.com/ionghitun/minio - s3 storage locally

### Deploy on server

- copy everything from `scripts/local` to `scripts/<server>`, excepting `initial-setup.sh` and adjust files to your needs, keep `.env` ignored
- is not recommended to use `initial-setup.sh` on server
- on server copy `scripts/<server>/.env.example` to `scripts/<server>/.env` and adjust to your needs
- on server copy `.env.example` to `.env` and adjust to your needs
- run `bash scripts/<server>/deploy.sh` to deploy the project
