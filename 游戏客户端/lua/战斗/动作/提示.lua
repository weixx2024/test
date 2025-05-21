
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    if 自己.位置 == 战场层.rol.位置 then--todo rol nil
        窗口层:提示窗口(t.内容)
    elseif 战场层.sum and 自己.位置 == 战场层.sum.位置 then
        窗口层:提示窗口(t.内容)
    end
end

function 数据:显示(x, y)
end

return 数据
