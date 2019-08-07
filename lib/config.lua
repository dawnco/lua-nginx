return {
    redis = {
        host = "127.0.0.1",
        port = '6379',
        pool_size = 10,
        max_idle_timeout = 60000, -- ms
    },
    mysql = {
        host = "192.168.0.11",
        port = '3306',
        database = "redpacket",
        user = "root",
        password = "Q,Fflgfye6w.",
        charset = 'utf8mb4',
        pool_size = 10,
        max_idle_timeout = 60000, -- ms
    }
}