--see https://github.com/openresty/lua-resty-mysql
local cjson = require "cjson"
local mysql = require "resty.mysql"
local config = require "config"

_M = {
    link = nil,
}

function _M:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o:init()

    return o
end

function _M:init()

    if not self.link then
        local db, err = mysql:new()
        if not db then
            return false, err
        end
        self._inited = true
        db:set_timeout(1000) -- 1 sec
        self.link = db
    end

    local ok, err, errcode, sqlstate = self.link:connect {
        host = config.mysql.host,
        port = config.mysql.port,
        database = config.mysql.database,
        user = config.mysql.user,
        password = config.mysql.password,
        charset = config.mysql.charset,
        max_packet_size = 1024 * 1024,
    }
    if not ok then
        return false, err
    end

    return true
end

function _M:getData(sql)
    --local ok, err = self:init()
    --if not ok then
    --    return false, err
    --end

    local res, err, errcode, sqlstate = self.link:query(sql)
    if not res then
        return false, err
    end
    return res
end

function _M:getLine(sql)

    local res, err = self:getData(sql)

    local res, err, errcode, sqlstate = self.link:query(sql)
    if not res then
        return false, err
    end
    local len = table.getn(res)
    if len >= 1 then
        return res[1]
    end
    return false
end

function _M:getVar(sql)
    local res, err = self:getLine(sql)
    if not res then
        return false, err
    end

    local val = false
    for key, value in pairs(res) do
        val = value
    end
    return val
end

function _M:insert(tableName, data)

    --local ok, err = self:init()
    --if not ok then
    --    return false, err
    --end

    local field = {}
    local value = {}

    for key, val in pairs(data) do
        table.insert(field, key)
        table.insert(value, ngx.quote_sql_str(val))
    end

    local sql = string.format("INSERT INTO `%s` (%s) VALUE (%s)", tableName, table.concat(field, ','), table.concat(value, ','))

    local res, err, errcode, sqlstate = self.link:query(sql)

    if not res then
        return false, err
    end

    return res.insert_id

end

function _M:update(tableName, data, where)

    --local ok, err = self:init()
    --if not ok then
    --    return false, err
    --end

    local field = {}
    local whereSql = {}

    for key, val in pairs(data) do
        table.insert(field, string.format("`%s` = %s", key, ngx.quote_sql_str(val)))
    end

    for key, val in pairs(where) do
        table.insert(whereSql, string.format("`%s` = %s", key, ngx.quote_sql_str(val)))
    end

    local sql = string.format("UPDATE `%s` SET %s WHERE %s", tableName, table.concat(field, ','), table.concat(whereSql, ' AND '))

    local res, err, errcode, sqlstate = self.link:query(sql)

    if not res then
        return false, err
    end

    return res.affected_rows

end

function _M:delete(tableName, where)
    --
    --local ok, err = self:init()
    --if not ok then
    --    return false, err
    --end

    local whereSql = {}

    for key, val in pairs(where) do
        table.insert(whereSql, string.format("`%s` = %s", key, ngx.quote_sql_str(val)))
    end

    local sql = string.format("DELETE FROM `%s` WHERE %s", tableName, table.concat(whereSql, ' AND '))

    local res, err, errcode, sqlstate = self.link:query(sql)

    if not res then
        return false, err
    end

    return res.affected_rows
end

function _M:exec(sql, bind)

    --local ok, err = self:init()
    --if not ok then
    --    return false, err
    --end

    sql = self:prepare(sql, bind)

    local res, err, errcode, sqlstate = self.link:query(sql)

    if not res then
        return false, err
    end

    return res.affected_rows
end

function _M:close()
    local ok, err = self.link:set_keepalive(config.mysql.max_idle_timeout, config.mysql.pool_size)

    return ok, err
end

function _M:prepare (sql, bind)

    if bind == nil then
        return sql
    end

    local prepare = {}
    for key, val in pairs(bind) do
        table.insert(prepare, ngx.quote_sql_str(val))
    end
    return string.format(string.gsub(sql, "?", "%%s"), unpack(prepare))
end

function _M:reuseTime()
    local times, err = self.link:get_reused_times()
    return times, err
end

return _M

