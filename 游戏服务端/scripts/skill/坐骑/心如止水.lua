local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '心如止水',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)
    local hp, kbhs = self:效果计算(坐骑)
    local jhp = math.floor(召唤.最大气血 * hp * 0.01)
    召唤.最大气血 = 召唤.最大气血 + jhp
    召唤.气血 = 召唤.气血 + jhp
    召唤.抗性.抗封印 = 召唤.抗性.抗封印 + kbhs
    召唤.抗性.抗混乱 = 召唤.抗性.抗混乱 + kbhs
    召唤.抗性.抗昏睡 = 召唤.抗性.抗昏睡 + kbhs
    召唤.抗性.抗遗忘 = 召唤.抗性.抗遗忘 + kbhs

end

function 法术:效果计算(坐骑)
    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end
    local hp = (坐骑.根骨 * 0.7 + 坐骑.灵性 * 0.3 + 坐骑.力量 * 0) * zjxz / 14.40329218 +
        self.熟练度 / 10000 / 3.99543379
    local kbhs = (坐骑.根骨 * 0.7 + 坐骑.灵性 * 0.3 + 坐骑.力量 * 0) * zjxz / 4.115226337 +
        self.熟练度 / 10000 / 1.141552511
    hp = math.ceil(hp * 1000) / 1000
    kbhs = math.ceil(kbhs * 1000) / 1000
    return hp, kbhs
end

function 法术:取描述(坐骑)
    local hp, kbhs = self:效果计算(坐骑)
    return string.format("#G增加HP#R%s%%#G,增加抗人法#R%s%%#G。", hp, kbhs)
end

return 法术
