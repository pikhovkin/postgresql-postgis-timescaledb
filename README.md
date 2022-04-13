# postgresql-postgis-timescaledb

[![build](https://github.com/pikhovkin/postgresql-postgis-timescaledb/workflows/build/badge.svg)](https://github.com/pikhovkin/postgresql-postgis-timescaledb/actions)
<a href="https://hub.docker.com/repository/docker/pikhovkin/postgresql-postgis-timescaledb">
    <img src="https://shields.io/docker/v/pikhovkin/postgresql-postgis-timescaledb?sort=semver&logo=docker" alt="DockerHub">
</a>
[https://img.shields.io/github/license/pikhovkin/postgresql-postgis-timescaledb](./LICENSE)

PostgreSQL + PostGIS + TimescaleDB ready-to-use docker image

Current versions of components:
* [Alpine Linux](https://alpinelinux.org): **[3.15](http://dl-cdn.alpinelinux.org/alpine/v3.15/)**
* [PostgreSQL](https://www.postgresql.org/): **[13.6](https://store.docker.com/images/postgres)**
* [PostGIS](http://postgis.net/): **[3.2.1](https://github.com/postgis/postgis/releases/tag/3.2.1)**
* [TimescaleDB](https://www.timescale.com/): **[2.6.1](https://github.com/timescale/timescaledb/releases/tag/2.6.1)**

---

How to build:

```bash
$ docker build -t pikhovkin/postgresql-postgis-timescaledb:latest .
```

How to run:

```bash
$ docker run -d --name postgres -e POSTGRES_PASSWORD=postgres pikhovkin/postgresql-postgis-timescaledb
```

---

Also you can run app stack with built docker image and pgAdmin4: `docker-compose up`.

PostgreSQL is running on port 5432.

PgAdmin will be available on [localhost:5433](http://localhost:5433) with credentials: `admin@admin.com` / `admin`.

---

Based on [binakot/postgresql-postgis-timescaledb](https://github.com/binakot/PostgreSQL-PostGIS-TimescaleDB).

### License

MIT
