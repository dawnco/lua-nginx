local cjson = require "cjson"
local resty_md5 = require "resty.md5"
local str = require "resty.string"
local mysqlClient = require "mysqlClient"


local ok, errors = pcall(mysqlClient:getVar("select *1"))
if not ok then
    ngx.say(errors)
end

ngx.say(errors)