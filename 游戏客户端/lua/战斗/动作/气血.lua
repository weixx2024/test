
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 目标 = t.位置 and 战场层:取对象(t.位置) or 自己
    if 目标 then
        if t.数值 >= 0 then
            目标:添加绿数字(t.数值, t.类型)
        else
            目标:添加红数字(t.数值, t.类型)
        end
        if t.特效 == 1 then
            目标:添加动画('add_hp')
        elseif t.特效 == 2 then
            目标:添加动画('add_hpmp')
        end
    end
end

function 数据:显示(x, y)
end

return 数据
