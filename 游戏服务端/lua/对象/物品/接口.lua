
local function _get(s, name)
    local 脚本 = __脚本[s] or __脚本['item/默认.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end
--可以访问的属性
local 接口 = {
    数量 = true,
    nid = true,
    是否叠加 = true,
    是否装备 = true,
    是否孩子装备 = true,
}
--可以访问的方法
function 接口:删除()
    self:删除()
    --TODO 刷新物品
end
--===============================================================================
if not package.loaded.物品接口_private then
    package.loaded.物品接口_private = setmetatable({}, {__mode = 'k'})
end
local _pri = require('物品接口_private')

local 物品接口 = class('物品接口')

function 物品接口:初始化(P)
    _pri[self] = P
end

function 物品接口:__index(k)
    if k == 0x4253 then
        return _pri[self]
    end
    local r = 接口[k]
    local P = _pri[self]
    if r == true then
        return P[k]
    elseif r then
        return function(_, ...)
            return r(P, ...)
        end
    end
    r = _get(P.脚本, k)
    if r ~= nil then
        return r
    end
    return P.数据[k]
end

function 物品接口:__newindex(k, v)
    local P = _pri[self]
    P.数据[k] = v
    if k == '数量' then
        P:刷新()
    end
end
return 物品接口
