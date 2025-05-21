local 事件 = {
    名称 = '种族比武',
    是否打开 = false,
    开始时间 = os.time { year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00 },
    结束时间 = os.time { year = 2025, month = 7, day = 30, hour = 0, min = 0, sec = 00 }
}

function 事件:事件初始化()
    self.进场数据 = {}
    self.进场开关 = false
    self.匹配开关 = false
end

function 事件:事件开始()
    self.进场开关 = true
end

function 事件:事件结束()
    self.是否结束 = true
end

local _开启日 = { --true开启--false
    ["1"] = false,
    ["2"] = false,
    ["3"] = true,
    ["4"] = false,
    ["5"] = false,
    ["6"] = false,
    ["0"] = false,
}

local _开启分 = { --true开启--false

}


function 事件:开始匹配()
    local t = {}

    for nid, _ in pairs(self.进场数据) do
        table.insert(t, nid)
        print(nid)
    end
    print(t[1],t[2])
    if #t >= 2 then
        --条件判断 在线判断  准备判断 是否战斗
        local P = self:取玩家接口(t[1])
        if P then
            local P2 = self:取玩家(t[2])
            if P2 then
                P:进入PK_携程(P2, 6)
            else
                --对手不在线
            end
        else
            --攻击方不在线
        end



    end
end


function 事件:整分处理(分钟, 小时, 星期)
    if _开启日[星期] then
        if _开启分[分钟] then

        end
    end
end

function 事件:整点处理(分钟, 小时, 星期)
    if _开启日[星期] then
        --self:刷出怪物()
    end
end

--=======================================================
local 对话 = [[每周一19:40-20:20可以找我传送至种族比武场!
menu
1|我要进入比武场
99|我就看看

]]
local 对话2 = [[你找我有什么事？
menu
2|我要离开
99|我就看看

]]



function 事件:NPC对话(玩家, i)
    if self.名称 == "天将" then
        return 对话
    else
        return 对话2
    end

end

function 事件:NPC菜单(玩家, i)
    if i == "1" then
        if self.进场开关 then
            --进场条件限制
            self.进场数据[玩家.nid] = { 积分 = 0, 战斗=false,准备 = false, 胜利 = 0, 失败 = 0, 连胜 = 0, 匹配积分 = 0 }


            local id = (玩家.种族 + 2) * 10000 + 1197
            玩家:切换地图(id, 75, 53)
        else
            return "当前非活动时间"
        end
    elseif i == "2" then
        self.进场数据[玩家.nid] = nil
        玩家:切换地图(101529, 258, 131)



    end
end

--===============================================

function 事件:战斗结束(玩家, 胜负,n)
    
    print(玩家, 胜负,n)

end








return 事件
