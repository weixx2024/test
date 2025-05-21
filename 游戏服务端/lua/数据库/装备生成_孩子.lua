local ENV = setmetatable({}, { __index = _G })
local _属性范围 = require('数据库/孩子信息库').属性范围
local 装备库 = require('数据库/装备库_孩子')

local function 生成随机总和数组(n, sum)
    local ary = {}
    local tempSum = sum
    local startNum = 0

    for i = 1, n - 1 do
        local temp = math.ceil(math.random() * (tempSum / 2))
        table.insert(ary, temp)
        tempSum = tempSum - temp
        startNum = startNum + temp
    end

    table.insert(ary, sum - startNum)

    return ary
end

function 生成装备_孩子(名称)
    local t = 装备库[名称]
    if not t then
        return
    end

    local ary = 生成随机总和数组(5, t.属性总和)

    t.孩子是否可用 = true
    t.基本属性 = {}
    for key, value in pairs(_属性范围) do
        table.insert(t.基本属性, { value, ary[key] })
    end

    return t
end

return ENV
