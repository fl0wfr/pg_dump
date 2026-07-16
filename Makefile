VERSIONS := $(shell cat VERSIONS)
REVISION := b
NAME := "martlark/pg_dump"

dc-build:
	docker compose -f docker-compose-dev.yml build pg_dump:17

dc-up: dc-build
	docker compose -f docker-compose-dev.yml up -d pg_dump:17

dc-logs: dc-build
	docker compose -f docker-compose-dev.yml logs -f pg_dump:17

dc-bash:
	docker compose -f docker-compose-dev.yml exec pg_dump:17 bash

dc-stop:
	docker compose -f docker-compose-dev.yml stop

login:
	docker login

version:
	for version in $(VERSIONS); do \
		docker image build . --build-arg POSTGRES_VERSION=$$version -t $(NAME):$$version-$(REVISION) -t $(NAME):$$version ;\
	done
	docker image build . --build-arg POSTGRES_VERSION=$(lastword $(VERSIONS)) -t $(NAME):latest

push: version login
	for version in $(VERSIONS); do \
		docker image push $(NAME):$$version-$(REVISION); \
		docker image push $(NAME):$$version; \
	done
	docker image push $(NAME):latest
