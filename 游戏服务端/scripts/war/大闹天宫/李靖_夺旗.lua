-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-26 07:12:31
-- @Last Modified time  : 2022-09-05 19:58:42

local 战斗 = {
    是否惩罚 = false --死亡
}


function 战斗:战斗初始化(玩家)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性
    怪物属性 = {
        外形 = 2122,
        名称 = "李靖",
        等级 = 等级,
        气血 = 600000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 26000 + 等级 * 35,
        攻击 = 2988,
        速度 = 800,
        抗性 = {
            抗震慑 = 10,
            抗混乱 = 100,
            抗封印 = 100,
            抗昏睡 = 100,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
            连击率 = 75,
            连击次数 = 5,
            致命几率 = 75,
            反击率 = 50,
            反击次数 = 1,
            
        },
        技能 = {
               { 名称 = "失心狂乱", 熟练度 = 15000 }
        },
        施法几率 = 50,
        是否消失 = false,
    }
    self:加入敌方(1, 生成战斗怪物(怪物属性))





end

--熟练度 l*100
function 战斗:战斗回合开始(v)

end

function 战斗:战斗回合结束(v)

end

function 战斗:战斗开始(v)



end

local function 掉落包(玩家)
    local 大闹积分 = 10000


end

function 战斗:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                掉落包( v.对象.接口)
            end
        end
    end
end

return 战斗
