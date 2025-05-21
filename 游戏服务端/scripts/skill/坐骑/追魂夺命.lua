local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '追魂夺命',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)
    local sp, mlz = self:效果计算(坐骑)
    召唤.速度 = 召唤.速度 + math.floor(召唤.速度 * sp * 0.01)
    召唤.抗性.命中率 = 召唤.抗性.命中率 + mlz
    召唤.抗性.致命几率 = 召唤.抗性.致命几率 + mlz
    召唤.抗性.连击率 = 召唤.抗性.连击率 + mlz
end

function 法术:效果计算(坐骑)
    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end

    local sp = (坐骑.灵性 * 0.3 + 坐骑.力量 * 0.7) * zjxz / 14.4 + self.熟练度 / 10000 / 4
    local mlz = (坐骑.灵性 * 0.3 + 坐骑.力量 * 0.7) * zjxz / 7.2 + self.熟练度 / 10000 / 2
    sp = math.ceil(sp * 1000) / 1000
    mlz = math.ceil(mlz * 1000) / 1000
    return sp, mlz
end

function 法术:取描述(坐骑)
    local sp, mlz = self:效果计算(坐骑)
    return string.format("#G增加SP#R%s%%#G,增加命中率#R%s%%#G,增加致命几率#R%s%%#G,连击率#R%s%%", sp, mlz
        , mlz, mlz)
end

return 法术
