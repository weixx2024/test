local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '天雷怒火',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)

    local mp, qlh, klh = self:效果计算(坐骑)
    local jmp = math.floor(召唤.最大魔法 * mp * 0.01)
    召唤.最大魔法 = 召唤.最大魔法 + jmp
    召唤.魔法 = 召唤.魔法 + jmp
    召唤.抗性.加强雷 = 召唤.抗性.加强雷 + qlh
    召唤.抗性.加强火 = 召唤.抗性.加强火 + qlh
    召唤.抗性.抗雷 = 召唤.抗性.抗雷 + klh
    召唤.抗性.抗火 = 召唤.抗性.抗火 + klh
    召唤.抗性.抗鬼火 = 召唤.抗性.抗鬼火 + klh



end

function 法术:效果计算(坐骑)
    local zjxz = 1
    if 坐骑.几座 == 2 or 坐骑.几座 == 4 then
        zjxz = 1.2
    end
    local mp = (坐骑.灵性 * 0.7 + 坐骑.力量 * 0.3) * zjxz / 7.2 + self.熟练度 / 10000 / 2
    local qlh = (坐骑.灵性 * 0.7 + 坐骑.力量 * 0.3) * zjxz / 4.8 + self.熟练度 / 10000 / 1.333333333
    local klh = (坐骑.灵性 * 0.7 + 坐骑.力量 * 0.3) * zjxz / 7.2 + self.熟练度 / 10000 / 2
    -- kgh=(坐骑.灵性*0.7+坐骑.力量*0.3)*zjxz/7.2+self.熟练度/10000/2
    mp = math.ceil(mp * 1000) / 1000
    qlh = math.ceil(qlh * 1000) / 1000
    klh = math.ceil(klh * 1000) / 1000
    return mp, qlh, klh
end

function 法术:取描述(坐骑)
    local mp, qlh, klh = self:效果计算(坐骑)
    return string.format("#G增加MP#R%s%%#G,加强雷、火#R%s%%#G,增加抗雷、火、鬼火#R%s%%#G,", mp, qlh
        , klh)
end

return 法术
