local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '天神护体',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)
    local sp, kl = self:效果计算(坐骑)
    召唤.速度 = 召唤.速度 + math.floor(召唤.速度 * sp * 0.01)
    召唤.抗性.抗雷 = 召唤.抗性.抗雷 + kl
    召唤.抗性.抗火 = 召唤.抗性.抗火 + kl
    召唤.抗性.抗水 = 召唤.抗性.抗水 + kl
    召唤.抗性.抗风 = 召唤.抗性.抗风 + kl
    -- 召唤.抗性.抗鬼火 = 召唤.抗性.抗鬼火 + kl
end

function 法术:效果计算(坐骑)
    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end
    local sp = (坐骑.根骨 * 1 + 坐骑.灵性 * 0 + 坐骑.力量 * 0) * zjxz / 14.4 + self.熟练度 / 10000 / 4
    local kl = (坐骑.根骨 * 1 + 坐骑.灵性 * 0 + 坐骑.力量 * 0) * zjxz / 4.8 + self.熟练度 / 10000 /
        1.333333333
    sp = math.ceil(sp * 1000) / 1000
    kl = math.ceil(kl * 1000) / 1000
    return sp, kl
end

function 法术:取描述(坐骑)
    local sp, kl = self:效果计算(坐骑)
    return string.format("#G增加SP#R%s%%#G,增加抗仙法#R%s%%#G。", sp, kl)
end

return 法术
