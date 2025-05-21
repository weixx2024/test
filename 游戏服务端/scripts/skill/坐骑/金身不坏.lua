local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '金身不坏',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)
    local hp, wlxs, kzs, kzd, kssc = self:效果计算(坐骑)
    local jhp = math.floor(召唤.最大气血 * hp * 0.01)
    召唤.最大气血 = 召唤.最大气血 + jhp
    召唤.气血 = 召唤.气血 + jhp
    召唤.抗性.物理吸收 = 召唤.抗性.物理吸收 + wlxs
    召唤.抗性.抗震慑 = 召唤.抗性.抗震慑 + kzs
    召唤.抗性.抗中毒 = 召唤.抗性.抗中毒 + kzd
    召唤.抗性.抗三尸虫 = 召唤.抗性.抗三尸虫 + kssc
end

function 法术:效果计算(坐骑)
    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end
    local hp = (坐骑.根骨 * 0.7 + 坐骑.灵性 * 0 + 坐骑.力量 * 0.3) * zjxz / 14.4 + self.熟练度 / 10000 / 4
    local wlxs = (坐骑.根骨 * 0.7 + 坐骑.灵性 * 0 + 坐骑.力量 * 0.3) * zjxz / 3.6 + self.熟练度 / 10000 /1
    local kzs = (坐骑.根骨 * 0.7 + 坐骑.灵性 * 0 + 坐骑.力量 * 0.3) * zjxz / 7.2 + self.熟练度 / 10000 / 2
    local kzd = (坐骑.根骨 * 0.7 + 坐骑.灵性 * 0 + 坐骑.力量 * 0.3) * zjxz / 4.8 + self.熟练度 / 10000 /1.333333333
    local kssc = (坐骑.根骨 * 0.7 + 坐骑.灵性 * 0 + 坐骑.力量 * 0.3) * 125 / 3 + self.熟练度 * 1500 /100000
    hp = math.ceil(hp * 1000) / 1000
    wlxs = math.ceil(wlxs * 1000) / 1000
    kzs = math.ceil(kzs * 1000) / 1000
    kzd = math.ceil(kzd * 1000) / 1000
    kssc = math.floor(kssc)
    return hp, wlxs, kzs, kzd, kssc
end

function 法术:取描述(坐骑)
    local hp, wlxs, kzs, kzd, kssc = self:效果计算(坐骑)
    return string.format("#G增加HP#R%s%%#G,增加物理吸收#R%s%%#G,增加抗震慑#R%s%%#G,增加抗中毒#R%s%%#G,增加抗三尸虫#R%s#G。"
        , hp, wlxs, kzs, kzd, kssc)
end

return 法术
