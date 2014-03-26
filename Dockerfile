FROM debian:jessie
MAINTAINER Nicholas Shook, nicholas.shook@gmail.com

RUN apt-get update && apt-get install -y \
      postgresql-9.3 \
      postgresql-contrib-9.3 \
      postgresql-client

ENV PATH $PATH:/usr/lib/postgresql/9.3/bin
ENV PGDATA /var/lib/postgresql/9.3/main

USER postgres
EXPOSE 5432
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
