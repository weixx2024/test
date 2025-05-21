local function _get(s, name)
    local 脚本 = __脚本[s] or __脚本['task/默认.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

--可以访问的属性
local 接口 = {
    图标 = true,
}

--可以访问的方法
function 接口:删除()
    if self.是否可删除 ~= false then
        self:删除()
    end
end

--===============================================================================
if not package.loaded.任务接口_private then
    package.loaded.任务接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('任务接口_private')

local 任务接口 = class('任务接口')

function 任务接口:初始化(P)
    _pri[self] = P
end

function 任务接口:__index(k)
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

    r = P.数据[k]
    if r ~= nil then
        return r
    end
    return _get(P.脚本, k)
end

function 任务接口:__newindex(k, v)
    local P = _pri[self]
    P.数据[k] = v --FIXME check
    P.up = true
end

return 任务接口
