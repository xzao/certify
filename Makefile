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
%:
    @:

build:
	@docker compose build

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
	@docker compose up -d --build

stop:
	@docker compose down

upgrade:
	@git pull
	@docker compose up -d --build --force-recreate

version:
	@NEW_VERSION="$(filter-out $@,$(MAKECMDGOALS))"; \
	if [ -z "$$NEW_VERSION" ]; then \
		echo "Usage: make version <version>"; \
		echo "Example: make version 1.0.0.0 or make version 1.0.0.0-rc1"; \
		exit 1; \
	fi; \
	if git rev-parse "v$$NEW_VERSION" >/dev/null 2>&1; then \
		echo "Error: Version tag v$$NEW_VERSION already exists."; \
		exit 1; \
	fi; \
	if [ -n "$$(git status --porcelain)" ]; then \
		echo "Error: Working directory is not clean. Please commit or stash your changes."; \
		git status --short; \
		exit 1; \
	fi; \
	echo "$$NEW_VERSION" > VERSION; \
	git add VERSION; \
	git commit -m "Version $$NEW_VERSION"; \
	git tag "v$$NEW_VERSION"; \
	echo "Successfully created version v$$NEW_VERSION"
