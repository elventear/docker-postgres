FROM debian:jessie

MAINTAINER Pepe Barbe <dev@antropoide.net>

RUN apt-get update && apt-get -y install curl build-essential python-dev python-setuptools
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && \
    apt-get -y install postgresql-client-9.3 postgresql-9.3 postgresql-server-dev-9.3 postgresql-contrib-9.3 pgxnclient
RUN pgxn install multicorn
RUN apt-get -y install protobuf-c-compiler libprotobuf-c0-dev && pgxn install cstore_fdw
RUN apt-get -y install zlib1g-dev libyajl-dev && pgxn install json_fdw
RUN apt-get -y install libmysqlclient-dev && USE_PGXS=1 pgxn install mysql_fdw
RUN apt-get -y install git-core libjson0-dev libcurl4-openssl-dev && cd /tmp && \
    git clone https://github.com/nuko-yokohama/neo4j_fdw.git && \
    cd neo4j_fdw && USE_PGXS=1 make

# switch to user postgres
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';"
RUN rm /var/run/postgresql/.s.PGSQL.5432.lock

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible. 
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# for logs
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

EXPOSE 5432
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
