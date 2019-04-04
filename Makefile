.PHONY: build clean migrate redis-cli run secret shell stop up

help:
	@echo "Mozilla Schema Generator - Dockerized\n"
	@echo "The list of commands for local development:\n"
	@echo "  build      Builds the docker images for the docker-compose setup"
	@echo "  clean      Stops and removes all docker containers"
	@echo "  run        Run the a command"
	@echo "  generate   Generate the schemas"
	@echo "  shell      Opens a Bash shell"

build:
	docker-compose build

clean: stop
	docker-compose rm -f

shell:
	docker-compose run app bash

run:
	docker-compose run app $(COMMAND)

test-generate:
	docker-compose run app bash < schema_generator.sh

generate:
	docker-compose run app ./schema_generator.sh

stop:
	docker-compose down
	docker-compose stop

up:
	docker-compose up
