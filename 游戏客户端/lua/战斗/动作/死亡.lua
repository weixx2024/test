
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 目标 = t.位置 and 战场层:取对象(t.位置) or 自己
    if 目标 then
        目标:动作_死亡()
        if t.消失 then
            目标.是否删除 = os.time()+2
        end
    end
end

function 数据:显示(x, y)
end

return 数据