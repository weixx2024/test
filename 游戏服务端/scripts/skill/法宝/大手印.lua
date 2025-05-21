local 法术 = {
    类别 = '法宝',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    程府 = true,
    名称 = '大手印',
    id = 1507
}


function 法术:法术施放(攻击方, 目标)
    local 消耗怨气 = self:法术取消耗().消耗怨气
    if 攻击方:取怨气() < 消耗怨气 then
        攻击方:提示("#R怨气不足，无法释放！")
        return false
    end --15.5+qz(技能组[n].等级*3)*0.1
    self.xh = 消耗怨气
    local jl = 15.5 + math.floor(self.等级 * 3) * 0.01
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        if math.random(100) <= jl then
            v:删除BUFF('封印')
        end
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少怨气(self.xh)
        self.xh = false
    end
end

function 法术:法术取消耗()
    return { 消耗怨气 = self.等级 + 150 }
end

function 法术:取目标数()
    return 2
end

function 法术:法术取回合()
    return 1
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    local jl = 15.5 + math.floor(self.等级 * 3) * 0.01
    return string.format("%s%%解除封印异常状态", jl)
end

return 法术
