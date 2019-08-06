local cjson = require "cjson"
local resty_md5 = require "resty.md5"
local str = require "resty.string"
local mysqlClient = require "mysqlClient"


--local res, err = mysqlClient:getVar("select account from member WHERE 1 limit 2")
--if not res then
--    ngx.say(err)
--end

--ngx.say(cjson.encode(res))

local id, err = mysqlClient:insert("userlogs", { userId = 100000, account = "good" })
ngx.say("insert id ", id, " ", err)

local num, err = mysqlClient:update("userlogs", { userId = 100000, account = "go1od" }, { userId = 100000 })

ngx.say("update affect row ", num, " ", err)
