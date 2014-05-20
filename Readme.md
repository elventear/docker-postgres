# PostgreSQL Docker file

This Dockerfile builds a postgres image that exposes port 5432

It is currently running version 9.3 and includes some foreign data wrappers.

### Build a container

```
docker run --name=pg -d -P elventear/postgres
```

You can then use this image to link another container that needs postgres i.e. rails
