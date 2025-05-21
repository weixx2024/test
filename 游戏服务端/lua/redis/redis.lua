local hiredis = require 'hiredis'

local MyRedis = class('MyRedis')

local _mpack = require('cmsgpack').pack
local _munpack = require('cmsgpack.safe').unpack

function MyRedis:初始化()
    self.conn = assert(hiredis.connect(__config.redisIp, __config.redisPort))
    assert(self.conn:command("PING") == hiredis.status.PONG)
    assert(self.conn:command("SELECT", __config.redisDB))
end

function MyRedis:读档角色(nid)
    local key = 'USER:' .. nid
    return _munpack(assert(self.conn:command("GET", key)))
end

function MyRedis:存档角色(nid, data)
    local key = 'USER:' .. nid
    assert(self.conn:command("SET", key, _mpack(data)))
end

function MyRedis:获取数据(key)
    return _munpack(assert(self.conn:command("GET", key))) or {}
end

function MyRedis:存档数据(key, data)
    assert(self.conn:command("SET", key, _mpack(data)))
end

MyRedis:初始化()
return MyRedis
