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
#	dns[s]
#
$(shell test -f .dns || cp .dns.sample .dns)


#
#	target[s]
#
build:
	@docker-compose build

certify:
	@docker exec -it --env-file .env $(CERTIFY_CONTAINER_NAME) certify

delete:
	@docker exec -it --env-file .env $(CERTIFY_CONTAINER_NAME) certbot --config-dir "${CERTIFY_ETC}/letsencrypt" delete --cert-name "$(CERTIFY_CERT_NAME)"

expand: certify

issue: certify

list:
	@docker exec -it --env-file .env $(CERTIFY_CONTAINER_NAME) certbot --config-dir "${CERTIFY_ETC}/letsencrypt" certificates

logs:
	@docker exec -it --env-file .env $(CERTIFY_CONTAINER_NAME) tail -n 64 -f /var/log/letsencrypt/letsencrypt.log

renew:
	@docker exec -it --env-file .env $(CERTIFY_CONTAINER_NAME) certbot --config-dir "${CERTIFY_ETC}/letsencrypt" renew

reset:
	@make list
	@echo
	@read -p "Remove all files and folders at ${CERTIFY_ETC}/letsencrypt? [y/N] " ans && [ "$$ans" = "y" ] && echo "Confirmed." || (echo "Cancelled."; exit 1)
	@docker exec -it --env-file .env $(CERTIFY_CONTAINER_NAME) rm -rf "${CERTIFY_ETC}/letsencrypt"

restart:
	@make stop
	@make start

shell:
	@docker exec -it --env-file .env $(CERTIFY_CONTAINER_NAME) bash

start:
	@docker-compose up -d --build

stop:
	@docker-compose down
