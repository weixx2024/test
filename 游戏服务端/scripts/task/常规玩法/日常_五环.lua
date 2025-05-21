local 任务 = {
    名称 = '日常_五环',
    别名 = '五环',
    类型 = '常规玩法',
    飞行限制 = true
}

function 任务:任务初始化()
    if not self.未完成 then
        self.未完成 = { 1, 2, 3, 4, 5 }
        self.已完成 = {}
    end
end

--#G#u#[1001|202|196|$杜老板#]#u

local _任务详情 = {

    '帮%s的替身干掉位于长安城东(176,211)#G%s#W。(剩余%d分钟)', --1模拟新人过称
    '帮%s的替身到%s#W找#G%s#W问个清楚。(剩余%d分钟)', --2惩罚游戏骗子 大唐边境（坐标随机）
    '到%s#W处罚欺负新人的#G%s#W。(剩余%d分钟)', --3帮新人出气 大唐境内（坐标随机）
    '#G%s#W在%s遇到了麻烦,快去帮助他。(剩余%d分钟)', --4，帮新人找装备 大雁塔二层（坐标随机）
    '到%s找#G%s#W替%s的替身讨回个公道。(剩余%d分钟)', --5，惩罚盗号贼东海渔村（坐标随机）
}

local _最后对话 = {

    '帮#G%s(ID:%s)#W的替身干掉位于长安城东(176,211)的食婴鬼手下的手下。与该ID真实玩家组队完成任务可获得奖加成。', --1模拟新人过称
    '帮#G%s(ID:%s)#W的替身到%s#W找#G惯骗#W问个清楚。与该ID真实玩家组队完成任务可获得奖加成', --2惩罚游戏骗子
    '帮#G%s(ID:%s)#W的替身到%s#W处罚欺负新人的#GPK狂#W。与该ID真实玩家组队完成任务可获得奖加成', --帮新人出气
    '#G%s(ID:%s)#W的替身#W在%s遇到了麻烦,快去帮助他。与该ID真实玩家组队完成任务可获得奖加成', --4，帮新人找装备 大雁塔二层（坐标随机）
    '到%s找#G盗号贼#W替#G%s(ID:%s)#W的替身讨回个公道。与该ID真实玩家组队完成任务可获得奖加成',
}

function 任务:取最后对话(玩家)
    if self.分类 == 1 then
        return _最后对话[1]:format(self.替身名称, self.替身id)
    elseif self.分类 == 2 then
        return _最后对话[2]:format(self.替身名称, self.替身id, self.位置)
    elseif self.分类 == 3 then
        return _最后对话[3]:format(self.替身名称, self.替身id, self.位置)
    elseif self.分类 == 4 then
        return _最后对话[4]:format(self.替身名称, self.替身id, self.位置)
    elseif self.分类 == 5 then
        return _最后对话[5]:format(self.位置, self.替身名称, self.替身id)
    end
end

