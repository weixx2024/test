local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '破釜沉舟',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)
    local ap, kb, hsfy = self:效果计算(坐骑)
    召唤.攻击 = 召唤.攻击 + math.floor(召唤.攻击 * ap * 0.01)
    召唤.抗性.狂暴几率 = 召唤.抗性.狂暴几率 + kb
    召唤.抗性.忽视防御几率 = 召唤.抗性.忽视防御几率 + hsfy
    召唤.抗性.忽视防御程度 = 召唤.抗性.忽视防御程度 + hsfy
end

function 法术:效果计算(坐骑)
    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end
    local ap = (坐骑.根骨 * 0 + 坐骑.灵性 * 0 + 坐骑.力量 * 1) * zjxz / 7.2 + self.熟练度 / 10000 / 2
    local kb = (坐骑.根骨 * 0 + 坐骑.灵性 * 0 + 坐骑.力量 * 1) * zjxz / 4.8 + self.熟练度 / 10000 /1.333333333
    local hsfy = (坐骑.根骨 * 0 + 坐骑.灵性 * 0 + 坐骑.力量 * 1) * zjxz / 3.6 + self.熟练度 / 10000 / 1
    ap = math.ceil(ap * 1000) / 1000
    kb = math.ceil(kb * 1000) / 1000
    hsfy = math.ceil(hsfy * 1000) / 1000
    return ap, kb, hsfy
end

function 法术:取描述(坐骑)
    local ap, kb, hsfy = self:效果计算(坐骑)
    return string.format("#G增加AP#R%s%%#G,增加狂暴几率#R%s%%#G,增加忽视防御几率#R%s%%#G,忽视防御程度#R%s%%"
        , ap, kb
        , hsfy, hsfy)
end

return 法术
