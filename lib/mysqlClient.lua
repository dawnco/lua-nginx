--see https://github.com/openresty/lua-resty-mysql

local mysql = require "resty.mysql"
local config = require "config"

_M = {
    _inited = false,
    link = nil
}

function _M:init()

    if self._inited then
        return
    end

    local db, err = mysql:new()
    if not db then
        error(err)
        return
    end

    db:set_timeout(1000) -- 1 sec

    local ok, err, errcode, sqlstate = db:connect {
        host = config.mysql.host,
        port = config.mysql.port,
        database = config.mysql.database,
        user = config.mysql.user,
        password = config.mysql.password,
        charset = config.mysql.charset,
        max_packet_size = 1024 * 1024,
    }

    if not ok then
        error("failed to connect: " .. err .. ": " .. errcode .. " " .. sqlstate)
        return
    end

    self.link = db

    self._inited = true
end

function _M:getVar(sql)
    self:init()
    local res, err, errcode, sqlstate =
    self.link:query(sql)
    if not res then
        error("query error: " .. err .. ": " .. errcode .. " " .. sqlstate)
        return
    end

end

return _M

