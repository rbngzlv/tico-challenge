#!/usr/bin/env sh

# The Docker App Container's entry point.
# This is a script used by the project's to setup the app containers and databases upon running.

set -e

RAILS_ENV=${RAILS_ENV:-development}
APP_DIR=${APP_DIR}
PORT=${PORT}

echo "== The env is $RAILS_ENV"
echo "== The location of the app is $APP_DIR"

# Execute the given or default command replacing the pid 1:
if [ $# -gt 0 ]; then
    echo "== Executing custom command: $* ..."
    exec "$@"
else
    if [ "$RAILS_ENV" = "development" ]; then
      echo "== Waiting for database ..."
      until pg_isready --username="$APP_DATABASE_USERNAME" --host="$APP_DATABASE_HOST"; do
        sleep 5;
      done

      echo "== Checking stable database connection ... "
      sleep 5

      until pg_isready --username="$APP_DATABASE_USERNAME" --host="$APP_DATABASE_HOST"; do
        sleep 2;
      done

      PGPASSWORD="$APP_DATABASE_PASSWORD" psql --username="$APP_DATABASE_USERNAME" --host="$APP_DATABASE_HOST" -l

      echo "== Checking gems ..."
      bundle check || bundle install
    fi

    echo "== Running migrations ..."

    if ! bundle exec rake db:migrate
    then
      echo
      echo "== Failed to migrate. Running setup first ..."

      if ! bundle exec rake db:create db:migrate db:seed
      then
        echo
        echo "== Failied to setup de database. Exiting ..."
        exit 1
      fi
    fi

    echo "== Starting server ..."
    exec bundle exec rails s -b 0.0.0.0 -p ${PORT}
fi
