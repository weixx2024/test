﻿-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-09-24 11:14:52
-- @Last Modified time  : 2024-11-03 11:31:52

local 事件 = {
    名称 = '地煞星',
    类型 = '挑战任务',
    是否打开 = true,
    是否可接任务 = true,
    开始时间 = os.time { year = 2022, month = 1, day = 1, hour = 0, min = 0, sec = 00 },
    结束时间 = os.time { year = 2099, month = 1, day = 1, hour = 0, min = 0, sec = 00 }
}

function 事件:事件初始化()
end

local _低级地煞星 = {
    -- 大唐边境、斧头帮、长寿村外、大雁塔5层、大雁塔6层
    { 名称 = '地劣星', 称谓 = '一星地煞', 外形 = 2, 等级 = 1, 数量 = 5, 地图 = { 1173, 1203, 1091, 1008, 1090 } },
    -- 傲来国、海底迷宫1-4层
    { 名称 = '地恶星', 称谓 = '二星地煞', 外形 = 2, 等级 = 2, 数量 = 5, 地图 = { 1092, 1118, 1119, 1120, 1121 } },
    -- 普陀山、地府迷宫1—4层
    { 名称 = '地囚星', 称谓 = '三星地煞', 外形 = 3, 等级 = 3, 数量 = 5, 地图 = { 1140, 1129, 1127, 1130, 1128 } },
    -- 北俱芦洲、龙窟1层、龙窟2层、凤巢1层、凤巢2层
    { 名称 = '地魔星', 称谓 = '四星地煞', 外形 = 6, 等级 = 4, 数量 = 5, 地图 = { 1174, 1177, 1178, 1186, 1187 } },
    -- 狮驼岭、龙窟3层、龙窟4层、凤巢3层、凤巢4层
    { 名称 = '地周星', 称谓 = '五星地煞', 外形 = 3, 等级 = 5, 数量 = 5, 地图 = { 1131, 1179, 1180, 1188, 1189 } },
    -- 御马监、龙窟5层、龙窟6层、凤巢5层、凤巢6层
    { 名称 = '地猖星', 称谓 = '六星地煞', 外形 = 4, 等级 = 6, 数量 = 5, 地图 = { 1199, 1181, 1182, 1190, 1191 } },
    -- 瑶池 蟠桃园后 龙窟7层 凤巢7层
    { 名称 = '地轴星', 称谓 = '七星地煞', 外形 = 6, 等级 = 7, 数量 = 5, 地图 = { 1201, 1217, 1183, 1192 } },
}

local _中级地煞星 = {
    -- 四圣庄
    { 名称 = '地威星', 称谓 = '八星地煞', 外形 = 5, 等级 = 8, 数量 = 5, 地图 = { 101295 } },
    -- 万寿山
    { 名称 = '地状星', 称谓 = '九星地煞', 外形 = 10, 等级 = 9, 数量 = 5, 地图 = { 101299 } },
    -- 白骨山
    { 名称 = '地藏星', 称谓 = '十星地煞', 外形 = 11, 等级 = 10, 数量 = 5, 地图 = { 101300 } },
}

local _高级地煞星 = {
    -- 东海渔村
    { 名称 = '地速星', 称谓 = '十一星地煞', 外形 = 41, 等级 = 11, 数量 = 5, 地图 = { 1208 } },
    -- 洛阳城
    { 名称 = '地走星', 称谓 = '十二星地煞', 外形 = 64, 等级 = 12, 数量 = 5, 地图 = { 1193 } },
    -- 长安城
    { 名称 = '地暗星', 称谓 = '十三星地煞', 外形 = 60, 等级 = 13, 数量 = 5, 地图 = { 1236 } },
    -- 长安城东
    { 名称 = '地魁星', 称谓 = '十四星地煞', 外形 = 50, 等级 = 14, 数量 = 3, 地图 = { 1001 } },
    -- 修罗古城
    { 名称 = '地杀星', 称谓 = '十五星地煞', 外形 = 54, 等级 = 15, 数量 = 3, 地图 = { 101381 } },
	-- 东海渔村
	-- { 名称 = '地杀星', 称谓 = '十六星地煞', 外形 = 54, 等级 = 16, 数量 = 1, 地图 = { 1208 } },
    -- 洛阳城
	-- { 名称 = '地杀星', 称谓 = '十七星地煞', 外形 = 54, 等级 = 17, 数量 = 1, 地图 = { 1236 } },
	-- 长安城
	-- { 名称 = '地杀星', 称谓 = '十八星地煞', 外形 = 54, 等级 = 18, 数量 = 1, 地图 = { 1001 } },
	-- 四圣庄
	-- { 名称 = '地杀星', 称谓 = '十九星地煞', 外形 = 50, 等级 = 19, 数量 = 1, 地图 = { 101295 } },
	-- 万寿山
    -- { 名称 = '地速星', 称谓 = '二十星地煞', 外形 = 50, 等级 = 20, 数量 = 1, 地图 = { 101299 } },
    -- 白骨山
    -- { 名称 = '地魁星', 称谓 = '二十一星地煞', 外形 = 50, 等级 = 21, 数量 = 1, 地图 = { 101300 } },
}

