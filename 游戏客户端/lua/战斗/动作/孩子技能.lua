local 技能库 = require('数据/技能库')
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())

    自己:动作_法术攻击()
    自己:置帧率(1 / 20)

    自己:置停止事件(
        function()
            coroutine.xpcall(co)
        end
    )
    coroutine.yield()
end

return 数据
