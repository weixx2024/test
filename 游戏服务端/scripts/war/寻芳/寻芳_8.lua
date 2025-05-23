
local 战斗 = {
    是否惩罚 = false --死亡
}


function 战斗:战斗初始化(玩家)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性
    怪物属性 = {
        外形 = 2150,
        名称 = "花之殇",
        等级 = 等级,
        气血 = 800000+等级*1000+转生*20000,
        魔法 = 20000+等级*200+转生*10000,
        攻击 = 10000+等级*10+转生*100,
        速度 = 600+等级*2+转生*100,
        抗性 = {
            物理吸收 = 5,
            抗震慑 = 5,
            抗混乱 = 110,
            抗封印 = 110,
            抗昏睡 = 110,
            加强混乱 = 15,
            加强毒伤害 = 1500,
            忽视抗混 = 10,
        },
        技能 = {{ 名称 = "失心狂乱", 熟练度 = 20000 }
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(1, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2315,
        名称 = "小花仙",
        等级 = 等级,
        气血 = 800000+等级*1000+转生*20000,
        魔法 = 20000+等级*200+转生*10000,
        攻击 = 10000+等级*10+转生*100,
        速度 = 600+等级*2+转生*100,
        抗性 = {
            物理吸收 = 5,
            抗震慑 = 5,
            抗混乱 = 110,
            抗封印 = 110,
            抗昏睡 = 110,
            加强火 = 25,
            加强毒伤害 = 1500,
            忽视抗火 = 20,
        },
        技能 = {{ 名称 = "九阴纯火", 熟练度 = 20000 }
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(2, 生成战斗怪物(怪物属性))
    self:加入敌方(3, 生成战斗怪物(怪物属性))
    self:加入敌方(4, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2096,
        名称 = "花妖",
        等级 = 等级,
        气血 = 800000+等级*1000+转生*20000,
        魔法 = 20000+等级*200+转生*10000,
        攻击 = 10000+等级*10+转生*100,
        速度 = 600+等级*2+转生*100,
        抗性 = {
            物理吸收 = 5,
            抗震慑 = 5,
            抗混乱 = 110,
            抗封印 = 110,
            抗昏睡 = 110,
            加强火 = 25,
            加强毒伤害 = 1500,
            忽视抗火 = 20,
        },
        技能 = {{ 名称 = "阎罗追命", 熟练度 = 20000 }
        },
        施法几率 = 50,
        是否消失 = false,
    }
    self:加入敌方(5, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2012,
        名称 = "侍女",
        等级 = 等级,
        气血 = 800000+等级*1000+转生*20000,
        魔法 = 20000+等级*200+转生*10000,
        攻击 = 10000+等级*10+转生*100,
        速度 = 600+等级*2+转生*100,
        抗性 = {
            物理吸收 = 5,
            抗震慑 = 5,
            抗混乱 = 110,
            抗封印 = 110,
            抗昏睡 = 110,
            加强毒 = 5,
            加强毒伤害 = 1500,
            忽视抗毒 = 20,
        },
        技能 = {{ 名称 = "万毒攻心", 熟练度 = 20000 }
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(6, 生成战斗怪物(怪物属性))
end

function 战斗:进场喊话()
    -- local dd = self:取对象(101)
    -- if dd then
    --     dd:当前喊话("同名小怪需要一起杀死。")
    -- end

end

function 战斗:战斗回合开始(v)

    --第一回主怪敏最快  出手100%遗忘10个目标 特殊遗忘 不能使用道具 150回合
    --红衣 物理攻击他自己回血 百分比70   蓝衣  物理攻击他自己回蓝 百分比70



end

function 战斗:战斗回合结束(v)

end

function 战斗:战斗开始(v)



end

function 战斗:战斗结束(v)

end

return 战斗
