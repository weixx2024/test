local 技能库 = require('数据/技能库')
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())

    自己:添加喊话(t.内容, 7)
end

return 数据
