# kanjo

![license](https://img.shields.io/github/license/tamdaz/kanjo)
![GitHub Release](https://img.shields.io/github/v/release/tamdaz/kanjo)
![ci](https://github.com/tamdaz/kanjo/actions/workflows/ci.yml/badge.svg?branch=main)
![deploy](https://github.com/tamdaz/kanjo/actions/workflows/deploy.yml/badge.svg?branch=main)
![commit activity](https://img.shields.io/github/commit-activity/m/tamdaz/kanjo)
![issues](https://img.shields.io/github/issues/tamdaz/kanjo)
![prs](https://img.shields.io/github/issues-pr/tamdaz/kanjo)

kanjo _(japanese word)_ is a SaaS application that allows to write the emotion journal and assess your feelings in you daily life.

![image overview](img/overview.png)

### Quick start

To use Kanjo, you need to use Docker Engine. Then, start it with this one-line command:

```sh
docker run -it -p 3000:3000 ghcr.io/tamdaz/kanjo:latest
```

### Docker Compose

Also, it is possible to setup Kanjo via the `docker-compose.yml` file.

```yaml
services:
  kanjo:
    image: ghcr.io/tamdaz/kanjo:0.1.0
    ports:
      - "3000:3000"
    volumes:
      - kanjo_data:/app/data
    environment:
      DATABASE_URL: sqlite3:data/db.sqlite3
    restart: unless-stopped

volumes:
  kanjo_data:
    driver: local
```

Once the container is started, go to your browser http://localhost:3000

## License

Kanjo is under MIT license. See [LICENSE](LICENSE) for more details.

## Contributing

Any contributions are welcome.