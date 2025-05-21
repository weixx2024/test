local 装备孩子 = class('装备孩子')
local _属性范围 = require('数据库/孩子信息库').属性范围


function 装备孩子:检查孩子装备要求(P)
    if self.性别 ~= 0 and self.性别 ~= P.性别 then
        return '#R性别不符合要求'
    end

    return true
end

function 装备孩子:穿上孩子装备(P)
    local 装备属性 = P.装备属性

    for _, l in ipairs { "基本属性" } do
        if self[l] then
            for _, v in ipairs(self[l]) do
                local k = v[1]
                装备属性[k] = 装备属性[k] + v[2]
            end
        end
    end

    return true
end

function 装备孩子:脱下孩子装备(P)
    local 装备属性 = P.装备属性

    for _, l in ipairs { "基本属性" } do
        if self[l] then
            for _, v in ipairs(self[l]) do
                local k = v[1]
                装备属性[k] = 装备属性[k] - v[2]
            end
        end
    end

    return self
end

return 装备孩子
