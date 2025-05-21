local NPC = {}
local 对话 = [[
前段时间一群小神兽下凡帮助有缘人，如果能历经磨难修成正果便可在此飞升成真正的神兽！要是您有神兽我可以帮你神兽飞升！
menu
1|我的神兽需要飞升
2|第三次飞升初值点选择
3|给神兽更换抗性
4|给我的神兽更换造型
5|给我的神兽学习技能
6|我有神兽碎片，我来换神兽(90个)
7|我有珍稀神兽碎片碎片，我来兑换(500个)
8|我有鎏金碎片，我来换鎏金宝鉴(999个)
9|我只是路过看看
]]
local 对话2 = [[
飞升第三次可以选择一种属性+60点初值！你要选择哪一种呢？？
menu
1|气血初值
2|攻击初值
3|法力初值
4|速度初值
]]

local 对话3 = [[
旧版神兽第二次飞升可以选择改变造型,是否确定要改变造型呢？？
menu
1|我要改变造型
2|我才不要变呢
3|我先想想
]]

local 对话4 = [[
更换神兽造型（只更换造型不改变天生技能及五行）
menu
1|原始造型
2|一次飞升造型
3|二次飞升造型
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

local _初值 = { ["1"] = "初血", ["2"] = "初攻", ["3"] = "初法", ["4"] = "初敏", }

local _可变形 = {
    {
        超级蝙蝠 = 2011, --超级蝙蝠  蝴蝶仙子
        超级毒蛇 = 2070, --超级毒蛇  蛟龙
        超级飞鱼 = 2071, --超级飞鱼 凤凰
        超级蜘蛛 = 2065, --超级蜘蛛  蜘蛛精
        超级海龟 = 2064, --超级海龟  龟丞相
        超级蟾蜍 = 2023, --超级蟾蜍 雷鸟人

    },
    {
        超级蝙蝠 = 2109, --超级蝙蝠  剑精灵
        超级毒蛇 = 2107, --超级毒蛇  罗刹鬼姬
        超级飞鱼 = 2107, --超级飞鱼 罗刹鬼姬
        超级蜘蛛 = 2106, --超级蜘蛛  狮蝎
        超级海龟 = 2108, --超级海龟  雷兽
        超级蟾蜍 = 2110, --超级蟾蜍 哥俩好
    }
}

local _外形表 = {
    {
        { 名称 = '超级蝙蝠', id = 2030 },
        { 名称 = '蝴蝶仙子', id = 2011 },
        { 名称 = '剑精灵', id = 2109 },
    },
    {
        { 名称 = '超级毒蛇', id = 2031 },
        { 名称 = '蛟龙', id = 2070 },
        { 名称 = '罗刹鬼姬', id = 2107 },
    },
    {
        { 名称 = '超级飞鱼', id = 2032 },
        { 名称 = '凤凰', id = 2071 },
        { 名称 = '罗刹鬼姬', id = 2107 },
    },
    {
        { 名称 = '超级蜘蛛', id = 2035 },
        { 名称 = '蜘蛛精', id = 2065 },
        { 名称 = '狮蝎', id = 2106 },
    },
    {
        { 名称 = '超级海龟', id = 2036 },
        { 名称 = '龟丞相', id = 2064 },
        { 名称 = '雷兽', id = 2108 },
    },
    {
        { 名称 = '超级蟾蜍', id = 2037 },
        { 名称 = '雷鸟人', id = 2023 },
        { 名称 = '哥俩好', id = 2110 },
    }
}

local _可飞升类型 = {
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
}


local _可领悟类型 = {
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
}

local _飞升 = {
    { lv = 50, zs = 0, 次数 = 1 },
    { lv = 100, zs = 1, 次数 = 2 },
    { lv = 120, zs = 2, 次数 = 3 },
}
function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:取参战召唤兽()
        if not r then
            return "请先将要飞升的召唤兽设置参战！"
        end

        if not _可飞升类型[r.类型] then
            return "只有神兽才可以飞升!"
        end

        if r.飞升 >= 3 then
            return "一只召唤兽最多只能飞升3次!"
        end

        local v = _飞升[r.飞升 + 1]
        if r.转生 < v.zs and r.等级 < v.lv then
            return "下次一次飞升需要 " .. v.zs .. "转" .. v.lv .. "级！"
        end

        if r.飞升 == 0 then --第一次飞升
            local wx = _可变形[1][r.原名]
            r:飞升处理(nil, wx)
            return string.format("你的#G%s#W实力又精进了许多", r.名称)
        elseif r.飞升 == 1 then --第二次飞升
            local wx = _可变形[2][r.原名]
            local mx
            if wx then
                local cs = 玩家:选择窗口(对话3)
                if cs == "1" then --改变外形
                    mx = wx
                elseif cs == "3" then
                    return "那等你想好了再来找我吧"
                end
            end
            r:飞升处理(nil, mx)
            return string.format("你的#G%s#W实力又精进了许多", r.名称)
        elseif r.飞升 == 2 then --第三次飞升
            local cs = 玩家:选择窗口(对话2)
            if cs and _初值[cs] then
                if not 玩家:扣除银子(1000000) then
                    return "需要500W的费用,没有钱我很难为你做事啊！#24"
                end
                r:飞升处理(_初值[cs])
                return string.format("你的#G%s#W实力又精进了许多", r.名称)
            end
        end
    elseif i == '2' then
        local r = 玩家:取参战召唤兽()
        if not r then
            return "请先将要修改飞升初值点的召唤兽设置参战！"
        end

        if not _可飞升类型[r.类型] then
            return "只有神兽才可以飞升!"
        end

        if r.飞升 ~= 3 then
            return "你的召唤兽并没有飞升3次!"
        end

        local cs = 玩家:选择窗口(对话2)
        if cs and _初值[cs] then
            if not 玩家:扣除银子(1000000) then
                return "修改飞升初值点需要100W的费用,没有钱我很难为你做事啊！#24"
            end
            r:神兽更换飞升初值(_初值[cs])
            return string.format("你的#G%s#W初值发生了改变", r.名称)
        end
    elseif i == '3' then
    elseif i == '4' then
        local r = 玩家:取参战召唤兽()
        if not r then
            return "请先将要修改造型的召唤兽设置参战！"
        end

        if not _可飞升类型[r.类型] then
            return "只有神兽才可以修改造型!"
        end
        local 造型表
        local zx = 玩家:选择窗口(对话4)
        if zx then
            zx = tonumber(zx)
            if r.飞升 < zx then
                return '你的神兽还没有解锁这个造型!'
            end

            for k, v in pairs(_外形表) do
                for _k, _v in pairs(v) do
                    if r.原名 == _v.名称 then
                        造型表 = v
                    end
                end
            end

            if not 造型表 then
                return "只有旧版神兽才可以更换造型!"
            end

            if not 玩家:扣除银子(1000000) then
                return "修改造型需要100W的费用,没有钱我很难为你做事啊！#24"
            end

            r:神兽更换造型(造型表[zx].id, true)
            return string.format("你的#G%s#W造型发生了改变", r.名称)
        end
elseif i == '5' then
    local 召唤兽列表 = 玩家:取所有召唤兽()
    local 对话 = '领悟神兽技能需要消耗200W亲密，请选择你要领悟的召唤兽:#G\nmenu\n'
    for n, v in ipairs(召唤兽列表) do
        对话 = 对话 .. v.nid .. '|' .. v.名称 .. "\n"
    end
    local 玩家选择 = 玩家:选择窗口(对话)
    if 玩家选择 then
        local 召唤兽 = 玩家:取指定召唤兽(玩家选择)
        if 召唤兽 then
            if not _可领悟类型[召唤兽.类型] then
                return "该召唤兽无法领悟神兽技能!"
            end
            if 召唤兽.亲密 >= 500000 then
                return 召唤兽:领悟神兽技能()
            else
                return "领悟神兽技能需要消耗50W亲密"
            end
        else
            return "你没有这样的召唤兽"
        end
    else
        return "你取消了选择。"
    end

    elseif i == '6' then
        if not 玩家:取召唤_携带上限() then
            玩家:提示窗口('#Y你的召唤兽携带数量不足！')
            return
        end

        local r = 玩家:取物品是否存在("神兽碎片")
        if r then
            if r.数量 < 90 then
                return "你身上没有足够多的神兽碎片"
            end

            local 掉落包 = 取掉落包('兑换', '神兽')
            if 掉落包 then
                local 召唤 = 随机物品(掉落包)
                if 召唤 then
                    if 玩家:添加召唤(生成召唤 { 名称 = 召唤.名称 }) then
                        r:减少(90)
                    end
                end
            end
        else
            return "你身上没有足够多的神兽碎片"
        end


		elseif i == '7' then
        if not 玩家:取包裹空位() then
            玩家:提示窗口('#Y 你的包裹已经满了！')
            return
        end
        local r = 玩家:取物品是否存在("珍稀神兽碎片")
        if r then
            if r.数量 < 500 then
                return "你身上没有足够多的珍稀神兽碎片"
            end
            local wp = 生成物品 { 名称 = "珍稀神兽自选卡", 数量 = 1 }
            if 玩家:添加物品({ wp }) then
                r:减少(500)
				玩家:发送系统("#R%s#C在神兽大将处成功兑换了一个#G#m(%s)[%s]#m#n#89#C，可喜可贺！", 玩家.名称, wp.nid, wp.名称)
            end
        else
            return "你身上没有足够多的鎏金碎片"
        end

		elseif i == '8' then
        if not 玩家:取包裹空位() then
            玩家:提示窗口('#Y 你的包裹已经满了！')
            return
        end
        local r = 玩家:取物品是否存在("鎏金碎片")
        if r then
            if r.数量 < 999 then
                return "你身上没有足够多的鎏金碎片"
            end
            local wp = 生成物品 { 名称 = "鎏金宝鉴", 数量 = 1 }
            if 玩家:添加物品({ wp }) then
                r:减少(999)
				玩家:发送系统("#R%s#C在神兽大将处成功兑换了一个#G#m(%s)[%s]#m#n#89#C，可喜可贺！", 玩家.名称, wp.nid, wp.名称)
            end
        else
            return "你身上没有足够多的鎏金碎片"
        end

    end
end


return NPC

