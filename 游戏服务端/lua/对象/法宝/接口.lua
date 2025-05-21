local 接口 = {

    nid = true,
    rid = true,
    名称 = true,
    等级 = true,
    道行 = true,
    升级道行 = true,
    灵气 = true,
    最大灵气 = true,
    阴阳 = true,








}




--===============================================================================
if not package.loaded.法宝接口 then
    package.loaded.法宝接口_private = setmetatable({}, { __mode = 'k' })
end

local _pri = require('法宝接口_private')

local 法宝接口 = class('法宝接口')

function 法宝接口:初始化(P)
    _pri[self] = P
end

function 法宝接口:__index(k)
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
end

return 法宝接口
