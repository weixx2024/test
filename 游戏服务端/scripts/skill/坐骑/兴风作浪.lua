local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '兴风作浪',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)

    local mp, qfs, kfs = self:效果计算(坐骑)
    local jmp = math.floor(召唤.最大魔法 * mp * 0.01)
    召唤.最大魔法 = 召唤.最大魔法 + jmp
    召唤.魔法 = 召唤.魔法 + jmp
    召唤.抗性.加强风 = 召唤.抗性.加强风 + qfs
    召唤.抗性.加强水 = 召唤.抗性.加强水 + qfs
    召唤.抗性.抗风 = 召唤.抗性.抗风 + kfs
    召唤.抗性.抗水 = 召唤.抗性.抗水 + kfs
    召唤.抗性.抗鬼火 = 召唤.抗性.抗鬼火 + kfs
end

function 法术:效果计算(坐骑)

    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end
    local mp = (坐骑.根骨 * 0.3 + 坐骑.灵性 * 0.7 + 坐骑.力量 * 0) * zjxz / 7.2 + self.熟练度 / 10000 / 2
    local qfs = (坐骑.根骨 * 0.3 + 坐骑.灵性 * 0.7 + 坐骑.力量 * 0) * zjxz / 4.8 + self.熟练度 / 10000 /
        1.333333333
    local kfs = (坐骑.根骨 * 0.3 + 坐骑.灵性 * 0.7 + 坐骑.力量 * 0) * zjxz / 7.2 + self.熟练度 / 10000 / 2

    mp = math.ceil(mp * 1000) / 1000
    qfs = math.ceil(qfs * 1000) / 1000
    kfs = math.ceil(kfs * 1000) / 1000
    return mp, qfs, kfs
end

function 法术:取描述(坐骑)
    local mp, qfs, kfs = self:效果计算(坐骑)
    return string.format("#G增加MP#R%s%%#G,加强风、水#R%s%%#G,增加抗风、水、鬼火#R%s%%#G,", mp, qfs, kfs)
end

return 法术
