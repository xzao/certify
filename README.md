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

Set required environmentals in `.env`:

```env
CERTIFY_CLOUDFLARE_API_TOKEN=ez******************
CERTIFY_DOMAINS=example.com,*.example.com
CERTIFY_EMAIL=first.last@example.com
...
```

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
