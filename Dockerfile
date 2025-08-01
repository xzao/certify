#
#   Dockerfile
#
FROM nginx


#
#   apt
#
RUN apt-get update && apt-get install --no-install-recommends --yes \
        python3-certbot python3-certbot-nginx python3-certbot-dns-cloudflare
