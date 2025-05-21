local _属性上限表 = require('数据库/孩子信息库').属性上限表
local _属性范围 = require('数据库/孩子信息库').属性范围

local 孩子 = require('孩子')

function 孩子:刷新评价()
    if self.职业 == '' or self.阶段 < 2 then
        self.评价 = 0
        return
    end

    local 属性上限表 = _属性上限表[self.职业]
    local 评价 = 0
    local 倍数 = 0.788
    for k, v in pairs(属性上限表) do
        评价 = 评价 + self[k] * (self[k] ^ 0.2)
    end

    评价 = math.floor(评价 + (self.亲密 + self.孝心) * 倍数)

    if 评价 > 4360 then
        评价 = 4360
    end
    self.评价 = 评价
end

function 孩子:刷新属性()
    if type(self.其他属性) == 'table' then
        for k, v in pairs(self.其他属性) do
            self[k] = self[k] - v
        end
    end

    self.装备属性 = __容错表 {}

    for _, v in pairs(self.装备) do
        v:穿上孩子装备(self)
    end

    self.其他属性 = __复制表(self.装备属性)

    for k, v in pairs(self.装备属性) do
        self[k] = self[k] + v
    end

    self:刷新评价()
end
