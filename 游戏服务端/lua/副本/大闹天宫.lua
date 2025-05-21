local 大闹天宫 = class('大闹天宫')
local function _get(name)
    local 脚本 = __脚本['scripts/copy/大闹天宫.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
    return nil
end

function 大闹天宫:初始化(t)
    self.脚本 = 'scripts/copy/大闹天宫.lua'
end

function 大闹天宫:__index(k)
    local 脚本 = rawget(self, '脚本')
    if 脚本 then
        local r = _get(k)
        if r ~= nil then
            return r
        end
    end
end

function 大闹天宫:__newindex(k, v)
    rawset(self, k, v)
end

function 大闹天宫:更新(sec)

end

function 大闹天宫:测试刷怪()
    local func = _get('测试刷怪')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end
    end
end

function 大闹天宫:开启进场()
    local func = _get('开启进场')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end
    end
end

function 大闹天宫:能否进场()
    return self.进场开关
end

function 大闹天宫:开启活动()
    self.是否开始 = true
    self.花果山出兵定时 = __世界:定时(--按秒
        self.花果山.出兵速度,
        function(ms)
            if self.是否开始 then
                self:花果山出兵()
            end
            return ms
        end
    )
    self.天庭出兵定时 = __世界:定时(--按秒
        self.天庭.出兵速度,
        function(ms)
            if self.是否开始 then
                self:天庭出兵()
            end
            return ms
        end
    )
    local func = _get('开启活动')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self)
        if r == gge.FALSE then
            return '#R崩了#15'
        elseif type(r) == 'string' then
            return r
        end
    end
end

function 大闹天宫:花果山出兵(n)
    local func = _get('花果山出兵')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, n)
        if r == gge.FALSE then
            return '#R崩了#15'
        end
        return r
    end
end

function 大闹天宫:关闭活动(n)
    if self.天庭出兵定时 then
        self.天庭出兵定时:删除()
    end
    if self.花果山出兵定时 then
        self.花果山出兵定时:删除()
    end
    self.是否开始 = false
end

function 大闹天宫:天庭出兵(n)
    local func = _get('天庭出兵')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, n)
        if r == gge.FALSE then
            return '#R崩了#15'
        end
        return r
    end
end

function 大闹天宫:阵营分配(n)
    local func = _get('阵营分配')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, n)
        if r == gge.FALSE then
            return '#R崩了#15'
        end
        return r
    end
end

function 大闹天宫:扣除箭塔耐久(数值, 路, 阵营)
    local func = _get('扣除箭塔耐久')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, 数值, 路, 阵营)
        if r == gge.FALSE then
            return '#R崩了#15'
        end
        return r
    end
end

function 大闹天宫:取箭塔耐久(阵营, 路)
    local func = _get('取箭塔耐久')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, 阵营, 路)
        if r == gge.FALSE then
            return '#R崩了#15'
        end
        return r
    end
end

return 大闹天宫
