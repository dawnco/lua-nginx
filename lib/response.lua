-- author daw
-- date 2019-08-07

local json = require "cjson"

local _M = {
    SUCCESS = 0,
    ERROR = 1,
}

function _M.success(data)
    _M.out(_M.SUCCESS, nil, data)
end

function _M.error(msg, data)
    _M.out(_M.ERROR, msg, data)
end

function _M.out(code, msg, data)
    ngx.say(json.encode({ code = code, msg = msg, data = data }))
end

return _M