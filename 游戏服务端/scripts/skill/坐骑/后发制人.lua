local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '后发制人',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)
    local hp, kbzm = self:效果计算(坐骑)
    local jhp = math.floor(召唤.最大气血 * hp * 0.01)
    召唤.最大气血 = 召唤.最大气血 + jhp
    召唤.气血 = 召唤.气血 + jhp
    召唤.抗性.狂暴几率 = 召唤.抗性.狂暴几率 + kbzm
    召唤.抗性.致命几率 = 召唤.抗性.致命几率 + kbzm


end

function 法术:效果计算(坐骑)
    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end
    local hp = (坐骑.根骨 * 0.3 + 坐骑.灵性 * 0 + 坐骑.力量 * 0.7) * zjxz / 14.4 + self.熟练度 / 10000 / 4
    local kbzm = (坐骑.根骨 * 0.3 + 坐骑.灵性 * 0 + 坐骑.力量 * 0.7) * zjxz / 4.8 +
        self.熟练度 / 10000 / 1.333333333
    hp = math.ceil(hp * 1000) / 1000
    kbzm = math.ceil(kbzm * 1000) / 1000
    return hp, kbzm
end

function 法术:取描述(坐骑)
    local hp, kbzm = self:效果计算(坐骑)
    return string.format("#G增加HP#R%s%%#G,增加狂暴、致命几率#R%s%%", hp, kbzm)
end

return 法术
