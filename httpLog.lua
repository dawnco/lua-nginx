local cjson = require "cjson"
local resty_md5 = require "resty.md5"
local str = require "resty.string"
local mysqlClient = require "mysqlClient"

-- ngx 变量
-- see https://github.com/openresty/lua-nginx-module#nginx-api-for-lua

local resp_body = ngx.arg[1]
ngx.ctx.buffered = (ngx.ctx.buffered or "") .. resp_body  


local function push_data(premature, logs)
        local client = mysqlClient:new()
         
        local id, err = client:insert("debug_http_logs", logs)

        local num, err = client:exec("DELETE FROM debug_http_logs WHERE host = ? AND created < ? ", { logs.host, ngx.today() })


end


-- arg[2] is true if this is the last chunk
if ngx.arg[2] then  


        local logs = {}
        logs["host"] = ngx.var.http_host
        logs["uri"] = ngx.var.uri
        logs["args"] = ngx.var.args
        logs["ip"] = ngx.header["X-Real-IP"]
        logs["header"] = ngx.req.raw_header()
        logs["method"] = ngx.req.get_method()
        logs["requestBody"] = ngx.req.get_body_data()
        logs["responseStatus"] = ngx.header.status
        logs["responseBody"] = ngx.ctx.buffered 

        -- 用定时器不阻塞当前操作
        local ok, err = ngx.timer.at(0, push_data, logs)

end

--[[

CREATE TABLE `debug_http_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `host` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `uri` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `args` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `method` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `header` text COLLATE utf8mb4_unicode_ci,
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `requestBody` longtext COLLATE utf8mb4_unicode_ci,
  `responseStatus` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `responseBody` longtext COLLATE utf8mb4_unicode_ci,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `host` (`host`)
) ENGINE=InnoDB AUTO_INCREMENT=481366 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='nginx 请求日志';

]]--  
