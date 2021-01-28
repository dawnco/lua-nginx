## 安装 openresty
```
wget https://openresty.org/download/openresty-1.15.8.1.tar.gz
tar -zxvf openresty-1.15.8.1.tar.gz
cd openresty-1.15.8.1
./configure
make && make install
```

复制 lib/config.example.lua 到 lib/config.lua
修改 mysql 配置 
```
lib/config.lua
```

## openresty 配置, server 里加入
```
lua_package_path "/home/web/lua/lib/?.lua;;";
server{
    location / {
        root   /home/web/lua;
        more_set_headers 'Content-Type: text/html';
        content_by_lua_file /home/web/lua/$uri.lua;
        # 开发时关闭代码缓存
        lua_code_cache off; 
    }
}
```


## 测试

访问
http://localhost/demo/mysql

http://localhost/demo/redis

说明
要开启代码缓存 连接池才有用


# 记录请求的内容

```
lua_package_path "/home/web/lua/lib/?.lua;;";
server {
    server_name api.com;
    listen 8080 ;
    body_filter_by_lua_file /home/web/lua/httpLog.lua;
    root /www/loan-app-api/src/app/www;
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}


```
