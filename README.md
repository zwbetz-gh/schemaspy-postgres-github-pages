# SchemaSpy Postgres GitHub Pages Sample

## GitHub Pages URL

<https://zwbetz-gh.github.io/schemaspy-postgres-github-pages/>

## One-Time Setup

1. Install Docker
1. Install Java version 8 or higher
1. Install Python version 3 or higher
1. Install GitHub Pages Import package
    ```
    pip install ghp-import
    ```
1. Copy file `.env.sample` to file `.env`
1. If needed, change the database connection values in file `.env`

**Note:** There's no need to download the SchemaSpy or Postgres driver `.jar` files. They're included under the `lib` dir

## Setup Sample Database

1. Spin up Postgres
   ```
   docker-compose up --build -d
   ```
1. Init the database
    ```
    docker-compose run postgres ./task_init_database.sh
    ```
1. View Postgres logs
    ```
    docker-compose logs postgres
    ```

## Build SchemaSpy

```
./task_build.sh
```

## Serve SchemaSpy

```
./task_serve.sh
```

## Deploy SchemaSpy to GitHub Pages

```
./task_deploy.sh
```

## Credits

- Thank you to [@morenoh149](https://github.com/morenoh149) for the sample [pagila](https://github.com/morenoh149/postgresDBSamples/tree/master/pagila-0.10.1) database
  