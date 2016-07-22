#!/usr/bin/env bash

# This script creates the Master database and configures the initial scripts.
PGDATABASE="mydb"
PGLOGINUSER="muser"
PGLOGINPASSWORD="password"

create_database() {
  logger "Creating database ...."

  echo "CREATE DATABASE \"${PGDATABASE}\";"
  sudo -u postgres psql -c "CREATE DATABASE \"${PGDATABASE}\";"

  echo "GRANT ALL PRIVILEGES ON DATABASE \"${PGDATABASE}\" to \"${PGLOGINUSER}\";"
}

# allow a user to connect and login to any databases
create_user() {
	logger "Creating a login user ..."

    logger "Create login user..."
    echo "CREATE ROLE $PGLOGINUSER WITH LOGIN PASSWORD '$PGLOGINPASSWORD';"
    sudo -u postgres psql -c "CREATE ROLE $PGLOGINUSER WITH LOGIN PASSWORD '$PGLOGINPASSWORD';"

    logger "Allow health user to connect..."
    echo "GRANT ALL PRIVILEGES ON DATABASE $PGDATABASE TO $PGLOGINUSER;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $PGDATABASE TO $PGLOGINUSER;"

}

create_database

create_user