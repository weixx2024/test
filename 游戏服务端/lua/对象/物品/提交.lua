local function _get(s, name)
    local 脚本 = __脚本[s] or __脚本['item/默认.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

--===============================================================================
if not package.loaded.物品提交_private then
    package.loaded.物品提交_private = setmetatable({}, {__mode = 'k'})
end
local _pri = require('物品提交_private')

local 物品提交 = class('物品提交')

function 物品提交:初始化(P, n)
    _pri[self] = P
    self.数量 = n
end

function 物品提交:__index(k)
    local P = _pri[self]

    local r = _get(P.脚本, k)
    if r ~= nil then
        return r
    end
    return P.数据[k]
end

function 物品提交:取回收价格(T)
    local P = _pri[self]
    if P then
        return P:取回收价格(T)
    end
end

function 物品提交:接受(n)
    local P = _pri[self]
    if type(n) == 'number' and n < self.数量 then
        P:减少(n)
    else
        P:减少(self.数量) --这会自己删除
    end
end
return 物品提交
