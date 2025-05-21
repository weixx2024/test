local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '万劫不复',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)
    local mp, qxf = self:效果计算(坐骑)
    local jmp = math.floor(召唤.最大魔法 * mp * 0.01)
    召唤.最大魔法 = 召唤.最大魔法 + jmp
    召唤.魔法 = 召唤.魔法 + jmp
    召唤.抗性.加强水 = 召唤.抗性.加强水 + qxf
    召唤.抗性.加强风 = 召唤.抗性.加强风 + qxf
    召唤.抗性.加强雷 = 召唤.抗性.加强雷 + qxf
    召唤.抗性.加强火 = 召唤.抗性.加强火 + qxf
end

function 法术:效果计算(坐骑)
    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end
    local mp = (坐骑.根骨 * 0 + 坐骑.灵性 * 1 + 坐骑.力量 * 0) * zjxz / 7.2 + self.熟练度 / 10000 / 2
    local qxf = (坐骑.根骨 * 0 + 坐骑.灵性 * 1 + 坐骑.力量 * 0) * zjxz / 4.8 + self.熟练度 / 10000 /
        1.333333333
    mp = math.ceil(mp * 1000) / 1000
    qxf = math.ceil(qxf * 1000) / 1000
    return mp, qxf
end

function 法术:取描述(坐骑)
    local mp, qxf = self:效果计算(坐骑)
    return string.format("#G增加MP#R%s%%#G,加强仙法#R%s%%#G。", mp, qxf)
end

return 法术
