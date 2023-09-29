# Kong plugin jwt-claims

Parse a JWT token and send all claims as headers.

## Usage:
```yml
_format_version: "2.1"
services:
  - name: httpbin
    url: https://httpbin.org
    routes:
      - name: httpbin-route
        paths:
          - /*
        plugins:
          - name: jwt-claims
            config:
              authorization_header: Authorization
              jwt_token_header: x-jwt-token-decoded
              claim_header_prefix: x-jwt-claim-
              debug: false
```

## Install

Kong load the plugin with environment variable: `KONG_PLUGINS=bundled,jwt-claims` the plugin should be defined in the folder `/usr/local/share/lua/5.1/kong/plugins/jwt-claims`.

Install in a docker image with:

```dockerfile
FROM kong:3.4.0-ubuntu

ADD --chown=kong https://github.com/devmasx/kong-jwt-claims-plugin/releases/download/v0.1.0/handler.lua \
  https://github.com/devmasx/kong-jwt-claims-plugin/releases/download/v0.1.0/schema.lua \
  /usr/local/share/lua/5.1/kong/plugins/jwt-claims/

ENV KONG_PLUGINS=bundled,jwt-claims
```

Or copy the source code `./plugins/jwt-claims` to folder `/usr/local/share/lua/5.1/kong/plugins/jwt-claims`
## Example:

JWT with claims:
```
{
  "user-id": "1"
}
```

Send JWT token to Kong:
```
curl http://localhost:8000/headers \
-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyLWlkIjoiMSJ9.0DdUkLshZn-PsWKKoP6XwMMDZv1sV7xuayNjlQXnVpQ"
```

Jwt-claims plugin add the headers:

```
{
  "X-Jwt-Claim-User-Id": "1",
  "X-Jwt-Token-Decoded": "{\"user-id\":\"1\"}"
}
```

### Development

```
docker compose up --build
```
