-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-02 21:21:56
-- @Last Modified time  : 2024-08-23 14:00:07
local 数据 = {}
local 技能库 = require('数据/技能库')
function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co = (coroutine.running())
    self.目标 = t.位置 and 战场层:取对象(t.位置) or 自己
    self.目标:动作_法术攻击(func)
    自己:置帧率(1 / 10)

    自己:置帧事件(function(dh, a, b)
        if a / b >= 0.7 then --帧数》70% 播放掉血
            coroutine.xpcall(co)
            self.目标:切换造形(t.id) 
            return false
        end
    end)
    coroutine.yield()
    -- self._定时 = 引擎:定时(
    --     10,
    --     function()
    --         if (not tco or coroutine.status(tco) == 'dead') and (自己.模型 == 'guard' or 自己.模型 == 'die') then
    --             coroutine.xpcall(co)
    --             return
    --         end
    --         return 10
    --     end
    -- )
    -- coroutine.yield()
    -- self.目标:切换造形(t.id)  
    
end

function 数据:更新(dt)

end

function 数据:显示(x, y)
  
end

return 数据
