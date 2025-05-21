

local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co, tco = (coroutine.running())
    local 目标 = t.目标
    if not 目标 then
        warn('攻击对象不存在')
        return
    end
    local 对象 = 战场层:取对象(目标.位置)
    if not 对象 then
        warn('攻击对象不存在')
        return
    end

    if 对象.模型 ~= 'guard' then
        self._定时 = 引擎:定时(
            10,
            function()
                
                if 对象.模型 == 'guard' then
                    coroutine.xpcall(co)
                    return
                end
                return 10
            end
        )
        coroutine.yield()
    end

    自己:动作_物理攻击()
    自己:置帧率(1 / 14)
    自己:置帧事件(function(dh, a, b)
        if a / b >= 0.7 then --帧数》70% 播放掉血
            coroutine.xpcall(co)
            return false
        end
    end)
    coroutine.yield()
    
    对象:播放战斗(目标, 自己)
    -- self._定时 = 引擎:定时(
    --     10,
    --     function()
    --         if 自己.模型 ~= 'attack' then
    --             coroutine.xpcall(co)
    --             return
    --         end
    --         return 10
    --     end
    -- )
    -- coroutine.yield()
end

function 数据:显示(x, y)
end

return 数据
