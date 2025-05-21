
local 数据 = {}


function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    for i, v in pairs(t.目标) do
        if type(v)=='table' then
            local r = 战场层:取对象(v.位置  or i)
            if r then
                r:播放战斗(v)
            end
        end
    end
    if t.特殊附法 then
        自己:播放战斗({t.特殊附法})
    end
end

return 数据