local 战斗 = {}

function 战斗:战斗初始化(玩家)
    for i = 1, 1 do
        local r = 生成战斗怪物 {
            外形 = 38,
            名称 = '梦魇',
            攻击 = 1000,
            速度 = 1000,
            气血 = 9999999,
            是否消失 = true
        }
        self:加入敌方(i, r)
    end
end

function 战斗:战斗回合开始(v)
    if v.战场.回合数 > 10 then
        if v.位置 >= 11 then
            v:逃跑()
        end
    end
end

function 战斗:战斗结束(s)
end

return 战斗
