-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2023-07-18 18:27:14

local 事件 = {
    名称 = '任务NPC_王五',
    是否打开 = true,
    开始时间 = os.time { year = 2022, month = 1, day = 1, hour = 0, min = 0, sec = 0 },
    结束时间 = os.time { year = 2099, month = 1, day = 1, hour = 0, min = 0, sec = 0 },
}

function 事件:事件初始化()
end

function 事件:更新()
    local 地图列表 = { 101295, 101299, 101300 }
    local 随机地图 = 地图列表[math.random(1, 3)]
    for i, v in pairs(地图列表) do
        local map = self:取地图(v)
        map:删除NPC(self.NPC)
    end

    local map = self:取地图(随机地图)
    local X, Y = map:取随机坐标()
    self.NPC = map:添加NPC {
        名称 = '王五',
        外形 = 3044,
        脚本 = 'scripts/event/NPC_王五.lua',
        时间 = os.time() + 1800,
        X = X,
        Y = Y,
        来源 = self
    }
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
我们认识么？
]]

function 事件:NPC对话(玩家, NPC)
    local 任务 = 玩家:取任务("称谓13_偷吃人参果")
    if not 任务 or 任务.进度 ~= 5 then
        return 对话
    end
end

function 事件:NPC菜单(玩家, i, NPC)
end

return 事件
