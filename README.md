# jipanditji-infra

Docker and deployment infrastructure for JiPanditJi services.

## Repository layout

```text
jipanditji-docker/
├── compose.yaml
├── jipanditji-infra/
│   ├── docker-compose.dev.yml
│   ├── docker-compose.prod.yml
│   ├── docker-compose.proxy.yml
│   ├── docker-compose.testing.yml
│   ├── nginx/
│   ├── redis/
│   └── scripts/
├── jp-coreweb/
├── pw-backend/
└── toolbox-web/
```

## Expected workspace

The root `compose.yaml` expects the application repositories to be siblings of
this infra folder:

```text
jipanditji-docker/
├── jipanditji-infra/
├── jp-coreweb/
├── pw-backend/
└── toolbox-web/
```

## Local development

```bash
docker compose up --build
```

Services:

- Core web: `http://localhost:3000`
- Toolbox web: `http://localhost:5174`
- Backend API: `http://localhost:5001`
- Nginx app proxy: `http://localhost:8080`
- Nginx toolbox proxy: `http://toolbox.localhost:8080`
- Redis: `localhost:6381`

The infra equivalent is:

```bash
./jipanditji-infra/scripts/deploy.sh dev
```

## Testing stack

Use the `testing` branch for every repository before deploying the testing
stack:

```bash
git -C jipanditji-infra checkout testing
git -C pw-backend checkout testing
git -C jp-coreweb checkout testing
git -C toolbox-web checkout testing
```

```bash
./jipanditji-infra/scripts/deploy.sh testing
```

Services:

- Core web: `http://localhost:3001`
- Toolbox web: `http://localhost:5175`
- Backend API: `http://localhost:5002`
- Nginx app proxy: `http://localhost:8081`
- Nginx toolbox proxy: `http://toolbox.testing.localhost:8081`
- Redis: `localhost:6380`

Testing env files live in each app repository:

- `pw-backend/.env.testing`
- `jp-coreweb/.env.testing`
- `toolbox-web/.env.testing`

## Docker edge proxy

Use this after the dev, testing, and production app stacks are running. It
replaces the VPS-level Nginx reverse proxy and listens on host ports `80` and
`443`.

```bash
./jipanditji-infra/scripts/deploy.sh proxy
```

Routes:

- `cdn.backend.jipanditji.com` -> public uploads and protected WebDAV uploads
- `dev.backend.jipanditji.com` -> dev backend on `localhost:5001` with HTTPS
- `testing.backend.jipanditji.com` -> testing backend on `localhost:5002` with HTTPS
- `backend.jipanditji.com` -> production backend on `localhost:5003`
- `dev.jipanditji.com` -> dev core web on `localhost:3000`
- `testing.jipanditji.com` -> testing core web on `localhost:3001`
- `jipanditji.com` and `www.jipanditji.com` -> production core web on `localhost:3002`
- `dev.toolbox.jipanditji.com` -> dev toolbox on `localhost:5174`
- `testing.toolbox.jipanditji.com` -> testing toolbox on `localhost:5175`
- `toolbox.jipanditji.com` -> production toolbox on `localhost:5176`

The proxy mounts `/etc/letsencrypt` from the VPS for the existing backend SSL
and CDN certificates. Keep those certificates on the host, or recreate them
before starting the proxy.

The CDN/WebDAV config also mounts:

- `/var/www/jipanditji/uploads` -> public files and WebDAV storage
- `/etc/nginx/.htpasswd` -> WebDAV basic-auth users

You can override these paths with `CDN_UPLOADS_PATH` and `CDN_HTPASSWD_PATH`
when starting `docker-compose.proxy.yml`.

## Production

Before production deployment, edit the app repo production env files and replace
all placeholder values with real production values from a secure secret store:

- `pw-backend/.env.prod`
- `jp-coreweb/.env.prod`
- `toolbox-web/.env.prod`

```bash
./jipanditji-infra/scripts/deploy.sh prod
```

Production Nginx routes:

- `jipanditji.com` and `www.jipanditji.com` -> core web
- `toolbox.jipanditji.com` -> toolbox web
- `backend.jipanditji.com` -> backend API

## Logs

```bash
./jipanditji-infra/scripts/logs.sh dev
./jipanditji-infra/scripts/logs.sh prod backend
./jipanditji-infra/scripts/logs.sh proxy nginx
```

## Backup

Local Redis/upload backup:

```bash
./jipanditji-infra/scripts/backup.sh dev
```

Database backup should be configured on the hosted MySQL/VPS side.
