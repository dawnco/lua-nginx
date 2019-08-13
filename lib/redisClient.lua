
-- author daw
-- date 2019-08-07

local redis = require "resty.redis"
local config = require "config"
local cjson = require "cjson"

--see https://github.com/openresty/lua-resty-redis

local _M = {
    link = nil
}

function _M:new()
    local o = {}

    setmetatable(o, { __index = self })

    local ok, err = o:init()

    if not ok then
        return false, err
    end

    return o, err
end

function _M:init()

    self.link = redis:new()
    self.link:set_timeout(1000) -- 1 sec

    local ok, err = self.link:connect(config.redis.host, config.redis.port)

    return ok, err

end

function _M:close()
    local ok, err = self.link:set_keepalive(config.redis.max_idle_timeout, config.redis.pool_size)
    return ok, err
end

function _M:reuseTime()
    local times, err = self.link:get_reused_times()
    return times, err
end

setmetatable(_M, { __index = function(self, cmd)
    local method = function(self, ...)
        return self.link[cmd](self.link, ...)
    end
    self[cmd] = method
    return method
end })

return _M
