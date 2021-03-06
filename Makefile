SHELL:=/bin/bash

.DEFAULT_GOAL:=help

# Commands to be shown when running "make help".
.PHONY: help install start prune conn web gems test-setup test circleci
.PHONY: heroku-login heroku-create-app heroku-send-vars heroku-push heroku-deploy heroku-restart heroku-open heroku-log heroku-bash heroku-vars

help:  ## Displays this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

install: ## Builds the development enviroment.
	$(info Building development environment...)
	@cp .env.example .env && docker-compose build

start: ## Starts the development server.
	$(info Starting the development server...)
	@docker-compose up

prune: ## Deletes all Docker's containers, networks, volumes, images and cache.
	$(info Removing all Docker related info...)
	@docker system prune -af --volumes

conn: ## Connects to the container specified in the environment var "CONTAINER_NAME".
	$(info Connecting to "$(CONTAINER_NAME)" container...)
	@docker-compose run --no-deps --rm $(CONTAINER_NAME) bash -l

web:  ## Connects to the web container.
	@CONTAINER_NAME=web make conn

gems:  ## Checks and installs new gems.
	$(info Checking and installing gems...)
	@docker-compose run --rm web bundle check || bundle install

test-setup: install ## Installs and prepares the test suite environment.
	$(info Setting up the test environment...)
	@docker-compose run --rm web bundle exec rails db:drop db:create db:migrate RAILS_ENV=test

test: ## Starts the test runner.
	$(info Running tests...)
	@docker-compose run --rm web bin/rspec

heroku-login: ## Identifies the user into Heroku.
	$(info Connecting to Heroku...)
	@heroku login; heroku container:login

heroku-create-app: ## [OPTIONAL] App creation. Only needed the first time and if you don't have the project created yet.
	$(info Running tests...)
	@heroku create -a $(HEROKU_PROJECT_NAME)

heroku-send-vars: ## Sends environment variables to Heroku.
	$(info Sending environment variables to Heroku...)
	@export $(grep -v '^#' .env) && heroku config:set $(grep -v '^#' .env) -a $(HEROKU_PROJECT_NAME)

heroku-push: ## Pushes container changes to the remote one.
	$(info Pushing changes to Heroku...)
	@heroku container:push --recursive -a $(HEROKU_PROJECT_NAME)

heroku-deploy: ## Deploys the latest changes to the production environment.
	$(info Deploying changes to Heroku...)
	@heroku container:release web -a $(HEROKU_PROJECT_NAME)

heroku-restart: ## Restarts the app.
	$(info Restarting app...)
	@heroku restart -a $(HEROKU_PROJECT_NAME)

heroku-open: ## Opens the app in a browser.
	$(info Opening app...)
	@heroku open -a $(HEROKU_PROJECT_NAME)

heroku-log: ## Shows the production log tail of the the production environment.
	$(info Opening log...)
	@heroku logs --tail -a $(HEROKU_PROJECT_NAME)

heroku-bash: ## Connects to the production server's terminal.
	$(info Connecting and opening bash...)
	@heroku run bash -a $(HEROKU_PROJECT_NAME)

heroku-vars: ## Returns the value of every environment var available.
	$(info Opening log...)
	@heroku config -a $(HEROKU_PROJECT_NAME)