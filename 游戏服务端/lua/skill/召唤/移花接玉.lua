local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 3,
    条件 = 37,
    名称 = '移花接玉',
    id = 2120,

}

function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
end

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    if self.冷却回合 then
        攻击方:提示("#R剩余冷却回合:" .. self.冷却回合)
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        local BUFF组 = {}
        local MYBUFF组 = {}
        local BUFF类型 = {"封印","混乱","速","盘","攻","昏睡","中毒","遗忘"}
        for i=1,#BUFF类型 do
            local BUFF = v:取BUFF(BUFF类型[i])
            if BUFF then
                BUFF组[#BUFF组+1] = {BUFF.原始buff,BUFF.回合,BUFF.效果}
                v:删除BUFF(BUFF类型[i])
                if BUFF.效果 and type(BUFF.效果) == "table" then
                    for x,_ in pairs(BUFF.效果) do
                        v[x] = v[x] - _
                        v.抗性[x] = (v.抗性[x] or 0) - _
                    end
                end
                v.当前数据.位置 = v.位置
            end


            local BUFF = 攻击方:取BUFF(BUFF类型[i])
            if BUFF then
                MYBUFF组[#MYBUFF组+1] = {BUFF.原始buff,BUFF.回合,BUFF.效果}
                if BUFF.效果 and type(BUFF.效果) == "table" then
                    for x,v in pairs(BUFF.效果) do
                        攻击方[x] = 攻击方[x] - v
                        攻击方.抗性[x] = (攻击方.抗性[x] or 0) - v
                    end
                end
                攻击方:删除BUFF(BUFF类型[i],攻击方.位置)
            end
        end

        for i=1,#BUFF组 do
            local b = 攻击方:添加BUFF(BUFF组[i][1])
            if b then
                b.回合 = BUFF组[i][2]
                b.效果 = BUFF组[i][3]
                攻击方.当前数据.位置 =  攻击方.位置
            end
            if BUFF组[i][3] and type(BUFF组[i][3]) == "table" then
                for x,v in pairs(BUFF组[i][3]) do
                    攻击方[x] = 攻击方[x] + v
                    攻击方.抗性[x] = (攻击方.抗性[x] or 0) + v
                end
            end
        end

        for i=1,#MYBUFF组 do
            local b = v:添加BUFF(MYBUFF组[i][1])
            if b then
                b.回合 = MYBUFF组[i][2]
                b.效果 = MYBUFF组[i][3]
                v.当前数据.位置 =  v.位置
            end
        
            if MYBUFF组[i][3] and type(MYBUFF组[i][3]) == "table" then
                for x,_ in pairs(MYBUFF组[i][3]) do
                    v[x] = v[x] + _
                    v.抗性[x] = (v.抗性[x] or 0) + _
                end
            end
        end
    end
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        self.冷却回合 = 5
    end
end


function 法术:回合开始()
    if self.冷却回合 then
        self.冷却回合 = self.冷却回合 - 1
        if self.冷却回合 <= 0 then
            self.冷却回合 = nil
        end
    end
end

function 法术:法术取消耗()
    return { 消耗MP = 0 }
end

function 法术:法术取描述(P)
    return string.format("#Y与任意目标交换状态#G（盘、牛、速、冰、混、睡、忘、毒、魅惑），#R冷却5回合")
end

return 法术
