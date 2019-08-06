local redis = require "resty.redis"
local config = require "config"

--see https://github.com/openresty/lua-resty-redis

RedisClient = {
    link = nil
}

function RedisClient:init()

    if not self.link then
        self.link = redis:new()
        self.link:set_timeout(1000) -- 1 sec
    end

    local ok, err = self.link:connect(config.redis.host, config.redis.port)
    if not ok then
        error(err)
        return
    end

end


function RedisClient:close()
    local ok, err = self.link:set_keepalive(config.redis.max_idle_timeout, config.redis.pool_size)
    return ok, err
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
