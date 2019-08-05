local redis = require "resty.redis"
local config = require "config"

--see https://github.com/openresty/lua-resty-redis

RedisClient = {
    _inited = false,
    link = nil
}

function RedisClient:init()

    if self._inited then
        return
    end

    self.link = redis:new()
    self.link:set_timeout(1000) -- 1 sec
    local ok, err = self.link:connect(config.redis.host, config.redis.port)
    if not ok then
        error(err)
        return
    end

    self._inited = true
end

--function RedisClient.set(key, val)
--    RedisClient.init()
--    return RedisClient.link:set(key, val)
--end
----
--function RedisClient.setex(key, ttl, value)
--    RedisClient:init();
--    return RedisClient.link:setex(key, ttl, value)
--end

function RedisClient:close()
    local ok, err = self.link:set_keepalive(10000, 100)
    if not ok then
        error(err)
        return
    end
end

setmetatable(RedisClient, { __index = function(self, cmd)
    self:init()
    local method = function(self, ...)
        return self.link[cmd](self.link, ...)
    end
    self[cmd] = method
    return method
end })

return RedisClient
