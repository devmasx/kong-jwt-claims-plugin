local typedefs = require "kong.db.schema.typedefs"

return {
  name = "jwt-claims",
  fields = {
    { consumer = typedefs.no_consumer },
    { config = {
        type = "record",
        fields = {
          { jwt_token_header = { description = "header with jwt decoded", type = "string" }, },
          { claim_header_prefix = { description = "header prefix name for each claim", type = "string", default = "x-jwt-claim-" }, },
          { authorization_header = { description = "header to fetch JWT token", type = "string", default = "Authorization" }, },
          { debug = { description = "print debug logs", type = "boolean", default = false }, },
    }, }, },
  },
}