function 任务:任务取详情(玩家)
    if self.分类 == 1 then
        return _任务详情[1]:format(self.替身名称, self.寻路, (self.时间 - os.time()) // 60)
    elseif self.分类 == 2 then
        return _任务详情[2]:format(self.替身名称, self.位置, self.寻路, (self.时间 - os.time()) // 60)
    elseif self.分类 == 3 then
        return _任务详情[3]:format(self.位置, self.寻路, (self.时间 - os.time()) // 60)
    elseif self.分类 == 4 then
        return _任务详情[4]:format(self.寻路, self.位置, (self.时间 - os.time()) // 60)
    elseif self.分类 == 5 then
        return _任务详情[5]:format(self.位置, self.寻路, self.替身名称, (self.时间 - os.time()) // 60)
    end
end

function 任务:任务更新(sec, 玩家)
    if self.时间 <= sec then
        local map = 玩家:取地图(self.MAP)
        if map and self.NPC then
            map:删除NPC(self.NPC)
        end
        self:删除()
    end
end

function 任务:任务取消(玩家)
    local map = 玩家:取地图(self.MAP)
    if map and self.NPC then
        map:删除NPC(self.NPC)
    end
    self:删除()
end

function 任务:添加任务(玩家)
    self.时间 = os.time() + 60 * 60
    local nid = 取随机玩家(玩家.nid)
    if not nid then
        self.替身名称 = "李冰冰"
        self.替身id = 20000000
        self.替身外形 = 6593
    else
        local P = 玩家:取玩家(nid)
        if P then
            self.替身名称 = P.名称
            self.替身id = P.id
            self.替身nid = nid
            self.替身外形 = P.原形 or 1
            P.接口:提示窗口("#Y恭喜您幸运被玩家#G%s#Y抽到了5环任务，快去云游大师和小伙伴集合吧"
            , 玩家.名称)
        else
            self.替身名称 = "李冰冰"
            self.替身id = 20000000
            self.替身外形 = 6593
        end
    end
    local s = math.random(#self.未完成)
    self.分类 = self.未完成[s]
    table.remove(self.未完成, s)




    if self.分类 ~= 1 then
        self:生成怪物(玩家)
    else
        self.寻路 = "#u#[1193|176|211|$食婴鬼手下的手下#]#u"
    end
    self.最后对话 = self:取最后对话(玩家)
    玩家:添加任务(self)
    return true
end

function 任务:任务上线(玩家)

end

local _地图 = {
    1173,
    1173, --2惩罚游戏骗子 大唐边境（坐标随机）
    1110, --3帮新人出气 大唐境内（坐标随机）
    1005, --4，帮新人找装备 大雁塔二层（坐标随机）
    1208, --5，惩罚盗号贼东海渔村（坐标随机）

}

function 任务:生成怪物(玩家)
    local map = 玩家:取地图(_地图[self.分类])
    if not map then
        return
    end
    self.怪名 = "惯骗"
    self.怪物外形 = math.random(16)
    if self.分类 == 3 then
        self.怪名 = "PK狂"
        self.怪物外形 = math.random(40, 45)
    elseif self.分类 == 4 then
        self.怪名 = self.替身名称 .. "的替身"
        self.怪物外形 = self.替身外形
    elseif self.分类 == 5 then
        self.怪名 = "盗号贼"
        self.怪物外形 = math.random(16)
    end
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.寻路 = string.format('#u#[%s|%s|%s|$%s#]#u', map.id, X, Y, self.怪名) --#G#u#[1001|202|196|$杜老板#]#u
    self.时间 = os.time() + 60 * 60
    self.NPC =
        map:添加NPC {
            -- 队伍 = self.队伍,
            --  人数 = #self.队伍,
            名称 = self.怪名,
            时长 = 3600,
            外形 = self.怪物外形,
            脚本 = 'scripts/task/常规玩法/日常_五环.lua',
            时间 = self.时间,
            分类 = self.分类,
            X = X,
            Y = Y,
            来源 = self
        }
    self.MAP = map.id
    -- self.x = X
    -- self.y = Y
    return true
end

function 任务:完成(玩家)
    self.已完成[self.分类] = true
    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
    local wc = true
    for i = 1, 5, 1 do
        if not self.已完成[i] then
            wc = false
            break
        end
    end
    if self.替身nid then
        local P = 玩家:取玩家(self.替身nid)
        if P then
            if 玩家:是否队友(P) then
                P.接口:添加物品({ 生成物品 { 名称 = '蟠桃', 数量 = 1 } })
            end
        end
    end
    self:掉落包(玩家)
    if wc then
        self:删除()
    else
        local s = math.random(#self.未完成)
        self.分类 = self.未完成[s]
        table.remove(self.未完成, s)
        if self.分类 ~= 1 then
            self:生成怪物(玩家)
        else
            self.寻路 = "#u#[1193|176|211|$食婴鬼手下的手下#]#u"
        end
        self.最后对话 = self:取最后对话(玩家)
        玩家:最后对话(self.最后对话)
    end
end

local _掉落 = {
    {
        几率 = 30,
        名称 = '蟠桃王',
        数量 = 1,
        广播 = '#c00FFFF恭喜玩家#C%s#c00FFFF完成5环任务，获得了一个#G#m(%s)[%s]#m#n#c00FFFF#89运气爆棚！'
    },
    { 几率 = 50, 名称 = '补天神石', 数量 = 1 },
    { 几率 = 100, 名称 = '盘古精铁', 数量 = 1 },
    { 几率 = 500, 名称 = '天外飞石', 数量 = 1 },
    { 几率 = 800, 名称 = '千年寒铁', 数量 = 1 },
}

function 任务:掉落包(玩家)
    local 银子 = 2000000
    玩家:添加银子(银子, "五环")
    玩家:添加仙玉(50)
    for i, v in ipairs(_掉落) do
        if math.random(1000) <= v.几率 then
            local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数 }
            if r then
                玩家:添加物品({ r })
                if v.广播 then
                    玩家:发送系统(v.广播, 玩家.名称, r.nid, r.名称)
                end
                break
            end
        end
    end
end

--===============================================

local 对话 = {
    [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧#126
2|我认错人了#76
]], --食婴鬼手下的手下
    [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧#126
2|我认错人了#76
]], --骗子
    [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧#126
2|我认错人了#76
]], --PK狂
    [[我在这里练级,打了好久都打不过夜叉和猪怪#54你有没3-10级装备送我一件嘛#17(直接将装备ALT+G给予我就好了)

]], --要装备

    [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧#126
2|我认错人了#76
]], --盗号者

}


function 任务:NPC对话(玩家, NPC)
    local r = 玩家:取任务("日常_五环")
    if r and r.分类 and r.NPC == NPC.nid then
        return 对话[r.分类]
    end
end

function 任务:NPC菜单(玩家, i, NPC)
    local r = 玩家:取任务("日常_五环")
    if r and r.分类 and r.NPC == NPC.nid then
        if i == '1' then
            local s = 玩家:进入战斗('scripts/task/常规玩法/日常_五环.lua', self)
            if s then
                r:完成(玩家)
            end
        end
    end
end

function 任务:NPC给予(玩家, cash, items)
    local r = 玩家:取任务("日常_五环")
    if r and r.分类 and r.NPC == self.nid then
        if r.分类 == 4 then
            if items[1] and items[1].是否装备 and items[1].级别 >= 3 and items[1].级别 <= 10 then --
                items[1]:接受(1)
                r:完成(玩家)
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    local r = 玩家:取任务("日常_五环")
    if r then
        if r.NPC == NPC.nid or (r.分类 == 1 and NPC.名称 == "食婴鬼手下的手下") then
            local s = 玩家:进入战斗('scripts/task/常规玩法/日常_五环.lua', NPC)
            if s then
                r:完成(玩家)
            end
        end
    end
end

--===============================================


function 任务:战斗初始化(玩家, NPC)
    local r = 玩家:取任务("日常_五环")
    local 等级 = 玩家.等级
    local 转生 = 玩家.转生

    if r then
        local 怪物属性 = {
            外形 = NPC.外形,
            名称 = NPC.名称,
            等级 = 等级,
            气血 = 5000 + 等级 * 600 + 转生 * 200000,
            魔法 = 50000,
            攻击 = 200 + 等级 * 10 + 转生 * 80,
            速度 = 10 + 等级 + 转生 * 20,
            抗性 = {
                抗混乱 = 30,
                抗昏睡 = 30,
                物理吸收 = 20,

            },
            技能 = {
                { 名称 = "借刀杀人", 熟练度 = 10000 },
                { 名称 = "兽王之力", 熟练度 = 10000 },
                { 名称 = "魔神护体", 熟练度 = 10000 },
            },
            施法几率 = 50,
            是否消失 = false,
            --内丹 = { '乘风破浪' }
        }


        self:加入敌方(1, 生成战斗怪物(怪物属性))
    end
end

function 任务:战斗回合开始(dt)

end

function 任务:战斗结束(s)

end

return 任务
