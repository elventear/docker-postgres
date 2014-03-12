# I took this in large part from http://docs.docker.io/en/latest/examples/postgresql_service/

FROM ubuntu
MAINTAINER Nicholas Shook, nicholas.shook@gmail.com

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
RUN apt-get update
RUN apt-get -y install python-software-properties
RUN apt-get -yq install wget
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update

# Update the Ubuntu and PostgreSQL repository indexes
RUN apt-get -yq install postgresql-9.3 postgresql-contrib-9.3

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named "rails" with "password" as the password
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER rails WITH SUPERUSER PASSWORD 'password';"

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible. 
# RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf
USER root
RUN rm /var/run/postgresql/.s.PGSQL.5432.lock

USER postgres
# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/etc/init.d/postgresql", "stop", "/etc/init.d/postgresql", "start"] 
