# 记录请求和响应记录写入mysql日志


```
lua_package_path "/home/web/lua/lib/?.lua;;";

server {
	listen       8080;
	server_name  localhost;

	# 开发时关闭代码缓存
	lua_code_cache off;
	
	
	body_filter_by_lua_file /home/web/lua/openresty/httpLogs.lua;

	location / {
		proxy_pass   https://domain:443;
		proxy_set_header Host  $host;
        proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Real-Port $remote_port;
		proxy_set_header REMOTE-HOST $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	}

}
	
```


sql

```
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


```