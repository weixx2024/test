local 法术 = {
    类别 = '法宝',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '白骨爪',
    id = 1514
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗怨气 = self:法术取消耗().消耗怨气
    if 攻击方:取怨气() < 消耗怨气 then
        攻击方:提示("#R怨气不足，无法释放！")
        return false
    end
    self.xh = 消耗怨气
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local 成功 = true
        if 成功 then
            local b = v:添加BUFF(BUFF)
            if b then
                b.等级 = self.等级
                b.回合 = self:法术取回合()
            end
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

local _等级 = { 0, 20, 60, 80, 112, 156, 200 }
function 法术:法术取回合()
    local h = 1
    for i, v in ipairs(_等级) do
        if self.等级 >= v then
            h = h + 1
        else
            break
        end
    end
    return h
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    local h = 1
    for i, v in ipairs(_等级) do
        if self.等级 >= v then
            h = h + 1
        else
            break
        end
    end
    local 效果 = 4339 + self.等级 * 50

    return string.format("%s回合内使对手每回合法力流失%s", h, 效果)
end

BUFF = {
    法术 = '白骨爪',
    名称 = '白骨爪',
    id = 1514
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始(目标) --挣脱
    if not 目标.是否死亡 then
        local 效果 = 4339 + self.等级 * 50
        目标:减少魔法(效果)
    end

end

function BUFF:BUFF指令开始(对象) --昏睡

end

function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
