-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-02 16:11:29
-- @Last Modified time  : 2022-08-30 17:46:01
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    local 目标 = 战场层:取对象(t.位置)
    
    if t.id then
        local r = 目标:添加M动画(t.id)
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
    end
    战场层:删除对象(目标.位置)

end

function 数据:显示(x, y)
end

return 数据
