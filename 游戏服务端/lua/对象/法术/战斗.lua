local function _get(s, name)
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local 战斗技能 = class('战斗技能')
function 战斗技能:进入战斗(...)
    local func = _get(self.脚本, '进入战斗')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('进入战斗 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗技能:法术施放(...)
    local func = _get(self.脚本, '法术施放')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术施放 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗技能:法术施放后(...)
    local func = _get(self.脚本, '法术施放后')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术施放后 发生错误 ', self.id)
        end
    end
end

function 战斗技能:法术取消耗(...)
    local func = _get(self.脚本, '法术取消耗')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术取消耗 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗技能:法术取目标数(P)
    local func = _get(self.脚本, '法术取目标数')
    if type(func) == 'function' then
        local r = { ggexpcall(func, self, P) }
        if r[1] == gge.FALSE then
            warn('法术取目标数 发生错误 ', self.id)
        end
        return table.unpack(r)
    end
end

function 战斗技能:法术取目标数事件()
    local func = _get(self.脚本, '法术取目标数事件')
    if type(func) == 'function' then
        local r = { ggexpcall(func, self) }
        if r[1] == gge.FALSE then
            warn('法术取目标数事件 发生错误 ', self.id)
        end
        return table.unpack(r)
    end
end

function 战斗技能:法术取描述(...)
    local func = _get(self.脚本, '法术取描述')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术取描述 发生错误 ', self.id)
        end
        return r
    end
end

return 战斗技能
