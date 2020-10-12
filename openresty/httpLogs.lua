local cjson = require "cjson"
local resty_md5 = require "resty.md5"
local str = require "resty.string"
local mysqlClient = require "mysqlClient"


local resp_body = ngx.arg[1]
ngx.ctx.buffered = (ngx.ctx.buffered or "") .. resp_body  


local function push_data(premature, logs)
	local client = mysqlClient:new()
	
	local id, err = client:insert("debug_http_logs", logs)
end


-- arg[2] is true if this is the last chunk
if ngx.arg[2] then  
	
	
	local logs = {}
	logs["host"] = ngx.var.http_host
	logs["uri"] = ngx.var.uri
	logs["args"] = ngx.var.args
	logs["ip"] = ngx.var.remote_addr
	logs["header"] = ngx.req.raw_header()
	logs["method"] = ngx.req.get_method()
	logs["requestBody"] = ngx.req.get_body_data()
	logs["responseStatus"] = ngx.header.status
	logs["responseBody"] = ngx.ctx.buffered 
	
	-- 用定时器不阻塞当前操作
	local ok, err = ngx.timer.at(0, push_data, logs)
	
end
