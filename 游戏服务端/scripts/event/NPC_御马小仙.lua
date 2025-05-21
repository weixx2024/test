-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2023-07-18 18:22:20

local 事件 = {
    名称 = '任务NPC_御马小仙',
    是否打开 = true,
    开始时间 = os.time { year = 2022, month = 1, day = 1, hour = 0, min = 0, sec = 0 },
    结束时间 = os.time { year = 2099, month = 1, day = 1, hour = 0, min = 0, sec = 0 },
}

function 事件:事件初始化()
end

local _NPC名称 = {
    "御马小仙甲",
    "御马小仙乙",
    "御马小仙丙",
    "御马小仙丁",
    "御马小仙戊",
}

function 事件:更新()
    local map = self:取地图(1199)
    for i, v in pairs(_NPC名称) do
        for k, vv in map:遍历NPC() do
            if v == vv.名称 then
                vv:删除()
            end
        end
    end

    for i, v in ipairs(_NPC名称) do
        local X, Y = map:取随机坐标()
        local nid = map:添加NPC {
            名称 = v,
            外形 = 46,
            脚本 = 'scripts/event/NPC_御马小仙.lua',
            时间 = os.time() + 1800,
            X = X,
            Y = Y,
            来源 = self
        }
    end
    return not self.是否结束 and 1800
end

function 事件:事件开始()
    self:更新()
    self:定时(1800, self.更新)
end

function 事件:事件结束()
    self.是否结束 = true
end

local 对话 = [[
好无聊啊，你要陪我玩游戏吗？嘻嘻
]]

function 事件:NPC对话(玩家, NPC)
    local 任务 = 玩家:取任务("坐骑2_惩恶扬善")
    if not 任务 or 任务.进度 ~= 8 then
        return 对话
    end
end

function 事件:NPC菜单(玩家, i, NPC)
end

return 事件
