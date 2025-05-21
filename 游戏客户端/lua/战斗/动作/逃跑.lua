
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local r = 自己:添加动画(t.结果 and 'esc_ok' or 'esc_fail')
    self._定时 = 引擎:定时(
        10,
        function()
            if not r.是否播放 then
                coroutine.xpcall(co)
                return
            end
            return 10
        end
    )
    coroutine.yield()
    if t.结果 then
        战场层:删除对象(自己.位置)
        战场层:删除对象(自己.位置 + 5)
        战场层:删除对象(自己.位置 + 10)
    end
end

function 数据:显示(x, y)
end

return 数据
