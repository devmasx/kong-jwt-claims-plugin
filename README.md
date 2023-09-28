
Kong plugin:

Example:

jwt with:
```
{
  "user-id": "1"
}
```

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

