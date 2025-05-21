local _属性范围 = require('数据库/孩子信息库').属性范围
local _属性上限表 = require('数据库/孩子信息库').属性上限表

local _存档表 = require('数据库/存档属性_孩子')

local 孩子 = class('孩子')

gge.require('对象/孩子/算法')
gge.require('对象/孩子/通信')
function 孩子:孩子(t)
    self:加载存档(t)
    self.接口 = require('对象/孩子/接口')(self)
    self:装备_初始化()
    self:属性_初始化()
    if not self.nid then
        self.nid = __生成ID()
    end
    __孩子[self.nid] = self
    self.刷新的属性 = {}
end

function 孩子:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 孩子:__newindex(k, v)
    if _存档表[k] ~= nil then
        if self.刷新的属性 then
            self.刷新的属性[k] = v
        end

        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 孩子:属性_初始化()
    self:刷新属性()
end

function 孩子:更新()
    if next(self.刷新的属性) then
        if self.主人.当前查看孩子 == self then
            self.主人.rpc:请求刷新孩子(self.nid)
        end
        self.刷新的属性 = {}
    end
end

function 孩子:装备_初始化()
    for i, v in pairs(self.装备) do
        self.装备[i] = __物品[v]
    end
end

function 孩子:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid,
    }

    for _, k in pairs { '外形', '原名', '评价', '获得时间' } do
        r[k] = self[k]
    end
    r.数据 = {}
    for k, v in pairs(_存档表) do
        if type(v) ~= 'table' and self[k] ~= v then
            r.数据[k] = self[k]
        end
    end

    local 装备nids = {}
    for i, v in pairs(self.装备) do
        装备nids[v.部位] = v.nid
    end

    r.数据.装备 = 装备nids
    r.数据.物品 = self.物品
    r.数据.天资 = self.天资
    r.数据.其他属性 = self.其他属性
    return r
end

function 孩子:加载存档(t)
    if type(t.数据) == 'table' then --加载存档的表
        rawset(self, '数据', t.数据)
        t.数据 = nil
        for k, v in pairs(t) do
            self[k] = v
        end
        for k, v in pairs(_存档表) do
            if type(v) == 'table' and type(self[k]) ~= 'table' then
                self[k] = {}
            end
        end
        self.是否参战 = self.是否参战 == true
    else
        rawset(self, '数据', t)
        self.天资 = { "淘气", "天真", "好奇" }
        self.物品 = { 引导 = 0, 修炼 = 0 }
        self.装备 = {}
        if not self.性别 then
            self.性别 = math.random(2)
        end
    end
end

function 孩子:删除()
    if self.主人 then
        self.主人.孩子[self.nid] = nil
    end
end

function 孩子:孩子_取窗口属性()
    local r = {}
    for _, v in pairs {
        'nid',
        '名称',
        '外形',
        '阶段',
        '气质',
        '悟性',
        '智力',
        '耐力',
        '内力',
        '亲密',
        '孝心',
        '疲劳',
        '温饱',
        '评价',
        '天资',
        '是否参战',
    } do
        r[v] = self[v]
    end

    local list = {}
    for i, v in pairs(self.装备) do
        list[i] = v:取简要数据(self)
    end
    r.装备 = list

    if not self.战斗 then
        self.主人.当前查看孩子 = self
    end
    return r
end

function 孩子:取属性点上限(属性, 职业, 全属性)
    if _属性上限表[职业] == nil then
        return true
    end
    if _属性上限表[职业][属性] == nil then
        return true
    end

    if 全属性 then
        local 已经满 = 0
        for i = 1, 5 do
            if self[_属性范围[i]] >= _属性上限表[职业][_属性范围[i]] then
                已经满 = 已经满 + 1
            end
        end
        return 已经满
    end

    if self[属性] >= _属性上限表[职业][属性] then
        return true
    end
    return false
end

function 孩子:排除已有天资(列表)
    local 天资列表 = {}

    for i = 1, #列表 do
        local has = false

        for j = 1, #self.天资 do
            if 列表[i] == self.天资[j] then
                has = true
                break
            end
        end

        if not has then
            table.insert(天资列表, 列表[i])
        end
    end

    return 天资列表
end

return 孩子
