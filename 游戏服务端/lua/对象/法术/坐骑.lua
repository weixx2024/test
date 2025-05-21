local _存档表 = { nid = '', 名称 = '', 熟练度 = 0, 熟练度上限 = 100000 }
local function _get(s, name)
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local 坐骑技能 = class('坐骑技能')

function 坐骑技能:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    if not rawget(self, 'nid') then
        self.nid = __生成ID()
    end
    self.脚本 = string.format("scripts/skill/坐骑/%s.lua", self.名称)

    self:刷新熟练度上限()
end

function 坐骑技能:取存档数据()
    local t = {}
    for k, v in pairs(_存档表) do
        if self[k] ~= v then
            t[k] = self[k]
        end
    end
    return t
end

function 坐骑技能:__index(k)
    local 脚本 = rawget(self, '脚本')
    if 脚本 then
        local r = _get(脚本, k)
        if r ~= nil then
            return r
        end
    end
    return _存档表[k]
end

function 坐骑技能:刷新熟练度上限(dt)

end

function 坐骑技能:转换(name)
    self.名称 = name
    self.脚本 = string.format("scripts/skill/坐骑/%s.lua", name)
end

function 坐骑技能:添加熟练度(n)
    self.熟练度 = self.熟练度 >= self.熟练度上限 and self.熟练度上限 or self.熟练度 + math.floor(n)
    if self.熟练度 > self.熟练度上限 then
        self.熟练度 = self.熟练度上限
    end
end

function 坐骑技能:取描述(坐骑)
    local func = _get(self.脚本, '取描述')
    if type(func) == 'function' then
        return ggexpcall(func, self, 坐骑.接口)
    end
end

function 坐骑技能:计算(坐骑, 召唤)
    local func = _get(self.脚本, '计算')
    if func then
        return ggexpcall(func, self, 坐骑.接口, 召唤)
    end
end

return 坐骑技能
