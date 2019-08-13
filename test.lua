local cjson = require "cjson"
local resty_md5 = require "resty.md5"
local str = require "resty.string"
local response = require "response"

response.success({ a = 1, ok = false })
ngx.say("<br>")
response.error('some error accord')
ngx.say("<br>")
response.out(3, nil, { b = "out" })
ngx.say("<br>")