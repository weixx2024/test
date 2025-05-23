﻿
local 战斗 = {
    是否惩罚 = false --死亡
}

function 战斗:战斗初始化(玩家)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性
    怪物属性 = {
        外形 = 2209,
        名称 = "烛九阴",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 2000 + 等级 * 10 + 转生 * 1,
        速度 = 1600,
        抗性 = {
            物理吸收 = 100,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强雷=25,
            忽视抗雷 = 20,
            加强毒伤害=500,
            忽视抗睡=5,
            躲闪率= 75,
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "阎罗追命", 熟练度 = 20000 },
        
        
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(1, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2301,
        名称 = "上古妖魔",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 2000 + 等级 * 10 + 转生 * 1,
        速度 = 1500,
        抗性 = {
            物理吸收 = 100,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强混乱=15,
            忽视抗混 = 6,
            加强毒伤害=500,
            忽视抗睡=5,
            躲闪率= 75,
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "失心狂乱", 熟练度 = 20000 },
        
        
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(2, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2070,
        名称 = "青龙",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 2000 + 等级 * 10 + 转生 * 1,
        速度 = 1600,
        抗性 = {
            物理吸收 = 100,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强水=25,
            忽视抗水 = 20,
            加强毒伤害=500,
            忽视抗睡=5,
            躲闪率= 75,
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "九龙冰封", 熟练度 = 20000 },
        
        
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(3, 生成战斗怪物(怪物属性))

    怪物属性 = {
        外形 = 2070,
        名称 = "青龙侍卫",
        染色 = 0x02020202,
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 2000 + 等级 * 10 + 转生 * 1,
        速度 = 1600,
        抗性 = {
            物理吸收 = 100,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强雷=25,
            忽视抗雷 = 20,
            加强毒伤害=500,
            忽视抗睡=5,
            躲闪率= 75,
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "天诛地灭", 熟练度 = 20000 },
        
        
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(4, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2038,
        名称 = "白虎",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 20000 + 等级 * 10 + 转生 * 1,
        速度 = 1000,
        抗性 = {
            物理吸收 = 100,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强雷=25,
            忽视抗雷 = 20,
            加强毒伤害=500,
            忽视抗睡 = 5,
            连击率 = 70,
            连击次数 = 5,
            致命几率=70,
            反击率 = 50,
            反击次数 = 1,
            忽视防御几率 = 100,
            忽视防御程度 = 120,
            躲闪率= 75,
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "阎罗追命", 熟练度 = 20000 },
        
        
        },
        施法几率 = 0,
        是否消失 = false,
    }
    self:加入敌方(5, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2028,
        名称 = "白虎侍卫",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 20000 + 等级 * 10 + 转生 * 1,
        速度 = 1000,
        抗性 = {
            物理吸收 = 100,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强雷=25,
            忽视抗雷 = 20,
            加强毒伤害=500,
            忽视抗睡 = 5,
            连击率 = 70,
            连击次数 = 5,
            致命几率=70,
            反击率 = 50,
            反击次数 = 1,
            忽视防御几率 = 100,
            忽视防御程度 = 120,
            躲闪率= 75,
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "阎罗追命", 熟练度 = 20000 },
        
        
        },
        施法几率 = 0,
        是否消失 = false,
    }
    self:加入敌方(6, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2071,
        名称 = "朱雀",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 2000 + 等级 * 10 + 转生 * 1,
        速度 = 1100,
        抗性 = {
            物理吸收 = 100,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强火=25,
            忽视抗火 = 50,
            加强毒伤害=500,
            忽视抗睡 = 5,
            躲闪率= 75,
            
            
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "九阴纯火", 熟练度 = 20000 },
        
        
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(7, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2099,
        名称 = "千年寒冰",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 2000 + 等级 * 10 + 转生 * 1,
        速度 = 1100,
        抗性 = {
            物理吸收 = 80,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强昏睡=15,
            忽视抗火 = 20,
            加强毒伤害=500,
            忽视抗睡 = 20,
            躲闪率= 75,
            反震率= 75,
            反震程度= 75,
            
            
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "百日眠", 熟练度 = 20000 },
        
        
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(8, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2108,
        名称 = "玄武",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 2000 + 等级 * 10 + 转生 * 1,
        速度 = 1100,
        抗性 = {
            物理吸收 = 5,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强毒=25,
            忽视抗毒 = 10,
            加强毒伤害=500,
            忽视抗睡 = 5,
            躲闪率= 75,
            反震率= 75,
            反震程度= 75,
            
            
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "万毒攻心", 熟练度 = 20000 },
        
        
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(9, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2064,
        名称 = "玄武侍卫",
        等级 = 等级,
        气血 = 1000000 + 等级 * 1000 + 转生 * 100000,
        魔法 = 20000 + 等级 * 100 + 转生 * 100,
        攻击 = 2000 + 等级 * 10 + 转生 * 1,
        速度 = 1100,
        抗性 = {
            物理吸收 = 5,
                抗震慑 = 5,
                抗混乱 = 120,
                抗封印 = 120,
                抗昏睡 = 120,
                加强毒=25,
            忽视抗毒 = 10,
            加强毒伤害=500,
            忽视抗睡 = 5,
            躲闪率= 75,
            反震率= 75,
            反震程度= 75,
            
            
            抗水 = -30, 抗雷 = -30, 抗火 = -30, 抗风 = -30,
        },
        技能 = { { 名称 = "万毒攻心", 熟练度 = 20000 },
        
        
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(10, 生成战斗怪物(怪物属性))


end

function 战斗:进场喊话()

end

function 战斗:战斗回合开始(v)
    if self.回合数 == 1 then
        local r = v.名称
        if r == "玄武" then
            v:当前喊话("玄武#101镇守北方，拥有无敌的防御，你是否能找到我的弱点#55")
        elseif r == "朱雀" then
            v:当前喊话("朱雀#101镇守南方，这是一场实力的考验")
        elseif r == "白虎侍卫" then
            v:当前喊话("为我那被抓去当了坐骑的兄弟报仇#104")
        elseif r == "烛九阴" then
            v:当前喊话("注意你们的血#0一旦血量小于30%，胖子兄弟会收了你们的小命#0")
        elseif r == "青龙" then
            v:当前喊话("青龙#101镇守西方，谁欲撼动我的龙威#55")
        elseif r == "白虎" then
            v:当前喊话("白虎#101武力的象征，看我的厉害#90")
        end
    elseif self.回合数 == 2 then
        local r = v.名称
        if r == "烛九阴" then
            v:当前喊话("当然，你们的血也不能太多，那样会不公平，超过80%，胖子会帮我们回血#0哇哈哈哈")
        end
    end
    --白虎侍卫 100%优先攻击女魔 其次男魔 都没有 随机
    --朱雀 5回合后法术100%暴击
    --玄武 我方总血量高于80% 玄武就释放三尸虫技能 我方总血量低于30% 就释放仙法 100%狂暴



end

function 战斗:战斗回合结束(v)

end

function 战斗:战斗开始(v)



end

function 战斗:战斗结束(v)

end

return 战斗
