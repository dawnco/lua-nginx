local cjson = require "cjson"
local resty_md5 = require "resty.md5"
local str = require "resty.string"
local mysqlClient = require "mysqlClient"
local util = require "util"

local res, err = mysqlClient:getVar("select account from member WHERE 1 limit 2")
util.say("get var ", res, " ", err)

local res, err = mysqlClient:getData("select account from member WHERE 1 limit 2")
util.say("get data ", cjson.encode(res), " ", err)

local res, err = mysqlClient:getLine("select account from member WHERE 1 limit 2")
util.say("get line ", cjson.encode(res), " ", err)


--util.say(cjson.encode(res))

local id, err = mysqlClient:insert("userlogs", { userId = 100000, account = "good" })
util.say("insert id ", id, " ", err)

local num, err = mysqlClient:update("userlogs", { userId = 100000, account = "go1od" }, { userId = 100000 })
util.say("update affect row ", num, " ", err)

local num, err = mysqlClient:delete("userlogs", { userId = 100000 })
util.say("delete affect row ", num, " ", err)

local num, err = mysqlClient:exec("DELETE FROM userlogs WHERE id < ?", { 20 })
util.say("exec affect row ", num, " ", err)

local sql, err = mysqlClient:prepare("SELECT * FROM userlogs WHERE id = ? AND id > ?", { 2, 0 })
util.say("prepare", sql, err)
