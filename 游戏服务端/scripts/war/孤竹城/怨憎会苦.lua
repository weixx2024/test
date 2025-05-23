-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-26 07:12:31
-- @Last Modified time  : 2024-07-20 16:35:16

local 战斗 = {
    是否惩罚 = false --死亡
}


function 战斗:战斗初始化(玩家)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性
    怪物属性 = {--混--回血
        外形 = 6619,
        名称 = "画师",
        等级 = 等级,
        气血 = 36805424,
        魔法 = 220000,
        攻击 = 25000,
        速度 = 1670,
        抗性 = {
            气血=36805424,
            魔法=220000,
            伤害=25000,
            速度=1670,
            物理吸收=10,
            抗震慑=45,
            抗混乱=180,
            抗封印=180,
            抗昏睡=180,
            抗遗忘=120,
            抗鬼火=60,
            加强封印=30,
            加强混乱=40,
            加强昏睡=30,
            加强毒=55,
            忽视抗封=20,
            忽视抗睡=20,
            忽视抗混=30,
            忽视防御几率=100,
            忽视防御程度=100,
            连击率=100,
            连击次数=5,
            反击率=100,
            反击次数=5,
            命中率=75,
            狂暴几率=100

        },
        技能 = {
            { 名称 = '失心狂乱', 熟练度 = 10000 } 
        },
        施法几率 = 90,
        是否消失 = false,
    }
    self:加入敌方(1, 生成战斗怪物(怪物属性))
    怪物属性 = {--秒--混不住
        外形 = 3049,
        名称 = "沙弥尾",

        等级 = 等级,
        气血 = 24054521,
        魔法 = 220000,
        攻击 = 25000,
        速度 = 1310,
        抗性 = {
            物理吸收=60,
            抗震慑=39,
            抗混乱=160,
            抗封印=160,
            抗昏睡=160,
            抗遗忘=110,
            抗鬼火=60,
            加强封印=30,
            加强昏睡=30,
            加强毒=15,
            忽视抗封=22,
            忽视抗睡=22,
            忽视抗毒=30,
            忽视防御几率=100,
            忽视防御程度=100,
            连击率=100,
            连击次数=5,
            反击率=100,
            反击次数=5,
            命中率=75,
            狂暴几率=100,

        },
        技能 = {
            { 名称 = '万毒攻心', 熟练度 = 10000 } 
        },
        施法几率 = 90,
        是否消失 = false,
    }
    self:加入敌方(2, 生成战斗怪物(怪物属性))
    怪物属性 = {--秒--混不住
        外形 = 2098,
        名称 = "沙弥头",
        等级 = 等级,
        气血 = 23554521,
        魔法 = 220000,
        攻击 = 29214,
        速度 = 1100,
        抗性 = {
            物理吸收=60,
            抗震慑=36,
            抗混乱=160,
            抗封印=160,
            抗昏睡=160,
            抗遗忘=110,
            抗鬼火=60,
            忽视防御几率=100,
            忽视防御程度=100,
            连击率=100,
            连击次数=5,
            反击率=100,
            反击次数=5,
            命中率=75,
            狂暴几率=100

        },
        技能 = {
            { 名称 = '阎罗追命', 熟练度 = 10000 },
            { 名称 = '魔神附身', 熟练度 = 10000 },
            { 名称 = '乾坤借速', 熟练度 = 10000 }
        },
        施法几率 = 100,
        是否消失 = false,
    }

    self:加入敌方(3, 生成战斗怪物(怪物属性))
    怪物属性 = {--大力
        外形 = 3062,
        名称 = "神棍",
        等级 = 等级,
        气血 = 25504521,
        魔法 = 220000,
        攻击 = 390001,
        速度 = 510,
        抗性 = {
            物理吸收=150,
            抗震慑=30,
            抗混乱=190,
            抗封印=190,
            抗昏睡=190,
            抗遗忘=110,
            忽视防御几率=100,
            忽视防御程度=200,
            连击率=100,
            连击次数=10,
            反击率=100,
            反击次数=15,
            命中率=100,
            致命几率=100

        },
        技能 = {
        },
        施法几率 = 0,
        是否消失 = false,
    }
    self:加入敌方(4, 生成战斗怪物(怪物属性))
    怪物属性 = {--抽
        外形 = 3081,
        名称 = "神婆",
        等级 = 等级,
        气血 = 45014521,
        魔法 = 220000,
        攻击 = 2500,
        速度 = 1010,
        抗性 = {
            物理吸收=60,
            抗震慑=10,
            抗混乱=190,
            抗封印=190,
            抗昏睡=190,
            抗遗忘=130,
            抗三尸虫=2000,
            加强鬼火=50,
            加强三尸虫=2000,
            加强三尸虫回血程度=40,
            忽视抗鬼火=40,
            鬼火狂暴几率=30,
            三尸虫狂暴几率=30,
            三尸虫狂暴程度=50

        },
        技能 = {
            { 名称 = '九龙冰封', 熟练度 = 10000 }
        },
        施法几率 = 50,
        是否消失 = false,
    }
    self:加入敌方(5, 生成战斗怪物(怪物属性))
    怪物属性 = {--回血
        外形 = 2182,
        名称 = "摸鱼人",
        等级 = 等级,
        气血 = 59054521,
        魔法 = 2200000,
        攻击 = 250000,
        速度 = -990,
        抗性 = {
            物理吸收=60,
            抗震慑=10,
            抗混乱=200,
            抗封印=200,
            抗昏睡=200,
            抗遗忘=110,
            加强鬼火=50,
            加强三尸虫=2000,
            加强三尸虫回血程度=50,
            忽视抗鬼火=50,
            鬼火狂暴几率=30,
            三尸虫狂暴几率=30,
            三尸虫狂暴程度=50

        },
        技能 = {
            { 名称 = '九龙冰封', 熟练度 = 10000 }
        },
        施法几率 = 90,
        是否消失 = false,
    }
    self:加入敌方(6, 生成战斗怪物(怪物属性))
    怪物属性 = {--回血
    外形 = 2149,
    名称 = "牺牲",
    等级 = 等级,
    气血 = 31004521,
    魔法 = 220000,
    攻击 = 250000,
    速度 = 1160,
    抗性 = {
        物理吸收=60,
        抗震慑=10,
        抗混乱=200,
        抗封印=200,
        抗昏睡=200,
        抗遗忘=110,
        加强雷=100,
        加强风=100,
        加强水=100,
        忽视抗雷=50,
        忽视抗风=50,
        忽视抗水=50,
        水系狂暴几率=30,
        雷系狂暴几率=30,
        风系狂暴几率=30

    },
    技能 = {
        { 名称 = '袖里乾坤', 熟练度 = 10000 },
        { 名称 = '天诛地灭', 熟练度 = 10000 },
        { 名称 = '九龙冰封', 熟练度 = 10000 }
    },
    施法几率 = 90,
    是否消失 = false,
}
self:加入敌方(7, 生成战斗怪物(怪物属性))
怪物属性 = {--回血
外形 = 2087,
名称 = "乡民",
等级 = 等级,
气血 = 17504521,
魔法 = 220000,
攻击 = 250000,
速度 = 1010,
抗性 = {
    物理吸收=150,
    抗震慑=50,
    抗混乱=120,
    抗封印=120,
    抗昏睡=120,
    抗遗忘=110,
    忽视防御几率=100,
    忽视防御程度=150,
    连击率=100,
    连击次数=8,
    反击率=100,
    反击次数=15,
    命中率=100,
    狂暴几率=100,
    致命几率=75

},
技能 = {

},
施法几率 = 0,
是否消失 = false,
}
self:加入敌方(8, 生成战斗怪物(怪物属性))
怪物属性 = {--回血
外形 = 女童,
名称 = "童女",
等级 = 等级,
气血 = 49054521,
魔法 = 220000,
攻击 = 250000,
速度 = 930,
抗性 = {
    物理吸收=10,
    抗震慑=30,
    抗混乱=120,
    抗封印=120,
    抗昏睡=120,
    抗遗忘=110,
    抗鬼火=60,
    加强封印=10,
    加强混乱=30,
    加强昏睡=30,
    加强毒=55,
    忽视抗封=12,
    忽视抗睡=22,
    忽视抗混=22

},
技能 = {
    { 名称 = '失心狂乱', 熟练度 = 10000 },
    { 名称 = '四面楚歌', 熟练度 = 10000 },
    { 名称 = '百日眠', 熟练度 = 10000 }
},
施法几率 = 90,
是否消失 = false,
}
self:加入敌方(9, 生成战斗怪物(怪物属性))
怪物属性 = {--回血
外形 = 0400,
名称 = "童男",
等级 = 等级,
气血 = 21004521,
魔法 = 220000,
攻击 = 250000,
速度 = 90,
抗性 = {
    物理吸收=60,
    抗震慑=10,
    抗混乱=120,
    抗封印=120,
    抗昏睡=120,
    抗遗忘=110,
    加强雷=100,
    加强火=100,
    加强水=100,
    忽视抗雷=50,
    忽视抗火=50,
    忽视抗水=50,
    水系狂暴几率=30,
    火系狂暴几率=30,
    雷系狂暴几率=30,

},
技能 = {
    { 名称 = '九阴纯火', 熟练度 = 10000 },
    { 名称 = '天诛地灭', 熟练度 = 10000 },
    { 名称 = '九龙冰封', 熟练度 = 10000 }
},
施法几率 = 90,
是否消失 = false,
}
self:加入敌方(10, 生成战斗怪物(怪物属性))

end

function 战斗:进场喊话()
    -- local dd = self:取对象(11)
    -- if dd then
    --     dd:当前喊话("同名小怪需要一起杀死。")
    -- end

end

function 战斗:战斗回合开始(v, 回合数)
    if v.位置 == 11 and 回合数 == 1 then
        v:当前喊话("愚蠢的人类,为何要扰人清梦呢！")
    end








end

function 战斗:战斗回合结束(v)

end

function 战斗:战斗开始(v)



end

function 战斗:战斗结束(v)

end

return 战斗
