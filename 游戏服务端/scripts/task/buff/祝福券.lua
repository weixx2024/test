-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-03-29 16:03:43
local 任务 = {
    名称 = '祝福券',
    类型 = '其它',
    是否BUFF = true,
    是否可取消 = false,
    是否可追踪 = false
}

function 任务:任务初始化()

end

local _详情 = {
    '你的三倍时间还可持续#R%d#W分钟',
    '你的冻结了#R%d#W分钟三倍时间',
}

function 任务:任务取详情(玩家)
    if self.冻结 then
        return string.format(_详情[2], self.剩余时间 // 60)
    end
    return string.format(_详情[1], (self.时间 - os.time()) // 60)
end

function 任务:任务取消(玩家)

end

function 任务:任务更新(sec)
    if not self.时间 then
        self.时间 = os.time() + 3600
    end
    if self.时间 <= sec then
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if not self.冻结 and self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:增加时长(玩家, 时间)
    if self.冻结 then
        return false
    end
    if not self.时间 then
        self.时间 = os.time() + 3600
    end
    local 剩余时间 = self.时间 - os.time()
    local 总时间 = 时间 * 3600 + 剩余时间
    if 总时间 > 86400 then
        总时间 = 86400
    end
    self.时间 = os.time() + 总时间
    return self.时间
end

return 任务
