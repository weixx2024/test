-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-07 18:25:22
-- @Last Modified time  : 2022-08-13 06:40:20
local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '妙笔生花',
    id = 2315,
}
local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗 = self:法术取消耗(攻击方)
    if 攻击方:取魔法() < 消耗.消耗MP then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh.消耗MP)
        for i,v in ipairs(目标) do
            v:被使用法术(攻击方, self)
            local buff组 = {}
            if v:取BUFF('混乱') then
                buff组[#buff组+1] = "混乱"
            end
            if v:取BUFF('封印') then
                buff组[#buff组+1] = "封印"
            end
            if v:取BUFF('昏睡') then
                buff组[#buff组+1] = "昏睡"
            end
            if v:取BUFF('中毒') then
                buff组[#buff组+1] = "中毒"
            end
            if v:取BUFF('遗忘') then
                buff组[#buff组+1] = "遗忘"
            end
            if #buff组 >= 1 then
                v:删除BUFF(buff组[math.random(1,#buff组)])
            end
        end
        self.xh=false
    end
end

function 法术:法术取消耗(P)
    local MP = math.floor(P.最大魔法 * 0.5)
    return { 消耗MP = MP}
end



function 法术:法术取描述()
    return '指定一个友方目标，消耗50%的法量上限，有几率解除其一种负面状态(不包括控制+法宝)，如有多种，随机解除一种，冷却5回合。 '
end

function 法术:法术取目标数()
    return 1
end

return 法术
