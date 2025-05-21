local 事件 = {
    名称 = '天罡星',
    类型 = '挑战任务',
    是否打开 = true,
    是否可接任务 = true,
    开始时间 = os.time { year = 2022, month = 1, day = 1, hour = 0, min = 0, sec = 00 },
    结束时间 = os.time { year = 2099, month = 1, day = 1, hour = 0, min = 0, sec = 00 }
}

function 事件:事件初始化()
end



local 天罡星 = {
    -- 东海渔村
    { 名称 = '天立星', 外形 = 41, 等级 = 1, 数量 = 2, 地图 = { 1208 } },
    -- 洛阳城
    { 名称 = '天走星', 外形 = 64, 等级 = 2, 数量 = 2, 地图 = { 1193 } },
    -- 长安城
    { 名称 = '天暗星', 外形 = 60, 等级 = 3, 数量 = 2, 地图 = { 1236 } },
    -- 长安城东
    { 名称 = '天魁星', 外形 = 50, 等级 = 4, 数量 = 2, 地图 = { 1001 } },
    -- 修罗古城
    { 名称 = '天杀星', 外形 = 54, 等级 = 5, 数量 = 2, 地图 = { 101381 } },
	-- 东海渔村

}



function 事件:更新天罡星()
    for i, v in ipairs(天罡星) do
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
                    脚本 = 'scripts/event/挑战_天罡星.lua',
                    X = X,
                    Y = Y,
                    来源 = self
                }
            end
        end
    end
    self:发送系统('【天罡下凡】七十二天罡的#G天立星#Y奉玉帝之命下凡巡视，天下有志之士可前往现身于各地角落，向天罡星发起挑战，挑战胜出者，天罡星并以宝物赠之。')
    return not self.是否结束 and 3600
end

function 事件:事件开始()
    self:更新天罡星()
    self:定时(900, self.更新天罡星)
    print('天罡星刷新')
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
        if 玩家.其它.天罡星 + 1 < NPC.等级 then
            return "先挑战过" .. 玩家.其它.天罡星 + 1 .. "天罡星才有资格向吾挑战！"
        end
        NPC:进入战斗(true)
        local 战斗脚本 = string.format('scripts/war/天罡星/天罡星%s.lua', NPC.等级)
        local r = 玩家:进入战斗(战斗脚本, NPC)
        NPC:进入战斗(false)
        if r then
            if 玩家.其它.天罡星 < NPC.等级 then
                玩家.其它.天罡星 = NPC.等级
            end
            self:完成(玩家, NPC.等级)
            NPC:删除()
        end
    end
end

local _广播 = "#C人间祥瑞，星宿临凡！玩家#R%s#C在挑战天罡星中获得了#G#m(%s)[%s]#m#n#C的奖励#93"
local _经验 = {

    80000000,
    90000000,
	100000000,
	130000000,
	160000000,
}

function 事件:完成(玩家, 等级)
    for _, v in 玩家:遍历队伍() do
        self:掉落包(v, 等级)
    end
end

function 事件:掉落包(玩家, 等级)
    if 玩家:取活动限制次数('天罡星') >= 25 then
        return
    end
    玩家:增加活动限制次数('天罡星')

    local 经验 = _经验[等级] or 100000
    玩家:添加任务经验(经验 * 1.5)

    local 掉落包 = 取掉落包('挑战','天罡星')   
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包[等级], _广播)
    end
end

return 事件
