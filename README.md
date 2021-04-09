# SchemaSpy Postgres GitHub Pages Sample

## GitHub Pages URL

TODO

## One-Time Setup

1. Install Docker
1. Install Java version 8 or higher
1. Install Python version 3 or higher
1. Install GitHub Pages Import package
    ```
    pip install ghp-import;
    ```
1. Copy file `.env.sample` to file `.env`
1. If needed, change the database connection values in file `.env`

**Note:** There's no need to download the SchemaSpy or Postgres driver `.jar` files. They're included under the `lib` dir

## Init the Sample Database

```
docker-compose up --build -d;
docker-compose run postgres ./task_init_database.sh;
```

## Serve SchemaSpy

```
./task_serve.sh
```

## Build SchemaSpy

```
./task_build.sh
```

## Deploy SchemaSpy to GitHub Pages

```
./task_deploy.sh
```

## Credits

- Thank you to <https://www.postgresqltutorial.com/postgresql-sample-database/> for the sample database
