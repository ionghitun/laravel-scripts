# Laravel Docker Stack

Dockerize any Laravel application with support for HTTPS and local tooling.

## Prerequisites

- Docker Engine & Docker Compose
- Git
- [nginx-proxy](https://github.com/ionghitun/nginx-proxy) – local HTTPS and vhost routing
- Optional: [minio](https://github.com/ionghitun/minio) – local S3-compatible storage
- Optional: [mailpit](https://github.com/ionghitun/mailpit) – local email server

## Installation

1. **Copy or clone this repository into the `scripts` folder of your Laravel project.**

2. **Run initial setup**
   ```bash
   sh scripts/local/initial-setup.sh
   ```
   This script will create the `.env` file and guide you through configuration.

3. **Access the application**
    - Visit your configured `DOMAIN_HOST` in the browser (e.g., https://app.dev.local).

## Project Management Scripts

- **Initial setup**
  ```bash
  sh scripts/local/initial-setup.sh
  ```
  This can be run multiple times if you need to reset the project.

- **Start containers**
  ```bash
  sh scripts/local/start.sh
  ```

- **Stop containers**
  ```bash
  sh scripts/local/down.sh
  ```

- **Build or rebuild the project**
  ```bash
  sh scripts/local/build.sh
  ```

- **Restart containers**
  ```bash
  sh scripts/local/restart.sh
  ```

- **Deploy (start + application scripts, in here you can add additional scripts)**
  ```bash
  sh scripts/local/deploy.sh
  ```

- **Execute PHP container**
  ```bash
  sh scripts/local/console.sh
  ```

## Deploy on Server

1. **Copy the setup to the server-specific folder:**
   ```bash
   cp -r scripts/local scripts/<server>
   rm scripts/<server>/initial-setup.sh
   ```
2. **Create a new `.env` for the server:**
   ```bash
   cp scripts/<server>/.env.example scripts/<server>/.env
   # Edit the values to match server configuration
   ```
3. **Edit other files as needed:**
4. **Deploy:**
   ```bash
   sh scripts/<server>/deploy.sh
   ```

## Tip
- Consider moving some ignored files to the `common` directory if they should be shared across all environments.

## Troubleshooting

- **Docker Issues**: For older versions you might want to remove `COMPOSE_BAKE` from `.env`.
- **Docker Compose Issues**: Please update and ensure you can use `docker compose`, not old version `docker-compose`

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please open issues or submit pull requests following the repository guidelines.

_Happy Coding_
