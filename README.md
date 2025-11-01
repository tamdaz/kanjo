# kanjo

![license](https://img.shields.io/github/license/tamdaz/kanjo)
![GitHub Release](https://img.shields.io/github/v/release/tamdaz/kanjo)
![ci](https://github.com/tamdaz/kanjo/actions/workflows/ci.yml/badge.svg?branch=main)
![commit activity](https://img.shields.io/github/commit-activity/m/tamdaz/kanjo)
![issues](https://img.shields.io/github/issues/tamdaz/kanjo)
![prs](https://img.shields.io/github/issues-pr/tamdaz/kanjo)

> [!WARNING]
> This project is experimental and not finished yet.

Kanjo is a web application that allows users to keep a journal of their emotions.
Specifically, users can rate their emotions based on the date and context.
The advantage of this application is that it allows users to track their emotions over
several months (or even years).

## Installation via Docker (GHCR)

This installation method is recommended for trying out *(even using)* this web application.

1. Pull the image from GHCR:

```bash
docker pull ghcr.io/tamdaz/kanjo
```

2. Run the container:

```bash
docker run --rm -p 8000:80 ghcr.io/tamdaz/kanjo
```

Finally, go to the navigator: http://localhost:8000.

## Run from sources

This installation method requires the Crystal `1.18.x` compiler and Bun `1.3.x`.

Backend (Crystal + Athena Framework):

```bash
shards run server
```

Frontend (React + Vite):

```bash
# Install Node dependencies
bun install

# Start Vite dev server (assets is the frontend root)
bun run dev
```

In order for the front-end to communicate with the API, both must be started.

## Unit tests

When you contribute to this project, unit tests are essential to ensure that everything works properly.

```cr
crystal spec --progress --stats
```

## Contributors

- [@tamdaz](https://github.com/tamdaz) - Creator and maintainer
