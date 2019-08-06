-- redis demo
local redisClient = require "redisClient"

redisClient:set("k1", "v1")
ngx.say(redisClient:get('k1'))

redisClient:rpush("listk1", 50)
redisClient:rpush("listk1", 51)
ngx.say(redisClient:lpop('listk1'))

redisClient:expire("listk1", 600)
redisClient:expire("k1", 600)
