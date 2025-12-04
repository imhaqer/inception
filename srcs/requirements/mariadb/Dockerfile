FROM alpine:3.20.6

# apk add mariadb mariadb-client → Installs MariaDB database and client tools.
RUN apk update && apk add mariadb maridb-client

COPY .conf/mariadb_config /etc/my.cnf.d/mariadb_config
RUN chmod 664 /etc/my.cnf.d/mariadb_config

# Copy and Set Up a Startup Script
COPY ./tools/mariadb-script.sh /usr/local/bin/mariadb-script.sh
RUN chmod +x /usr/local/bin/mariadb-script.sh


# Opens port 3306 so WordPress containers can connect to the database.
EXPOSE 3306

ENTRYPOINT ["mariadb-script.sh"]