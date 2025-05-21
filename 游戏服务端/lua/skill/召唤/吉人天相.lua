-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-10-05 22:27:14
-- @Last Modified time  : 2024-10-06 21:39:05

local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '吉人天相',
    是否被动 = true,
	id = 2321,
}

function 法术:进入战斗(攻击方)
    self.回合数 = nil
    self.已生效 = nil
end


function 法术:受到伤害前(攻击方, 挨打方,数据)
    if not self.已生效 and 挨打方.战场.回合数 >= 3 then
        if 攻击方.伤害 > 挨打方.气血 then
            攻击方.伤害 = 挨打方.气血 - 10
            self.已生效 = true
            挨打方:删除所有BUFF()
            数据:目标添加特效(2321,挨打方.位置)
        end
    end
end


function 法术:法术取描述(攻击方, 挨打方)
    return string.format("抵御一次致死的伤害，血量降低到10，触发的时候同时清除自己所有状态，每场战斗最多触发1次(前3回合不生效，被动技能)。")
end

return 法术
