local 帮派 = require('帮派')




function 帮派:取成员(nid)
    return self.成员列表[nid]
end

function 帮派:取成员人数()
    local n = 0
    for k, v in self:遍历成员() do
        n = n + 1
    end
    return n
end

function 帮派:取成员列表(nid)
    local list = {}
    for k, v in self:遍历成员() do
        table.insert(list, { nid = v.nid, 名字 = v.名字, 职务 = v.职务, 状态 = v.状态 })
    end
    return list
end

function 帮派:取申请列表(nid)
    local list = {}
    for k, v in pairs(self.申请列表) do
        table.insert(list, v)
    end
    return list
end

function 帮派:取成员权限(nid)
    return self.成员列表[nid] and self.成员列表[nid].权限 or 0
end

function 帮派:取官职数量(职务)
    local n = 0
    for k, v in self:遍历成员() do
        if v.职务 == 职务 then
            n = n + 1
        end
    end
    return n
end

function 帮派:取现状信息()
    return {
        名称 = self.名称,
        创始人 = self.创始人,
        成员数量 = self.成员数量,
        战绩值 = self.战绩值,
        财产值 = self.财产值,
        建设度 = self.建设度,
        等级 = self.等级,
        名望值 = self.名望值,
        帮主 = self.帮主,
        宗旨 = self.宗旨,
        核心成员 = self:取核心成员() or {},
    }
end

local _核心职务 = {
    帮主 = true,
    副帮主 = true,
    左护法 = true,
    右护法 = true,
    长老 = true,
    堂主 = true,
    香主 = true,

}

function 帮派:是否满员()
    if self.成员数量 >= self.最大成员数量 then
        return true
    end
end

function 帮派:取核心成员()
    local list = {}
    for k, v in self:遍历成员() do
        if _核心职务[v.职务] then
            table.insert(list, v)
        end
    end
    return list
end

local _帮派消耗 = { --[1]建设度 [财产值 or 资金]
    { 50, 5000000 },
    { 100, 10000000 },
    { 150, 20000000 },
    { 200, 40000000 },
    { 250, 80000000 },

}

function 帮派:帮派维护() --每天
    local t = _帮派消耗[self.等级]
    local a, b = self:扣除财产值(t[2]), self:扣除建设度(t[1])
    local c = false --降级
    if not a or not b then
        if not a then
            self:扣除财产值(self.财产值)
        end
        if not b then
            self:扣除建设度(self.建设度)
        end
        c = true
    end
    if c then
      --  self:降级处理()
    end

    self:成员帮派贡献降低()
end

function 帮派:成员帮派贡献降低()
    for k, v in self:遍历成员() do
        self.成员列表[k].帮派贡献 = self.成员列表[k].帮派贡献 - 500000 --math.floor(v.帮派贡献 * 0.5)
        if self.成员列表[k].帮派贡献 < 0 then
            self.成员列表[k].帮派贡献 = 0
        end
    end
end

local _成员上限 = { 100, 150, 200, 250 }
local _升级消耗 = { 20000, 60000, 120000, 200000 }
function 帮派:升级条件检查(nid)
    if self.等级 >= 4 then
        return "当前已经达到最高等级"
    end
    if not self.成员列表[nid] then
        return "不是本帮成员不要来捣乱"
    end
    if self.成员列表[nid].职务 ~= "帮主" then
        return "只有帮主才可以进行此操作"
    end

    if self.建设度 > _升级消耗[self.等级] then
        return true
    end
    return "升级帮派需要" .. _升级消耗[self.等级] .. "建设度"
end

function 帮派:降级处理()
    if self.等级 == 1 then
        return
    end
    self.等级 = self.等级 - 1
    self.最大成员数量 = _成员上限[self.等级]
end

function 帮派:升级处理()
    if self.等级 >= 4 then
        return
    end
    self.建设度 = self.建设度 - _升级消耗[self.等级]
    self.等级 = self.等级 + 1
    self.最大成员数量 = _成员上限[self.等级]
end

function 帮派:扣除财产值(n)
    if self.财产值 < n then
        return
    end
    self.财产值 = self.财产值 - math.floor(n)
    if self.财产值 < 0 then
        self.财产值 = 0
    end
    return self.财产值
end

function 帮派:添加财产值(n)
    self.财产值 = self.财产值 + math.floor(n)
    return self.财产值
end

function 帮派:扣除建设度(n)
    if self.建设度 < n then
        return
    end
    self.建设度 = self.建设度 - math.floor(n)
    if self.建设度 < 0 then
        self.建设度 = 0
    end
    return self.建设度
end

function 帮派:添加建设度(n)
    self.建设度 = self.建设度 + math.floor(n)
    return self.建设度
end

function 帮派:取成员帮派贡献(nid)
    if self.成员列表[nid] then
        return self.成员列表[nid].帮派贡献 or 0
    end
    return 0
end

function 帮派:同步成员成就(nid, n)
    if self.成员列表[nid] then
        self.成员列表[nid].帮派成就 = n
        return self.成员列表[nid].帮派成就
    end
    return 0
end

function 帮派:取成员帮派成就(nid)
    if self.成员列表[nid] then
        return self.成员列表[nid].帮派成就 or 0
    end
    return 0
end
