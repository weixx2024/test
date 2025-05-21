-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-10-11 19:31:33
-- @Last Modified time  : 2024-10-12 19:38:38

local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '取之有道',
    是否物理法术 = true,
    id = 1904,

}

function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        if math.random(15) < self:取几率(攻击方) then
            攻击方.伤害 = self:法术取伤害(攻击方, 挨打方)
            self.吸血值=攻击方.伤害
            挨打方:被法术攻击(攻击方,self)
            return true
        end
    end
end

function 法术:物理法术附加(攻击方, 目标)
    local list = {}
    local px = {}
    for _, v in 攻击方:遍历我方() do
        if v.是否玩家 and v.是否死亡 and not v:取BUFF('封印') then
            table.insert(list, v)
        elseif not v:取BUFF('封印') then
            table.insert(list, v)
        end
    end
    table.sort(list, function(a, b)
        if a.是否死亡 and not b.是否死亡 then
            return true
        elseif not a.是否死亡 and b.是否死亡 then
            return false
        else
            local aa = a.气血 / a.最大气血
            local bb = b.气血 / b.最大气血
            return aa < bb
        end
    end)
    if list[1] then
        if self.吸血值 then
            local 回复=math.floor(self.吸血值*(2.8+攻击方.加强三尸虫回血程度 * 0.01))
            list[1]:增加气血(回复)
            list[1].当前数据.位置 = list[1].位置
            self.吸血值 = nil
        end
    end
end

function 法术:法术取伤害(攻击方, 挨打方) 
    local 伤害 = 0
    local 等级 = 攻击方.等级 + 1
    local 狂暴系数=1
    伤害=等级*35+1*0.18+攻击方.加强三尸虫
    if math.random(100) < 攻击方.三尸虫狂暴几率 then
        狂暴系数=1.5+攻击方.三尸虫狂暴程度*0.01
        挨打方.伤害类型 = "狂暴"
    end
    local 攻击五行,挨打五行=取五行属性(攻击方),取五行属性(挨打方)
    local 攻击方五行克制=取五行强克(攻击方)
    伤害=(伤害-挨打方.抗性.抗三尸虫)*狂暴系数*(1+0.5*取五行克制(攻击五行,挨打五行))*取强力克系数(攻击方五行克制,挨打五行)*取无属性伤害加成(攻击方,挨打方)
    if 伤害 <= 0 then
        伤害 = 1
    end
    return math.floor(伤害)
end

function 法术:取几率(召唤)

    return 10
end

function 法术:法术取描述(召唤)
    local ndjl = self:取几率(召唤)
    local ndcd = math.floor(296.1572 + 0.0002364957 * math.pow(召唤.最大魔法, 1.57));
    return string.format("在物理攻击的时候有#R%.2f%%#W的几率附加2法1熟练三尸虫效果", ndjl)
end


return 法术
