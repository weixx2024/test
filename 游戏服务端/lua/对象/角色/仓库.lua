
local 角色 = require('角色')
function 角色:角色_仓库页数()
    -- if gge.isdebug then
    --     return 3
    -- end
    return self.其它.仓库数量==0 and 1 or self.其它.仓库数量
end

function 角色:仓库_遍历物品(p)
    local a, b
    if type(p) == 'number' then
        a = (p - 1) * 24
        b = a + 24
    else
        a, b = 0, self:角色_仓库页数() * 24
    end
    return function()
        a = a + 1
        while a <= b do
            if self.仓库[a] then
                return a, self.仓库[a]
            end
            a = a + 1
        end
    end
end

function 角色:仓库_遍历空位(p)
    local a, b
    if type(p) == 'number' then
        a = (p - 1) * 24
        b = a + 24
    else
        a, b = 0, self:角色_仓库页数() * 24
    end
    return function()
        a = a + 1
        while a <= b do
            if not self.仓库[a] then
                return a
            end
            a = a + 1
        end
    end
end

function 角色:仓库_查找位置2(item, p)
    for i, v in self:仓库_遍历物品(p) do
        if v:检查合并2(item) then
            return i, v
        end
    end
    return self:仓库_遍历空位(p)()
end

function 角色:角色_仓库列表(p, sum)
    if type(p) == 'number' then
        local r = {}
        for i, v in self:仓库_遍历物品(p) do
            i = i % 24
            if i == 0 then
                i = 24
            end
            r[i] = v:取简要数据(self)
        end
        return r
    end
    return {}
end

function 角色:角色_仓库存入(a, b)
    if self.是否战斗 or self.是否摆摊 or self.是否交易 then
        return
    end

    if type(a) == 'number' and type(b) == 'number' and self.物品[a] then
        local item = self.物品[a]
        if b & 0xFF00 ~= 0 then --右键
            local p = b >> 8
            local 堆叠
            repeat
                local k, v = self:仓库_查找位置2(item, p)
                if v then
                    if not v:合并(item) then --先判断 是否可以全部合并(<=99)
                        v:合并2(item)
                    end

                    if not 堆叠 then
                        堆叠 = string.format('#Y您放入的#G%s#Y已与同类物品自动堆叠', item.名称)
                    end
                elseif k then --空位
                    self.物品[a] = nil
                    self.仓库[k] = item
                end

                if not k then
                    return 堆叠 or '#Y没有位置放了'
                end
            until not self.物品[a]

            return true, 堆叠
        elseif not self.仓库[b] then --左键指定空位
            self.物品[a] = nil
            self.仓库[b] = item
            return true
        else
            --不是相同物品无法进行堆叠
        end
    end
end

function 角色:角色_仓库取出(a, b)
    if self.是否战斗 or self.是否摆摊 or self.是否交易 then
        return
    end
    if type(a) == 'number' and type(b) == 'number' and self.仓库[a] then
        local item = self.仓库[a]
        if b & 0xFF00 ~= 0 then --右键
            local p = b >> 8
            local 堆叠
            repeat
                local k, v = self:物品_查找位置2(item, p)
                if v then
                    if not v:合并(item) then --先判断 是否可以全部合并(<=99)
                        v:合并2(item)
                    end

                    if not 堆叠 then
                        堆叠 = string.format('#Y您取出的#G%s#Y已与同类物品自动堆叠', item.名称)
                    end
                elseif k then --空位
                    self.仓库[a] = nil
                    self.物品[k] = item
                end

                if not k then
                    return 堆叠 or '#Y没有位置放了'
                end
            until not self.仓库[a]

            return true, 堆叠
        elseif not self.物品[b] then --左键指定空位
            self.仓库[a] = nil
            self.物品[b] = item
            return true
        else
            --不是相同物品无法进行堆叠
        end
    end
end

function 角色:角色_仓库整理(p)
    if self.是否战斗 or self.是否摆摊 or self.是否交易 then
        return
    end
    local list = {}
    for i, v in self:仓库_遍历物品(p) do
        self.仓库[i] = nil
        table.insert(list, v)
    end
    table.sort(list, function(a, b)
        return (a.id or 0) < (b.id or 0)
    end)
    local ii = (p - 1) * 24
    for i, v in ipairs(list) do
        self.仓库[i+ii] = v
    end
    return true
end
