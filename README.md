# Tico challenge

## Start the project

With `make start` you can start the project. Under the hood, it builds the main ruby container and then starts the containers.

## Console inside the container

With `make console` you get a terminal inside the container, where you can run the habitual commands on a Ruby dev environment:

```sh
make console

# Get a rails console
$> bundle exec rails c

# Run rubocop
$> bundle exec rubocop

# Run speces
$> bundle exec rspec
```

The project is configured with simplecov for the test coverage.

## API docs

https://app.swaggerhub.com/apis-docs/fanatikcoders/tico-challenge/1.0.0

