# certify

Let's Encrypt certificate management using Cloudflare DNS validation.

## Installation

Clone the repository:

```bash
git clone https://github.com/xzao/certify.git
cd certify
```

Copy `.env.sample` to `.env` and configure:

```bash
cp .env.sample .env
```

Required variables:
- `CERTIFY_EMAIL` - email for Let's Encrypt notifications
- `CERTIFY_CLOUDFLARE_API_TOKEN` - Cloudflare API token with DNS edit permissions
- `CERTIFY_DOMAINS` - comma-separated list of domains (supports wildcards)

Start the container:

```bash
make start
```

## Usage

#### Make Issue

Issue or expand certificates:

```bash
make certify
```

Explore the `Makefile` for additiona targets:

```bash
make logs
make list
make renew
make delete
make reset
...
```

## License

GPL-3.0
