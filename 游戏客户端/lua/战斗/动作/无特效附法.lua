-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-24 01:37:19
-- @Last Modified time  : 2022-08-30 10:11:44
local 技能库 = require('数据/技能库')
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    -- 自己:动作_物理攻击()
    -- 自己:置帧率(1 / 30)
    -- 自己:置帧事件(function(dh, a, b)
    --     if a / b >= 0.7 then --帧数》70% 播放掉血
    --         coroutine.xpcall(co)
    --         return false
    --     end
    -- end)
    -- coroutine.yield()
    self.目标 = {}
    for i, v in pairs(t.目标) do
        local tg = 战场层:取对象(v.位置)
        self.目标[i] = tg
    end

    coroutine.xpcall(function()
        for i, v in pairs(self.目标) do
            v:播放战斗(t.目标[i])
        end
    end)
end

function 数据:更新(dt)

end

function 数据:显示(x, y)

end

return 数据
