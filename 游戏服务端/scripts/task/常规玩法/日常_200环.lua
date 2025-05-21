local 任务 = {
    名称 = '日常_200环',
    别名 = '200环',
    类型 = '常规玩法',
    -- 是否可取消 = false
}

function 任务:任务初始化()
    --')
end

local _详情 = {

}



local _寻人对话 = {
    "好久没见#G%s#Y，不知道现在还好吗?如果你见到了就代我问个好。"
}


local _寻物对话 = {
    '#G%s#Y上次说丢了#G%s#Y，其实是被我"借用"了一下，看他找得这么着急，你就帮我送回去给他吧。',
    '#G%s#Y好像正在找#R1个#G%s#Y，看你也是一个好心人,能不能劳驾给帮帮忙~',



}

local _杀敌对话 = {
    '#G%s#Y正在寻找一个叫做#G%s#Y的妖怪，我最近在蟠桃园#W看到过，你去把它杀了，然后去告诉#G%s#Y会很高兴的'
}

function 任务:剩余时间()
    local h = (self.时间 - os.time()) // 60 // 60
    local f = (self.时间 - os.time() - h * 3600) // 60
    return string.format("%s小时%s分钟", h, f)
end

function 任务:已用时间()
    local h = (self.时间 - os.time()) // 60 // 60
    local f = (self.时间 - os.time() - h * 3600) // 60
    h = 23 - h
    f = 60 - f
    return string.format("%s小时%s分钟", h, f)
end

-- function 任务:任务取详情(玩家)
--     if self.分类 == 1 then
--         return string.format("#Y任务目的：#r" .. _寻人对话[self.提示] ..
--             "#r#Y(剩余时间:%s)#r#Y当前环数:%s/200#r#Y任务链耗时:%s"
--             ,
--             self.交付人.名称
--             , self:剩余时间(), self.进度, self:已用时间())

--     elseif self.分类 == 2 then


--         return string.format("#Y任务目的：#r" .. _寻物对话[self.提示] ..
--             "#r#Y(剩余时间:%s)#r#Y当前环数:%s/200#r#Y任务链耗时:%s"
--             ,
--             self.交付人.名称
--             , self.物品需求
--             , self:剩余时间(), self.进度, self:已用时间())

--     elseif self.分类 == 3 then

--         return string.format("#Y任务目的：#r" .. _杀敌对话[self.提示] ..
--             "#r#Y(剩余时间:%s)#r#Y当前环数:%s/200#r#Y任务链耗时:%s"
--             ,
--             self.交付人.名称
--             , self.敌人寻路, self.交付人.名称
--             , self:剩余时间(), self.进度, self:已用时间())
--     end
-- end

function 任务:任务取详情(玩家)
    if self.分类 == 1 then
        return string.format("#Y任务目的：#r" .. _寻人对话[self.提示] ..
            "#r#Y(剩余时间:%s)#r#Y当前环数:%s/200#r#Y任务链耗时:%s"
            ,
            string.format("#u#[%d|%d|%d|$%s#]#u", self.交付人.id, self.交付人.x, self.交付人.y, self.交付人.名称)
            , self:剩余时间(), self.进度, self:已用时间())
    elseif self.分类 == 2 then
        return string.format("#Y任务目的：#r" .. _寻物对话[self.提示] ..
            "#r#Y(剩余时间:%s)#r#Y当前环数:%s/200#r#Y任务链耗时:%s"
            ,
            string.format("#u#[%d|%d|%d|$%s#]#u", self.交付人.id, self.交付人.x, self.交付人.y, self.交付人.名称)
            , self.物品需求
            , self:剩余时间(), self.进度, self:已用时间())
    elseif self.分类 == 3 then
        return string.format("#Y任务目的：#r" .. _杀敌对话[self.提示] ..
            "#r#Y(剩余时间:%s)#r#Y当前环数:%s/200#r#Y任务链耗时:%s"
            ,
            string.format("#u#[%d|%d|%d|$%s#]#u", self.交付人.id, self.交付人.x, self.交付人.y, self.交付人.名称)
            , self.敌人寻路, self.交付人.名称
            , self:剩余时间(), self.进度, self:已用时间())
    end
end

function 任务:任务取消(玩家)

end

