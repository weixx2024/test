
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())

    for i, v in pairs(t.目标) do
        local obj = 战场层:取对象(v.位置)
        if obj then
            obj:播放战斗(v, 自己)
        end
    end
end

function 数据:显示(x, y)
end

return 数据
