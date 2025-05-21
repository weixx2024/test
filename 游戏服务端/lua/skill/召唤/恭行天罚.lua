-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-07 18:25:22
-- @Last Modified time  : 2022-08-13 06:40:20
local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '恭行天罚',
    id = 0107,
}
-- 开山裂石 戟指怒目 气贯长虹 恭行天罚
local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local b = v:添加BUFF(BUFF)
        if b then
            b.回合 = self:法术取回合()
            b.效果 = self:法术取BUFF效果(攻击方, v)
        end
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
end

function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 效果 = {
        连击率 = 15,
        狂暴几率 = 15,
        致命几率 = 15,
        命中率 = 15,
    }

    for k, v in pairs(效果) do
        挨打方[k] = 挨打方[k] + v
    end
    return 效果
end

function 法术:法术取回合()
    return 3
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取描述()
    return '增加连击率15%，狂暴几率15%，致命几率15%，命中率15%，使用效果1人，持续效果3个回合。'
end

function 法术:法术取消耗()
    return { 消耗MP = 1280 }
end

BUFF = {
    法术 = '恭行天罚',
    名称 = '恭行天罚',
    id = 126
}
法术.BUFF = BUFF

function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        for k, v in pairs(self.效果) do
            单位[k] = 单位[k] - v
        end
    end
end

return 法术
