local 任务 = {
    名称 = '日常_帮派任务',
    别名 = '帮派任务',
    类型 = '常规玩法'
}

function 任务:任务初始化()
    --')
end

-- if 任务数据[任务id].分类==1 then
--     说明={"帮派任务",format("找到#G/%s#W/并交给#G/帮派总管。",任务数据[任务id].物品),温馨提示}
-- elseif 任务数据[任务id].分类==2 then
--   if 任务数据[任务id].完成==true then
--     说明={"帮派任务",format("杂草已经清理干净了，回去告诉#G/帮派主管#W/吧。"),温馨提示}
--   else
--     说明={"帮派任务",format("帮里很久没有清理杂草了,我给你一把锄头,你到帮里清理一下杂草。"),温馨提示}
--   end

-- elseif 任务数据[任务id].分类==3 then
--     说明={"帮派任务",format("帮里需要一批看门的召唤兽,你去给我抓一只#G/%s#W/来",任务数据[任务id].召唤兽),温馨提示}
-- elseif 任务数据[任务id].分类==4 then
--     说明={"帮派任务",format("最近帮里人员增加比较多,急需装备,你去给我找一件#G/%s#W/来",任务数据[任务id].装备),温馨提示}
-- elseif 任务数据[任务id].分类==5 then
--     说明={"帮派任务",format("去长安酒店(长安110，247),洛阳酒店(洛阳18,192),傲来酒店,长寿酒店的#G/酒店老板#W/打听一下价格。"),温馨提示}
-- elseif 任务数据[任务id].分类==6 then
--   if 任务数据[任务id].完成==true then
--     说明={"帮派任务",format("银票已经收回来了，回去交给#G/帮派主管#W/吧。"),温馨提示}
--   else
--     说明={"帮派任务",format("长寿药店老板欠我们帮的银子还没有还,找#Y/长寿村#W/的#G/药店老板#W/收取银票"),温馨提示}
--   end
-- elseif 任务数据[任务id].分类==7 then
--     说明={"帮派任务",format("去#Y/洛阳城(392,207)#W/击败无名侠女，拿回锦盒。"),温馨提示}
-- elseif 任务数据[任务id].分类==8 then
--   if 任务数据[任务id].完成==true then
--     说明={"帮派任务",format("妖怪已经收击退，回去交给#G/帮派主管#W/吧。"),温馨提示}
--   else
--     说明={"帮派任务",format("听说#Y/%s#W/经常有骚扰路人的妖怪,你去把它们干掉。（遇敌）",任务数据[任务id].地图名称),温馨提示}
--   end

