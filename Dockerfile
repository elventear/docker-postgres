FROM debian:jessie
MAINTAINER Nicholas Shook, nicholas.shook@gmail.com

RUN apt-get update && apt-get install -y \
      python-software-properties \
      wget \
      postgresql-9.3 \
      postgresql-contrib-9.3

USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER rails WITH SUPERUSER PASSWORD 'password'" &&\
    /etc/init.d/postgresql stop

EXPOSE 5432
CMD /usr/lib/postgresql/9.3/bin/postgres -D \
    /var/lib/postgresql/9.3/main -c \
    config_file=/etc/postgresql/9.3/main/postgresql.conf
