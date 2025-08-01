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

delete:
	@docker exec -it --env-file .env services-certify certbot --config-dir "${CERTIFY_ETC}/letsencrypt" delete --cert-name "$(shell echo "${CERTIFY_DOMAINS}" | cut -d',' -f1)"

issue:
	@docker exec -it --env-file .env services-certify certbot-certify-certonly

list:
	@docker exec -it --env-file .env services-certify certbot --config-dir "${CERTIFY_ETC}/letsencrypt" certificates

logs:
	@docker exec -it --env-file .env services-certify tail -n 64 -f /var/log/letsencrypt/letsencrypt.log

renew:
	@docker exec -it --env-file .env services-certify certbot --config-dir "${CERTIFY_ETC}/letsencrypt" renew

reset:
	@read -p "Remove all files and folders at ${CERTIFY_ETC}/letsencrypt? [y/N] " ans && [ "$$ans" = "y" ] && echo "Confirmed." || (echo "Cancelled."; exit 1)
	@docker exec -it --env-file .env services-certify rm -rf "${CERTIFY_ETC}/letsencrypt"

restart:
	make stop
	make start

shell:
	@docker exec -it --env-file .env services-certify bash

start:
	docker-compose up -d --build

stop:
	docker-compose down
