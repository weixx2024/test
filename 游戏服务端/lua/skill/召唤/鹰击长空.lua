local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '鹰击长空',
	是否终极 = true,
    id = 2138,
}


local BUFF
function 法术:进入战斗(攻击方)
    self.回合 = 0
    --战场BUF
end
function 法术:回合开始(攻击方,数据)
    if 攻击方.战场.回合数 > self.回合 + 3 then
        攻击方.触发分裂 = true
        self.回合 = 攻击方.战场.回合数
    else
        攻击方.触发分裂 = nil
    end
end

function 法术:BUFF物理攻击前(攻击方,挨打方,数据)
    if 数据.分裂攻击 then
        攻击方.伤害 = (攻击方.伤害*0.33)
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "每隔一定回合自身获得溅射能力，物理攻击的目标为1的其他目标则造成目标1/3的伤害。"
end

return 法术
