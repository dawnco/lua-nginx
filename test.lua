local cjson = require "cjson"
local resty_md5 = require "resty.md5"
local str = require "resty.string"
local redis = require "redis"

 redis.set("daw", 3600, 'good');

 ngx.say(redis.get("daw"))