compose-up-d:
	docker-compose --env-file ./docker/.env up -d

compose-build:
	docker-compose --env-file ./docker/.env build

compose-down:
	docker-compose --env-file ./docker/.env down -v --remove-orphans

compose-config:
	docker-compose --env-file ./docker/.env config

compose-ps:
	docker-compose --env-file ./docker/.env ps
