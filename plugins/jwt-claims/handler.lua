local constants = require "kong.constants"
local jwt_decoder = require "kong.plugins.jwt.jwt_parser"
local kong_meta = require "kong.meta"
local cjson = require "cjson"

local fmt = string.format
local kong = kong
local type = type
local error = error
local ipairs = ipairs
local pairs = pairs
local tostring = tostring

local JWTClaims = {
  VERSION = kong_meta.version,
  PRIORITY = 1450,
}

local function exit_error(conf, error_type, err)
  local message = "UNAUTHORIZED"
  if error_type == "TOKEN_NOT_FOUND" then
    message = "Token not provided"
  elseif error_type == "BAD_TOKEN" then
    message = "Bad token; " .. tostring(err)
  elseif error_type == "INVALID_SIGNATURE" then
    message = "Invalid signature"
  end

  kong.response.exit(401, { status = 401, errors = { { code = "UNAUTHORIZED", message = message } } })
end

local function retrieve_token(conf)
  local jwt_token = nil
  local auth_name = conf.authorization_header
  local header_value = kong.request.get_header(auth_name)
  if not header_value then
    exit_error(conf, "TOKEN_NOT_FOUND")
    return nil
  end

  if conf.debug then
    kong.log("header_value", header_value)
  end

  for element in header_value:gmatch("%S+") do
      jwt_token = element
  end

  if jwt_token == nil or jwt_token == "" then
    exit_error(conf, "TOKEN_NOT_FOUND")
    return nil
  end

  if conf.debug then
    kong.log("Token ", jwt_token)
  end

  return jwt_token
end

local function handle_access(conf)
  local token = retrieve_token(conf)
  if token then
    local jwt, err = jwt_decoder:new(token)
    if err then
      exit_error(conf, "BAD_TOKEN", err)
      return nil
    end

    if conf.debug then
      kong.log("JWT decoded ", jwt)
    end

    if conf.jwt_token_header then
      kong.service.request.set_header(conf.jwt_token_header, cjson.encode(jwt.claims))
    end

    for key, value in pairs(jwt.claims) do
      if type(value) == "table" then
      else
        kong.service.request.set_header(conf.claim_header_prefix .. string.gsub(key, ":", "-"), value)
      end
    end
  end
end


function JWTClaims:access(conf)
  -- check if preflight request and whether it should be authenticated
  if not conf.run_on_preflight and kong.request.get_method() == "OPTIONS" then
    return
  end

  handle_access(conf)
end

return JWTClaims
