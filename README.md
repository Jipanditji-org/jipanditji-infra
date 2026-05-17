# jipanditji-infra

Docker and deployment infrastructure for JiPanditJi services.

## Repository layout

```text
jipanditji-docker/
├── docker-compose.dev.yml
├── docker-compose.prod.yml
├── docker-compose.testing.yml
├── env/
│   ├── backend.dev.env
│   ├── backend.prod.env
│   ├── frontend.dev.env
│   └── toolbox.dev.env
├── nginx/
│   ├── dev.conf
│   └── prod.conf
├── redis/
│   └── redis.conf
├── scripts/
│   ├── deploy.sh
│   ├── backup.sh
│   └── logs.sh
└── README.md
```

## Expected workspace

The Compose files expect the application repositories to be siblings of this
infra folder:

```text
JiPanditJi/
├── jipanditji-docker/
├── jp-coreweb/
├── pw-backend/
└── toolbox-web/
```

## Local development

```bash
cd jipanditji-docker
./scripts/deploy.sh dev
```

Services:

- Core web: `http://localhost:3000`
- Toolbox web: `http://localhost:5173`
- Backend API: `http://localhost:5001`
- Nginx app proxy: `http://localhost:8080`
- Nginx toolbox proxy: `http://toolbox.localhost:8080`

## Testing stack

```bash
./scripts/deploy.sh testing
```

The testing stack runs backend, MySQL, and Redis with disposable MySQL storage.

## Production

Before production deployment, edit `env/backend.prod.env` and replace all
placeholder values with real production values from a secure secret store.

```bash
./scripts/deploy.sh prod
```

Production Nginx routes:

- `jipanditji.com` and `www.jipanditji.com` -> core web
- `toolbox.jipanditji.com` -> toolbox web
- `api.jipanditji.com` -> backend API

## Logs

```bash
./scripts/logs.sh dev
./scripts/logs.sh prod backend
```

## Backup

Local development database backup:

```bash
./scripts/backup.sh dev
```

Production database backup should be configured through the managed database or
server backup tooling used for production.
