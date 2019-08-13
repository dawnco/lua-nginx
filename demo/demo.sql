CREATE TABLE `userlogs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userId` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `account` varchar(30) NOT NULL DEFAULT '' COMMENT '登录账户',
  `ip` varchar(25) NOT NULL DEFAULT '' COMMENT '登录IP',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '状态(1-成功,2-密码错误,3-授权码不正确,4-用户已被锁定,5-账号错误,6-登录失败)',
  `time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '登录时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户登录日志';

