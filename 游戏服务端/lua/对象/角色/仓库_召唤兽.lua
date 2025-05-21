local 角色 = require('角色')

function 角色:角色_召唤仓库上限()
    -- if gge.isdebug then
    --     return 20
    -- end
    return 10
end

function 角色:仓库_遍历召唤仓库()
    return pairs(self.召唤仓库)
end

function 角色:取召唤仓库数量()
    local n = 0
    for k, v in self:仓库_遍历召唤仓库() do
        n = n + 1
    end
    return n
end

function 角色:角色_召唤仓库消耗(nid)
    if self.召唤[nid] then
        local sum = self.召唤[nid]
        local 消耗银子 = sum.等级 * 10000
        return 消耗银子
    end
    return 0
end

function 角色:角色_召唤仓库存入(nid, 交换)
    if self.是否战斗 or self.是否摆摊 or self.是否交易 then
        return
    end
    if not 交换 then
        if self:取召唤仓库数量() >= self:角色_召唤仓库上限() then
            self.rpc:常规提示("#Y仓库已经放不下更多的召唤兽了！")
            return
        end
    end
    if self.召唤[nid] then
        local sum = self.召唤[nid]
        if sum.是否参战 or sum.是否观看 or sum.被管制 then
            self.rpc:常规提示("#Y请先取消该召唤兽的#R参战#Y、#R管制#Y、#R观看#Y状态")
            return
        end
        local 消耗 = self:角色_召唤仓库消耗(nid)
        if self:角色_扣除银子(消耗) then
            self.召唤[nid] = nil
            self.召唤仓库[nid] = sum
            return true
        end
    end
end

function 角色:角色_召唤仓库取出(nid)
    if self.是否战斗 or self.是否摆摊 or self.是否交易 then
        return
    end
    if self.召唤仓库[nid] then
        local sum = self.召唤仓库[nid]
        sum.存放 = false
        self.召唤仓库[nid] = nil
        self.召唤[nid] = sum
        return true
    end
end

function 角色:角色_召唤仓库交换(nid, nid2) --先存nid 再取nid2
    if self:角色_召唤仓库存入(nid, true) then
        self:角色_召唤仓库取出(nid2)
        return true
    end
end

function 角色:角色_召唤仓库列表()
    local list = {}
    for _, v in self:仓库_遍历召唤仓库() do
        table.insert(list, v:取仓库数据())
    end
    local list2 = {}
    for k, v in self:遍历召唤() do
        table.insert(list2, v:取仓库数据())
    end
    return list, list2, self.银子
end
