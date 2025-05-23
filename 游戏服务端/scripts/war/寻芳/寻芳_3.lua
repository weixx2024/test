
local 战斗 = {
    是否惩罚 = false --死亡
}



local _技能组 = {
    {
        { 名称 = "百日眠", 熟练度 = 10000 },
        { 名称 = "天诛地灭", 熟练度 = 10000 },
    },

    {
        { 名称 = "魔音摄心", 熟练度 = 10000 },
        { 名称 = "太乙生风", 熟练度 = 10000 },
    },

    {
        { 名称 = "谗言相加", 熟练度 = 10000 },
        { 名称 = "龙啸九天", 熟练度 = 10000 },
    },
    {
        { 名称 = "天罗地网", 熟练度 = 10000 },
        { 名称 = "魔神飞舞", 熟练度 = 10000 },
    },
    {

    },
}


function 战斗:战斗初始化(玩家)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性
    怪物属性 = {
        外形 = 2107,
        名称 = "九子鬼母",
        等级 = 等级,
        气血 = 100000+等级*1000+转生*20000,
        魔法 = 20000+等级*200+转生*10000,
        攻击 = 1000+等级*10+转生*100,
        速度 = 100+等级*1+转生*50,
        抗性 = {
            物理吸收 = 5,
            抗震慑 = 5,
            抗混乱 = 60,
            抗封印 = 60,
            抗昏睡 = 60,
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = {
            { 名称 = "万毒攻心", 熟练度 = 15000 }
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(1, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 46,
        名称 = "小孩",
        等级 = 等级,
        气血 = 100000+等级*1000+转生*20000,
        魔法 = 20000+等级*200+转生*10000,
        攻击 = 1000+等级*10+转生*100,
        速度 = 100+等级*1+转生*50,
        抗性 = {
            物理吸收 = 5,
            抗震慑 = 5,
            抗混乱 = 60,
            抗封印 = 60,
            抗昏睡 = 60,
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = {
        },
        施法几率 = 100,
        是否消失 = false,
    }

    for i = 1, 9, 1 do
        怪物属性.技能 = {}
        怪物属性.技能 = _技能组[math.random(#_技能组)]
        self:加入敌方(i + 1, 生成战斗怪物(怪物属性))
    end




end

function 战斗:进场喊话()
    -- local dd = self:取对象(101)
    -- if dd then
    --     dd:当前喊话("阎魔罗王,作地狱主,兄治男事,妹理女事")
    -- end
end

function 战斗:战斗回合开始(v)
end

function 战斗:战斗回合结束(v)

end

function 战斗:战斗开始(v)



end

function 战斗:战斗结束(v)

end

return 战斗
