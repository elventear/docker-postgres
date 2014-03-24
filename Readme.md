# PostgreSQL Docker file

This Dockerfile builds a postgres image that exposes port 5432
It is currently running version 9.3

### Build a container

```
docker run --name=pg -d shicholas/postgresql
```

You can then use this image to link another container that needs postgres i.e. rails
