local _存档表 = require('数据库/存档属性_内丹')
local function _get(s, name)
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local 战斗技能 = require('对象/法术/战斗')
local 内丹 = class('内丹', 战斗技能)


function 内丹:初始化(t)
    --self.数据 = t
    for k, v in pairs(t) do
        self[k] = v
    end
    assert(rawget(self, '技能'), '内丹错误')

    if not rawget(self, 'nid') then
        self.nid = __生成ID()
    end
    --__内丹[self.nid] = self
    self.脚本 = string.format("scripts/skill/内丹/%s.lua", self.技能)

    self:刷新最大经验()
    self:刷新等级上限()
    self:刷新最大元气()
end

function 内丹:取存档数据()
    local t = {}
    for k, v in pairs(_存档表) do
        if self[k] ~= v then
            t[k] = self[k]
        end
    end
    return t
end

-- function 内丹:加载存档(t)

-- end

function 内丹:__index(k)
    local 脚本 = rawget(self, '脚本')
    if 脚本 then
        local r = _get(脚本, k)
        if r ~= nil then
            return r
        end
    end
    return _存档表[k]
end

function 内丹:刷新最大经验()
    self.最大经验 = require('数据库/经验库').内丹经验库[self.等级]
end

local _等级上限 = { 100, 120, 140, 170, 200 }
function 内丹:刷新等级上限()
    self.等级上限 = _等级上限[self.转生 + 1]
end

function 内丹:刷新最大元气()
    self.最大元气 = 6000 + self.等级 * 25
end

function 内丹:增减元气(n)
    self.元气 = self.元气 + math.floor(n)
    if self.元气 > self.最大元气 then
        self.元气 = self.最大元气
    end
    if self.元气 < 0 then
        self.元气 = 0
    end
end

function 内丹:转生处理()
    if self.转生 >= 3 then
        return
    end
    self.转生 = self.转生 + 1
    self.等级 = 1
    self:刷新最大元气()
    self:刷新最大经验()
    self:刷新等级上限()
    return true
end

function 内丹:取经验能否添加(召唤)
    if self.转生 > 召唤.转生 then
        print('内丹转生等级不足')
        return
    end
    if self.转生 == 召唤.转生 and self.等级 >= 召唤.等级 then
        print('内丹转生等级不足1')
        return
    end
    if self.等级 >= self.等级上限 then
        print('内丹转生等级不足2')
        return
    end

    return true
end

function 内丹:添加经验(n, 召唤)
    if self.转生 > 召唤.转生 + 召唤.召唤兽飞升 then
        return
    end
    if self.转生 == 召唤.转生 + 召唤.召唤兽飞升 and self.等级 >= 召唤.等级 then
        return
    end
    if self.等级 >= self.等级上限 then
        return
    end
    self.经验 = self.经验 + math.floor(n)
    while self.经验 >= self.最大经验 and self.等级 < self.等级上限 do
        self.经验 = self.经验 - self.最大经验
        self.等级 = self.等级 + 1
        self:刷新最大元气()
        self:刷新最大经验()
        if self.等级 == self.等级上限 and self.经验 > self.最大经验 then
            self.经验 = self.最大经验
        end
    end
    return true
end

function 内丹:吐出(召唤)
    local r = require('对象/物品/物品') {
        技能 = self.技能,
        等级 = self.等级 > 3 and self.等级 - 3 or 1,
        经验 = self.经验,
        元气 = self.元气,
        转生 = self.转生,
        点化 = self.点化,
        名称 = "召唤兽内丹",
        最大元气 = self.最大元气
    }
    召唤:刷新属性()
    --self:属性减(召唤)
    return r
end

function 内丹:取描述(召唤)
    local func = _get(self.脚本, '法术取描述')
    if type(func) == 'function' then
        return ggexpcall(func, self, 召唤.接口)
    end
end

function 内丹:计算(召唤)
    local func = _get(self.脚本, '计算')
    if func then
        return ggexpcall(func, self, 召唤)
    end
end

-- function 内丹:属性加(召唤)
--     local t = self:计算(召唤)
--     if type(t) == 'table' then
--         for a, b in pairs(t) do
--             if not 召唤.其它属性.抗性[a] then
--                 召唤.其它属性.抗性[a] = 0
--             end
--             召唤.其它属性.抗性[a] = 召唤.其它属性.抗性[a] + b
--         end
--     end
-- end

-- function 内丹:属性减(召唤)
--     local t = self:计算(召唤)
--     if type(t) == 'table' then
--         for a, b in pairs(t) do
--             if not 召唤.其它属性.抗性[a] then
--                 召唤.其它属性.抗性[a] = 0
--             end
--             召唤.其它属性.抗性[a] = 召唤.其它属性.抗性[a] - b
--         end
--     end
-- end

-- function 内丹:重新计算属性(召唤)
--     self:属性减(召唤)
--     self:属性加(召唤)
-- end

return 内丹
