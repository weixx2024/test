local 角色 = require('角色')

function 角色:法宝_初始化()
    local 存档法宝 = self.法宝
    do
        local _法宝表 = {} --实际存放
        self.法宝 = --虚假的，用作监视删除，刷新
        setmetatable(
            {},
            {
                __newindex = function(t, i, v)
                    if v then
                        v.rid = self.id
                    else
                        local k = _法宝表[i].nid
                        __垃圾[k] = _法宝表[i]
                        __垃圾[k].rid = -1
                    end

                    _法宝表[i] = v
                end,
                __index = _法宝表,
                __pairs = function(...)
                    return next, _法宝表
                end
            }
        )
    end

    do
        local _法宝佩戴表 = {} --实际存放
        self.法宝佩戴 =
        setmetatable(
            {},
            {
                __newindex = function(t, i, v)
                    if v then
                        v.rid = self.id
                    end
                    _法宝佩戴表[i] = v
                end,
                __index = _法宝佩戴表,
                __pairs = function(...)
                    return next, _法宝佩戴表
                end
            }
        )
    end

    if type(存档法宝) == 'table' then
        for _, v in pairs(存档法宝) do
            if not __法宝[v.nid] or __法宝[v.nid].rid == v.rid then
                self.法宝[v.nid] = require('对象/法宝/法宝')(v)
                if v.佩戴 ~= 0 then
                    self.法宝佩戴[v.佩戴] = require('对象/法宝/法宝')(v)
                end
            end
        end
    end
end

function 角色:法宝_添加(T)
    if ggetype(T) == '法宝接口' then
        T = T[0x4253]
    end
    self.法宝[T.nid] = T

    return T
end

function 角色:遍历法宝()
    return pairs(self.法宝)
end

function 角色:遍历佩戴法宝()
    return pairs(self.法宝佩戴)
end

function 角色:角色_获取法宝佩戴列表()
    local list = {}
    for k, v in self:遍历佩戴法宝() do
        list[k] = v:取简要信息()
    end
    return list

end

function 角色:角色_获取法宝列表()
    local list = {}
    for k, v in self:遍历法宝() do
        table.insert(list, v:取简要信息())
    end
    return list
end

function 角色:角色_佩戴法宝(nid)
    local 格子 = 0
    for i = 1, 3, 1 do
        if not self.法宝佩戴[i] then
            格子 = i
            break
        end
    end
    if 格子 == 0 then
        return "#Y清确认炼妖炉中是否用空位"
    end
    local item = self.法宝[nid]
    if item then
        item.佩戴 = 格子
        self.法宝[nid] = self.法宝佩戴[格子]
        self.法宝佩戴[格子] = item
        self:刷新属性()

        return true
    end
end

function 角色:角色_脱下法宝(nid)
    local 找到
    for k, v in self:遍历佩戴法宝() do
        if v.nid == nid then
            找到 = k
            break
        end
    end
    if 找到 then
        self.法宝[nid] = self.法宝佩戴[找到]
        self.法宝[nid].佩戴 = 0
        self.法宝佩戴[找到] = nil
        self:刷新属性()
        return true
    end
end
function 角色:法宝_清空()
    for k, v in self:遍历法宝() do
        self.法宝[k]=nil
    end
end
function 角色:法宝_添加经验(n, 上限)
    local p
    if not 上限 or type(上限)~="number" then
        上限 = 200
    end
    local 佩戴数量 = 0
    local 上限数量 = 0
    for k, v in self:遍历佩戴法宝() do
        佩戴数量 = 佩戴数量 + 1
        if v.等级 >= 上限 then
            上限数量 = 上限数量 + 1
        end
    end
    if 佩戴数量 == 0 then
      --  self.rpc:常规提示("#Y你的炼丹炉内没有佩戴法宝！")
        return false
    end
    if 佩戴数量 == 上限数量 then
        self.rpc:常规提示("#Y你的炼丹炉内法宝均已经达到120级，请勿浪费哦！")
        return false
    end
    for k, v in self:遍历佩戴法宝() do
        if v.等级 < 上限 then
            local r = v:添加经验(n)
            if type(r) == "string" then
                p = true
                self.rpc:提示窗口("#Y".. r)
            end
        end
    end
    return p
end
