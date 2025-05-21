-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-07 18:25:22
-- @Last Modified time  : 2022-08-13 06:40:20
local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '飞燕回翔',
    id = 2102,
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
        self.xh=false
        for _, v in ipairs(目标) do
            if not v:取BUFF('飞燕回翔') then
                local b = v:添加BUFF(BUFF)
                if b then
                    b.回合 = 1
                    b.效果 = self:法术取BUFF效果(攻击方, v)
                end
            end
        end
        攻击方:被驱逐(nil,攻击方.当前数据)
    end
end

function 法术:法术取消耗(P)
    local MP = 0
    return { 消耗MP = MP}
end

function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 效果 = math.floor(挨打方.速度 - 攻击方.速度*0.1)
    挨打方.速度 = 挨打方.速度 - 效果
    return 效果
end


function 法术:法术取描述()
    return '对己方某目标使用该技能后，目标单位的SP对应减少为自身SP的一定值，持续1回合，使用后该召唤兽离场。 '
end


BUFF = {
    法术 = '飞燕回翔',
    名称 = '飞燕回翔',
    id = 106
}
法术.BUFF = BUFF

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        单位.速度 = 单位.速度 + self.效果
        self:删除()
    end
end

return 法术
