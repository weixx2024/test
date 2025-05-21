local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '雾里看花',
    是否被动 = true,
}

local BUFF

function 法术:进入战斗(攻击方)

end

function 法术:召唤进入战斗(攻击方,数据,召唤)
 
end

function 法术:战斗指令结束后(攻击方,数据)

end

function 法术:取几率(攻击方, 挨打方)
    local 亲密度 = 攻击方.亲密 or 0
    local 几率 = 10 + math.floor(亲密度 ^ 0.17)
    return 几率
end

function 法术:法术取描述(P)
    return string.format("所有被攻击的敌人将被附加雾里看花状态，攻击结束后才触发，按目标已损失血量造成百分比伤害。")
end

function 法术:攻击添加BUFF(攻击方,目标) --混乱
    if 目标 and not 目标:取BUFF('引爆')  and not 攻击方:是否我方(目标) then
        local b = 目标:添加BUFF(BUFF)
        if b then
            b.回合 = 1
            if self.BUFF目标组 == nil then self.BUFF目标组 = {} end
            self.BUFF目标组[#self.BUFF目标组+1] = {目标,math.floor((目标.最大气血-目标.气血)*0.1)}
        end
    end
end

function 法术:战斗指令结束后(攻击方,数据)
    if self.BUFF目标组 and #self.BUFF目标组 > 0 then
        local 目标数据 = 攻击方.战场:指令开始()
        for i,v in ipairs(self.BUFF目标组) do
            if v[1]:取BUFF('引爆') then
                v[1]:减少气血(v[2])
                v[1]:删除BUFF("引爆")
                v[1].当前数据.位置 = v[1].位置
            end
        end
        攻击方.战场:指令结束()
        数据:法术后( 目标数据)
        self.BUFF目标组 = nil
    end
end


BUFF = {
    法术 = '雾里看花',
    名称 = '引爆',

}


function BUFF:BUFF添加后(buff, 目标)
    if self == buff then

    end
end

function BUFF:BUFF回合开始() --挣脱

end

function BUFF:BUFF回合结束(单位)
    -- if self.回合数 >= self.回合 then
    --     self:删除()
    -- end
end

return 法术