local _详情 = {
    '找到#G%s#W并交给#G帮派总管#W。#W(当前第#R%s#W次，剩余#R%d#W分钟)',
    '帮里很久没有清理杂草了,我给你一把锄头,你到帮里#G%s#W附近清理一下杂草。#W(当前第#R%s#W次，剩余#R%d#W分钟)',
    '帮里需要一批看门的召唤兽,你去给我抓一只#G%s#W来。#W(当前第#R%s#W次，剩余#R%d#W分钟)',
    '最近帮里人员增加比较多,急需装备,你去给我找一件#G%s#W来。#W(当前第#R%s#W次，剩余#R%d#W分钟)',
    '去长安酒店(长安110，247),洛阳酒店(洛阳18,192),傲来酒店,长寿酒店的#G酒店老板#W打听一下价格。#W(当前第#R%s#W次，剩余#R%d#W分钟)',
    '长寿药店老板欠我们帮的银子还没有还,找#Y长寿村#W的#G药店老板#W收取银票。#W(当前第#R%s#W次，剩余#R%d#W分钟)',
    '去#Y/洛阳城(392,207)#W/击败无名侠女，拿回锦盒。#W(当前第#R%s#W次，剩余#R%d#W分钟)',
    '听说#Y/%s#W/经常有骚扰路人的妖怪,你去把它们干掉（遇敌）。#W(当前第#R%s#W次，剩余#R%d#W分钟)',
}
function 任务:任务取详情(玩家)
    if self.分类 == 1 then
        return string.format(_详情[self.分类], self.物品, 玩家:取活动限制次数('帮派任务'),
            (self.时间 - os.time()) // 60)
    elseif self.分类 == 2 then
        return string.format(_详情[self.分类], self.位置, 玩家:取活动限制次数('帮派任务'),
            (self.时间 - os.time()) // 60)
    end

    -- return string.format(_详情[self.分类], self.位置, 玩家.其它.师门次数, (self.时间 - os.time()) // 60)
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

function 任务:添加任务(玩家) --1寻药
    self.时间 = os.time() + 1800
    self.分类 = 1 --math.random(2)
    if math.random(100) < 20 then
        self.分类 = 2
    end



    if self.分类 == 1 then
        return self:添加寻药任务(玩家)
    elseif self.分类 == 2 then
        return self:添加除草任务(玩家)
    end
    return true
end

_药品 = {
    "金针", "黑山药", "七叶莲", "八角莲叶", "水黄莲",
    "月见草", "凤凰尾", "紫丹罗", "百色花", "灵芝", "佛手", "羊脂仙露",
    "旋复花", "曼陀罗花", "九转龙涎香", "天龙水", "鬼切草", "仙狐涎", "白药",
    "和合散", "大还丹", "黑玉断续膏", "羚羊角", "紫石英", "百兽灵丸",
    "丹桂丸", "归神散", "风水混元丹", "定神香", "还灵水", "灵翼天香"
}
function 任务:添加寻药任务(玩家) --1寻药
    self.物品 = _药品[math.random(#_药品)]
    玩家:添加任务(self)
    self.最后对话 = "速速前去寻找一份" .. self.物品 .. "交给我,我有急用必定重谢！"
    return true
end

function 任务:添加除草任务(玩家) --1除草
    local map = 玩家:取帮派地图()
    if not map then
        return
    end
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.位置 = string.format('(%d,%d)', X, Y)
    self.x, self.y = X, Y
    self.mapid = map.id
    if 玩家:添加物品({ 生成物品 { 名称 = '锄头', 数量 = 1 } }) then
        玩家:添加任务(self)
        self.进度 = 1
        self.除草 = false
        self.最后对话 = "帮里很久没有清理杂草了,我给你一把锄头,你到帮里清理一下杂草。"
    else
        self.最后对话 = "你身上装不下我要给你的锄头。"
    end
    return true
end

function 任务:开始除草(玩家)
    local map = 玩家:取当前地图()
    if not map then
        return "#Y未知地图"
    end
    if map.id ~= self.mapid then
        return "#Y这里不是帮派里哦！"
    end
    if math.abs(self.x - 玩家.X) < 5 and math.abs(self.y - 玩家.Y) < 5 then
        self.进度 = self.进度 + 1
        if math.random(3, 5) <= self.进度 then
            self:完成(玩家)
            玩家:常规提示("#Y恭喜你！杂货已经清理干净了。")
            return true
        end

        local X, Y = map:取随机坐标()
        if not X then
            return "#Y经过你的不懈努力，帮派里的杂草似乎变少了"
        end
        self.x, self.y = X, Y
        self.位置 = string.format('(%d,%d)', X, Y)
        return "#Y经过你的不懈努力，帮派里的杂草似乎变少了"
    else
        return "#Y此处已经没有杂草了,去别去去看看"
    end
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_帮派任务')
    if r then
        self:删除()
        self:掉落包(玩家)
    end
end

local _掉落 = {
    { 几率 = 10, 名称 = '亲密丹', 数量 = 1, 参数 = 1000, 广播 = true },
    { 几率 = 100, 名称 = '千年寒铁', 数量 = 1 },
    { 几率 = 100, 名称 = '天外飞石', 数量 = 1 },
    { 几率 = 100, 名称 = '盘古精铁', 数量 = 1 },
}
function 任务:掉落包(玩家)
    local 银子 = 9000
    local 经验 = 60000
    local 帮派成就 = 1000
    local 帮派建设度 = 1000000
    玩家:添加任务经验(经验, "帮派")
    玩家:添加师贡(银子, "帮派")
    玩家:添加参战召唤兽亲密度(300, "帮派")
    玩家:添加帮派成就(帮派成就)
    玩家:添加帮派建设度(帮派建设度)
    for i, v in ipairs(_掉落) do
        if math.random(1000) <= v.几率 then
            local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数 }
            if r then
                玩家:添加物品({ r })
                if v.广播 then
                    玩家:发送系统('#C%s在帮派任务中获得了什么#G#m(%s)[%s]#m#n', 玩家.名称, r.nid,
                        r.名称)
                end
                break
            end
        end
    end
end

--===============================================

local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]

function 任务:NPC对话(玩家, NPC)

end

function 任务:NPC菜单(玩家, i, NPC)

end

function 任务:任务攻击事件(玩家, NPC)

end

-- function NPC:任务NPC给予(玩家,cash,items)
--     return '你给我什么东西？'
-- end


--===============================================

function 任务:战斗初始化(玩家, NPC)
    local r = 玩家:取任务('日常_师门任务')
    if r then
        local 怪物属性 = {
            外形 = NPC.外形,
            名称 = NPC.名称,
            等级 = 玩家.等级,
            气血 = 26542,
            魔法 = 18000,
            攻击 = 1,
            速度 = 1,
            抗性 = {},
        }
        self:加入敌方(1, 生成战斗怪物(怪物属性))

        if NPC.名称 ~= "密探" then
            local n = 玩家.种族 * 1000 + 玩家.性别
            local sx = _密探外形[n]
            for i = 2, 3 do
                怪物属性 = {
                    外形 = sx[math.random(#sx)],
                    名称 = "手下",
                    等级 = 玩家.等级,
                    气血 = 26542,
                    魔法 = 18000,
                    攻击 = 1,
                    速度 = 1,
                    抗性 = {},
                }
                self:加入敌方(i, 生成战斗怪物(怪物属性))
            end
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)

end

return 任务
