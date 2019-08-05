local redis = require "resty.redis"
local config = require "config"


RedisClient = {
    _inited = false
}

function RedisClient.init()

    if RedisClient._inited  then
        return
    end

    RedisClient.link = redis:new()
    RedisClient.link:set_timeout(1000) -- 1 sec
    local ok, err = RedisClient.link:connect(config.redis.host, config.redis.port)
    if not ok then
        error(err)
        return
    end
    RedisClient._inited = true
end

function RedisClient.get(key)
    RedisClient.init()
    return RedisClient.link:get(key)
end

function RedisClient.set(key, ttl, value)
    RedisClient.init()
    return RedisClient.link:setex(key, ttl, value)
end

function RedisClient.close()
    local ok, err = RedisClient.link:set_keepalive(10000, 100)
    if not ok then
        error(err)
        return
    end
end

return RedisClient
