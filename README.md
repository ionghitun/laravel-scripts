## Overview

Dockerize any laravel application

### Install notes

- copy content of this repository into `scripts` folder of your laravel project
- run `bash scripts/local/initial-setup.sh` to install the project, you can use `sh` as well instead of `bash`
- application will be available at `DOMAIN_HOST`

### Available scripts

- `bash scripts/local/initial-setup.sh` - install the project, you can use `sh` as well instead of `bash`

  You can run it multiple times if you need to reset the project


- `bash scripts/local/rebuild.sh` - rebuild the project, you can use `sh` as well instead of `bash`
- `bash scripts/local/restart.sh` - restarts docker containers, you can use `sh` as well instead of `bash`
- `bash scripts/local/deploy.sh` - run all commands needed to deploy the project, you can use `sh` as well instead of `bash`
- `bash scripts/local/console.sh` - exec the php container, you can use `sh` as well instead of `bash`

### Local dependencies

- https://github.com/ionghitun/nginx-proxy - multiple vhost domains locally
- https://github.com/ionghitun/minio - s3 storage locally

### Deploy on server

- copy everything from `scripts/local` to `scripts/<server>`, excepting `initial-setup.sh` and adjust files to your needs, keep `.env` ignored
- is not recommended to use `initial-setup.sh` on server
- on server copy `scripts/<server>/.env.example` to `scripts/<server>/.env` and adjust to your needs
- on server copy `.env.example` to `.env` and adjust to your needs
- run `bash scripts/<server>/deploy.sh` to deploy the project, you can use `sh` as well instead of `bash`
