
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 目标 = t.位置 and 战场层:取对象(t.位置) or 自己
    目标:增减蓝条(t.数值,t.特效)
    --蓝条
    if t.特效 == 1 and t.数值 > 0 then
        目标:添加动画('add_mp')
    end
end

function 数据:显示(x, y)
end

return 数据
