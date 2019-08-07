-- redis demo
local redisClient = require "redisClient"
local util = require "util"


local client, err = redisClient:new()

client:set("k1", "v1")
util.say(client:get('k1'))

client:rpush("listk1", 50)
client:rpush("listk1", 51)
util.say(client:lpop('listk1'))

client:expire("listk1", 600)
client:expire("k1", 600)

util.say("reuse times", client:reuseTime())

client:close()