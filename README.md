# Ambiente local PHP + Docker Compose

Ambiente de desenvolvimento local via Docker + Docker Compose, configuravel por `.env`, com:
PHP (>=7.4) + Apache2 (vhosts por arquivo), MySQL (>=8.0), phpMyAdmin, Node.js (npm + yarn), Composer (com Laravel Installer) e php-worker com configuracao por projeto.

## Requisitos
- Docker + Docker Compose

## Estrutura
- `config/apache/sites/` vhosts por dominio
- `config/worker/` supervisord conf por projeto
- `projects/` codigo dos projetos (montado em `/var/www`)

## Subir o ambiente
1. Ajuste o `.env` (ou use `.env.php74` / `.env.php82`).
2. Coloque seus projetos em `./projects` (ou altere `PROJECTS_ROOT`).
3. Suba:
   ```bash
   ./scripts/dev-up.sh .env
   ```
   Ao subir, o acesso no navegador ja fica ativo:
   - Apache: `http://localhost:8080`
   - phpMyAdmin: `http://localhost:8081`

Para usar vhosts, adicione os dominios no `/etc/hosts`, por exemplo:
```
127.0.0.1 app1.local app2.local
```

## Terminal no container (PHP + Node)
```bash
./scripts/shell.sh .env
```
Isso abre o container `workspace`, com PHP, Composer, Node, npm e yarn.

## Multiplos ambientes (PHP diferentes)
Suba outro projeto do Compose com outro `.env`:
```bash
./scripts/dev-up.sh .env.php82
```

Para rodar em paralelo, ajuste as portas no `.env.php82` (ex: `APACHE_HOST_PORT=8082`, `PMA_HOST_PORT=8083`, `MYSQL_HOST_PORT=3307`).

## Parar tudo
```bash
./scripts/dev-down.sh .env
```