function 事件:更新初级地煞星()
    for i, v in ipairs(_低级地煞星) do
        for ii, vv in ipairs(v.地图) do
            local map = self:取地图(vv)
            for k, j in map:遍历NPC() do
                if j.名称 == v.名称 and not j.战斗中 then
                    j:删除()
                end
            end

            for n = 1, v.数量 do
                local X, Y = map:取随机坐标()
                local NPC = map:添加NPC {
                    名称 = v.名称,
                    称谓 = v.称谓,
                    外形 = v.外形,
                    等级 = v.等级,
                    时间 = os.time() + 3600,
                    脚本 = 'scripts/event/挑战_地煞星.lua',
                    X = X,
                    Y = Y,
                    来源 = self
                }
            end
        end
    end
    self:发送系统('#C天下太平，国泰民安！#R1-10级#C地煞星慕名下凡，现身于各地角落，想与各英雄豪杰一较高下，奖励丰厚，机不可失，大家有胆的就上呀！#43')
    return not self.是否结束 and 900
end

function 事件:更新中级地煞星()
    for i, v in ipairs(_中级地煞星) do
        for ii, vv in ipairs(v.地图) do
            local map = self:取地图(vv)
            for k, j in map:遍历NPC() do
                if j.名称 == v.名称 and not j.战斗中 then
                    j:删除()
                end
            end

            for n = 1, v.数量 do
                local X, Y = map:取随机坐标()
                local NPC = map:添加NPC {
                    名称 = v.名称,
                    称谓 = v.称谓,
                    外形 = v.外形,
                    等级 = v.等级,
                    时间 = os.time() + 3600,
                    脚本 = 'scripts/event/挑战_地煞星.lua',
                    X = X,
                    Y = Y,
                    来源 = self
                }
            end
        end
    end
    self:发送系统('#C天下太平，国泰民安！#R8-10级#C地煞星慕名下凡，现身于各地角落，想与各英雄豪杰一较高下，奖励丰厚，机不可失，大家有胆的就上呀！#43')
    return not self.是否结束 and 1800
end

function 事件:更新高级地煞星()
    for i, v in ipairs(_高级地煞星) do
        for ii, vv in ipairs(v.地图) do
            local map = self:取地图(vv)
            for k, j in map:遍历NPC() do
                if j.名称 == v.名称 and not j.战斗中 then
                    j:删除()
                end
            end

            for n = 1, v.数量 do
                local X, Y = map:取随机坐标()
                local NPC = map:添加NPC {
                    名称 = v.名称,
                    称谓 = v.称谓,
                    外形 = v.外形,
                    等级 = v.等级,
                    时间 = os.time() + 3600,
                    脚本 = 'scripts/event/挑战_地煞星.lua',
                    X = X,
                    Y = Y,
                    来源 = self
                }
            end
        end
    end
    self:发送系统('#C天下太平，国泰民安！#R10-15级#C地煞星慕名下凡，现身于各地角落，想与各英雄豪杰一较高下，奖励丰厚，机不可失，大家有胆的就上呀！#43')
    return not self.是否结束 and 3600
end

function 事件:事件开始()
    self:更新初级地煞星()
    self:更新中级地煞星()
    self:更新高级地煞星()
    self:定时(900, self.更新初级地煞星)
    self:定时(1800, self.更新中级地煞星)
    self:定时(3600, self.更新高级地煞星)
    print('地煞星刷新')
end

function 事件:事件结束()
    self.是否结束 = true
end

--=======================================================
local 对话 = [[吾乃掌管三界平衡的神官,汝等竟敢阻挡神的旨意。#4
menu
1|挑战
99|我认错人了
]]
function 事件:NPC对话(玩家, i, NPC)
    if NPC and not NPC:是否战斗中() then
        return 对话
    else
        return "我正在战斗中"
    end
end

function 事件:NPC菜单(玩家, i, NPC) 
    if NPC and NPC:是否战斗中() then
        return "我正在战斗中"
    end
    if i == '1' then
        if 玩家.其它.地煞星 + 1 < NPC.等级 then
            return "先挑战过" .. 玩家.其它.地煞星 + 1 .. "星地煞才有资格向吾挑战！"
        end
        NPC:进入战斗(true)
        local 战斗脚本 = string.format('scripts/war/地煞星/地煞星%s.lua', NPC.等级)
        local r = 玩家:进入战斗(战斗脚本, NPC)
        NPC:进入战斗(false)
        if r then
            if 玩家.其它.地煞星 < NPC.等级 then
                玩家.其它.地煞星 = NPC.等级
            end
            self:完成(玩家, NPC.等级)
            NPC:删除()
        end
    end
end

local _广播 = "#C人间祥瑞，星宿临凡！玩家#R%s#C在挑战地煞星中获得了#G#m(%s)[%s]#m#n#C的奖励#93"
local _经验 = {
    1000000,
    2000000,
    3000000,
    4000000,
    5000000,
    6000000,
    7000000,
    8000000,
    9000000,
    10000000,
    11000000,
    12000000,
    13000000,
    14000000,
    15000000,
	16000000,
    17000000,
    18000000,
	19000000,
	20000000,
	21000000,
}

function 事件:完成(玩家, 等级)
    for _, v in 玩家:遍历队伍() do
        self:掉落包(v, 等级)
    end
end

function 事件:掉落包(玩家, 等级)
    if 玩家:取活动限制次数('地煞星') >= 25 then
        return
    end
    玩家:增加活动限制次数('地煞星')

    local 经验 = _经验[等级] or 100000
    玩家:添加任务经验(经验 * 1.5)

    local 掉落包 = 取掉落包('挑战','地煞星')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包[等级], _广播)
    end
end

return 事件
