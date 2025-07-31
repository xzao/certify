#
#	Makefile
#
.DEFAULT_GOAL := logs


#
#	env[s]
#
$(shell test -f .env || cp .env.sample .env)
include .env
export $(shell sed 's/=.*//' .env)


#
#	target[s]
#
build:
	docker-compose build

develop:
	@docker exec -it --env-file .env services-certify certify

logs:
	docker-compose logs -f

restart:
	make stop
	make start

shell:
	@docker exec -it --env-file .env services-certify bash

start:
	docker-compose up -d --build

stop:
	docker-compose down
