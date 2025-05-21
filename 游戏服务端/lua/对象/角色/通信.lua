local 角色 = require('角色')

function 角色:通信_初始化()
    local SVR = require('通信/server')
    do
        local kname
        local function send(_, ...)
            if self.cid then
                return SVR[kname](SVR, self.cid, ...)
            end
        end
        self.rpc =
            setmetatable(
                {},
                {
                    __index = function(_, k)
                        kname = k
                        return send
                    end
                }
            )
    end

    do
        local kname
        local function send(_, ...)
            if self.cid then
                local fun = SVR[kname]
                if type(self.周围玩家) ~= 'table' or type(self.临时周围玩家) ~= 'table' then
                    return
                end
                for k, v in pairs(self.临时周围玩家) do
                    if self.周围玩家[k] and not self.周围玩家[k].是否掉线 then
                        fun(SVR, self.周围玩家[k].cid, ...)
                    end
                end
            end
        end
        self.rpn =
            setmetatable(
                {},
                {
                    __index = function(_, k)
                        kname = k
                        return send
                    end
                }
            )
    end

    do
        local kname
        local function send(_, ...)
            if self.cid and self.是否组队 and self.队伍 then
                local fun = SVR[kname]
                for _, v in pairs(self.队伍) do
                    if v ~= self then
                        fun(SVR, v.cid, ...)
                    end
                end
            end
        end
        self.rpt =
            setmetatable(
                {},
                {
                    __index = function(_, k)
                        kname = k
                        return send
                    end
                }
            )
    end
end