function 任务:任务更新(sec, 玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
    end
end

-- local _地图 = { 1136, 101474, 1201, 1111, 1135, 1070, 1091, 1140,
--     1198, 1199, 101529, 101537, 101538, 101550, 1131, 1173,
--     101295, 101299, 1217, 101300, 1174, 1186, 101349, 101381,
--     1177, 1146, 1203, 1194, 1236, 1110, 1001, 1004, 1002, 1003,
--     1193, 1125, 1122, 1129, 101395, 1214, 1213, 1208, 1118, 1116,
--     1092, 1142
-- }
local _地图 = { 1001, 1236, 1070, 1092, 1110, 1194, 1140, 1142, 1091, 1193, 1173, 1217

}
function 任务:设置交付人(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    local t = map:取随机NPC()
    if not t then
        return
    end
    self.交付人 = { 名称 = t[1], nid = t[2], id = map.id, x = t[3], y = t[4] }
end

function 任务:添加任务(玩家)
    self.时间 = os.time() + 86400
    self.分类 = math.random(2)
    if math.random(100) < 20 then
        self.分类 = 3
    end
    if 玩家.转生 < 1 then
        return "领取该任务需要1转"
    end


    if self.分类 == 2 and not 玩家:取包裹空位() then
        return "你包裹满了 不能接收任务品"
    end
    if not 玩家:扣除体力(200) then
        return "领取该任务需要200点体力"
    end
    self.进度 = 0
    if self.分类 == 1 then --寻人
        self:添加寻人任务(玩家)
    elseif self.分类 == 2 then --寻物
        self:添加寻物任务(玩家)
    elseif self.分类 == 3 then --杀敌
        self:添加杀敌任务(玩家)
    end
    玩家:增加周限次数("200环")
    玩家:添加任务(self)
    return self.最后对话
end

function 任务:添加寻人任务(玩家)
    self:设置交付人(玩家)
    self.时间 = os.time() + 86400
    self.进度 = self.进度 + 1
    self.提示 = math.random(#_寻人对话)
    self.最后对话 = string.format(_寻人对话[self.提示], self.交付人.名称)
end

local _物品 = {
    '簪子', '布帽', '佛珠', '布衣', '布鞋', "金针", "风水混元丹",
    --  "黑山药", "七叶莲", "八角莲叶", "水黄莲",
    -- "月见草", "凤凰尾", "紫丹罗", "百色花", "灵芝", "佛手", "羊脂仙露",
    -- "旋复花", "曼陀罗花", "九转龙涎香", "天龙水", "鬼切草", "仙狐涎", "白药",
    -- "和合散", "大还丹", "黑玉断续膏", "羚羊角", "紫石英", "百兽灵丸",
    -- "丹桂丸", "归神散", "定神香", "还灵水", "灵翼天香"
}

function 任务:添加寻物任务(玩家)
    self:设置交付人(玩家)
    self.时间 = os.time() + 86400
    self.进度 = self.进度 + 1
    self.物品需求 = _物品[math.random(#_物品)]


    local r = 生成物品 { 名称 = self.物品需求, 禁止交易 = true, 任务物品 = true, 数量 = 1 }
    玩家:添加物品({ r })


    self.提示 = math.random(#_寻物对话)
    self.最后对话 = string.format(_寻物对话[self.提示], self.交付人.名称, self.物品需求)
end

local _敌人 = {
    "蟠桃神灵",
    "蟠桃凤凰",
    "蟠桃女娲"

}
function 任务:添加杀敌任务(玩家)
    self:设置交付人(玩家)
    self.进度 = self.进度 + 1
    self.时间 = os.time() + 86400
    self.敌人 = _敌人[math.random(#_敌人)]
    if self.敌人 == "蟠桃神灵" then
        self.敌人寻路 = "#u#[1217|39|82|$蟠桃神灵#]#u"
    elseif self.敌人 == "蟠桃凤凰" then
        self.敌人寻路 = "#u#[1217|29|37|$蟠桃凤凰#]#u"
    else
        self.敌人寻路 = "#u#[1217|119|50|$蟠桃女娲#]#u"
    end
    self.击杀 = false
    self.提示 = math.random(#_杀敌对话)
    self.最后对话 = string.format(_杀敌对话[self.提示], self.交付人.名称, self.敌人, self.交付人.名称)
end

local _药品 = { "修罗玉", "夜叉石", "玫瑰仙叶", "海蓝石", "仙鹿茸", "千年熊胆" }

function 任务:完成(玩家)
    if self.进度 >= 200 then
        self:掉落包(玩家)
        local r = 玩家:取任务("引导_200环")
        if r then
            r:完成(玩家)
        end
        self:删除()
        return
    end
    if not 玩家:取包裹空位() then
        玩家:提示窗口("#Y你包裹满了 不能接收任务品")
        return
    end
    self.分类 = math.random(2)
    if math.random(100) < 20 then
        self.分类 = 3
    end
    if self.分类 == 1 then --寻人
        self:添加寻人任务(玩家)
    elseif self.分类 == 2 then --寻物
        self:添加寻物任务(玩家)
    elseif self.分类 == 3 then --杀敌
        self:添加杀敌任务(玩家)
    end
    玩家:添加银子(math.floor(self.进度 * 200), "200环")
    玩家:添加仙玉(3)
    if math.random(100) < 10 then
        local r = 生成物品 { 名称 = _药品[math.random(#_药品)], 数量 = 5 }
        玩家:添加物品({ r })
    end
    return true
end

local _掉落 = {
    { 几率 = 50, 名称 = '高级藏宝图', 数量 = 1, 广播 = true },
    { 几率 = 100, 名称 = '帮派成就册', 参数 = 1000, 数量 = 3, 广播 = true },
    { 几率 = 200, 名称 = '五龙圣丹', 数量 = 10, 广播 = true },
    { 几率 = 500, 名称 = '盘古精铁', 数量 = 1, 广播 = true },
    { 几率 = 400, 名称 = '补天神石', 数量 = 1, 广播 = true },
    { 几率 = 300, 名称 = '孔雀明王羽', 数量 = 10, 广播 = true },
}

function 任务:掉落包(玩家)
    玩家:添加银子(math.floor(self.进度 * 200), "200环")
    local t = false
    while not t do
        for _, v in ipairs(_掉落) do
            if math.random(1000) <= v.几率 then
                t = v
                break
            end
        end
    end
    if t then
        local r = 生成物品 { 名称 = t.名称, 数量 = t.数量, 参数 = t.参数 }
        玩家:添加物品({ r })
        玩家:发送系统('#C%s#c00FFFF在200环任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励#42'
        , 玩家.名称, r.nid, r.名称)
    end
end

--===============================================
function 任务:任务NPC对话(玩家, NPC)
    if self.分类 == 1 then
        if 玩家.地图 == self.交付人.id and NPC.名称 == self.交付人.名称 then
            if self:完成(玩家) then
                NPC.台词 = self.最后对话
            end
        end
    elseif self.分类 == 3 then
        if 玩家.地图 == self.交付人.id and NPC.名称 == self.交付人.名称 then
            if self.击杀 then
                if self:完成(玩家) then
                    NPC.台词 = self.最后对话
                end
            end
        end
    end
end

function 任务:任务NPC菜单(玩家, i, NPC)

end

function 任务:任务攻击事件(玩家, NPC)
    if NPC then
        if self.分类 == 3 then
            if 玩家.地图 == 1217 and NPC.名称 == self.敌人 then
                if not self.击杀 then
                    local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_200环.lua', NPC)
                    if sf then
                        self.击杀 = true
                    end
                else
                    玩家:最后对话("你已经胜利了,去告诉#G" .. self.交付人.名称)
                end
            end
        end
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if self.分类 == 2 then
        if 玩家.地图 == self.交付人.id and NPC.名称 == self.交付人.名称 then
            if items[1] and items[1].名称 == self.物品需求 then --
                if items[1].数量 >= 1 then
                    if self:完成(玩家) then
                        items[1]:接受(1)
                        NPC.结束 = nil
                        NPC.台词 = self.最后对话
                    end
                end
            end
        end
    end
end

--===============================================






local _怪物技能 = { "蛇蝎美人", "反间之计", "催眠咒", "夺命勾魂", "妖之魔力", "飞砂走石",
    "地狱烈火", "雷霆霹雳", "龙卷雨击",
    "魔之飞步" }


local _小怪外形 = {
    蟠桃神灵 = 2055,
    蟠桃凤凰 = 2057,
    蟠桃女娲 = 2051,



}


function 任务:战斗初始化(玩家, NPC)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性 = {
        外形 = NPC.外形,
        名称 = NPC.名称,
        等级 = 等级,
        气血 = 50000, --12587 + 转生 * 10000 + 等级 * 100,
        魔法 = 12587 + 等级 * 150,
        攻击 = 132 + 转生 * 50 + 等级 * 5,
        速度 = 200,
        抗性 = {
            抗水 = -32,
            抗雷 = -32,
            抗火 = -32,
            抗风 = -
                32
        },
        技能 = { "追魂迷香", "情真意切", "追神摄魄", "瞌睡咒", "力神复苏", "莲步轻舞", "急速之魔",
            "乘风破浪", "天雷怒火", "日照光华", "龙腾水溅" },
        施法几率 = 50,
        是否消失 = false,
        --内丹 = { '乘风破浪' }
    }
    self:加入敌方(1, 生成战斗怪物(怪物属性))
    for i = 1, 4 do
        怪物属性 = {
            外形 = _小怪外形[NPC.名称] or 2055,
            名称 = "喽啰",
            等级 = 等级,
            气血 = 50000, --12587 + 转生 * 10000 + 等级 * 50
            魔法 = 12587 + 等级 * 150,
            攻击 = 72 + 转生 * 50 + 等级 * 5,
            速度 = 200,
            抗性 = {
                抗水 = -39,
                抗雷 = -39,
                抗火 = -39,
                抗风 = -39
            },
            技能 = { _怪物技能[math.random(#_怪物技能)] },
            施法几率 = 50,
            是否消失 = false,
        }

        local 怪物 = 生成战斗怪物(怪物属性)

        self:加入敌方(i + 1, 怪物)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)

end

return 任务
