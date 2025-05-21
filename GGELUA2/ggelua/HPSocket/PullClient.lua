-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-03-07 18:52:00
-- @Last Modified time  : 2022-11-12 05:18:25

local HPS = require('HPSocket.HPSocket')
local BaseClient = require('HPSocket.BaseClient')
local PullClient = class('PullClient', BaseClient)
PullClient._hp = false
PullClient._接收事件 = false
PullClient._准备事件 = false
PullClient._连接事件 = false
PullClient._发送事件 = false
PullClient._断开事件 = false
PullClient.接收事件 = false
PullClient.准备事件 = false
PullClient.连接事件 = false
PullClient.发送事件 = false
PullClient.断开事件 = false

function PullClient:PullClient()
    self._hp = require 'ghpsocket.pullclient' (self)
end

--准备连接通知
function PullClient:OnPrepareConnect(dwConnID, socket)
    if self._准备事件 then
        ggexpcall(self._准备事件, self, socket)
    elseif self.准备事件 then
        ggexpcall(self.准备事件, self, socket)
    end
    return 0
end

function PullClient:OnConnect(dwConnID)
    if self._连接事件 then
        ggexpcall(self._连接事件, self)
    elseif self.连接事件 then
        ggexpcall(self.连接事件, self)
    end
    return 0
end

--已发送数据通知
function PullClient:OnSend(dwConnID, iLength)
    if self._发送事件 then
        ggexpcall(self._发送事件, self, iLength)
    elseif self.发送事件 then
        ggexpcall(self.发送事件, self, iLength)
    end
    return 1
end

function PullClient:OnReceive(dwConnID, iLength)
    if self._接收事件 then
        ggexpcall(self._接收事件, self, iLength)
    elseif self.接收事件 then
        ggexpcall(self.接收事件, self, iLength)
    end
    return 0
end

function PullClient:OnClose(dwConnID, enOperation, iErrorCode)
    if self._断开事件 then
        return ggexpcall(self._断开事件, self, HPS[enOperation], iErrorCode)
    elseif self.断开事件 then
        return ggexpcall(self.断开事件, self, HPS[enOperation], iErrorCode)
    end
    return 0
end

--====================================================================================
--ITcpPullClient
--====================================================================================
function PullClient:取数据(ptr, len, p)
    if p then
        return self._hp:Peek(ptr, len) == 0
    end
    return self._hp:Fetch(ptr, len) == 0
end

return PullClient
