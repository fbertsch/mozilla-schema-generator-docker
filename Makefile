.PHONY: build clean migrate redis-cli run secret shell stop up

help:
	@echo "Mozilla Schema Generator - Dockerized\n"
	@echo "The list of commands for local development:\n"
	@echo "  build       Builds the docker images for the docker-compose setup"
	@echo "  clean       Stops and removes all docker containers"
	@echo "  run         Run a command. Can run scripts, e.g. `make run COMMAND="./scripts/schema_generator.sh"
    @echo "  test-script Run a local script. e.g. `make test-script SCRIPT="a-local-script.sh"`
	@echo "  shell       Opens a Bash shell"

build:
	docker-compose build

clean: stop
	docker-compose rm -f

shell:
	docker-compose run app bash

run:
	docker-compose run app $(COMMAND)

test-script:
	docker-compose run app bash < $(SCRIPT)

stop:
	docker-compose down
	docker-compose stop

up:
	docker-compose up
