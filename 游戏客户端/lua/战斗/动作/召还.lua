
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())

    战场层:删除对象(t.位置)
    界面层:置召唤状态()
end

function 数据:显示(x, y)
end

return 数据
