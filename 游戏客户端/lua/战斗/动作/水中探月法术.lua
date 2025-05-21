-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-24 01:37:19
-- @Last Modified time  : 2022-08-30 10:11:44
local 技能库 = require('数据/技能库')
local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co, tco, pco = (coroutine.running())
    local 对象, 保护 = 战场层:取对象(t.原始目标)
    local 原始位置 = t.原始目标
    if not 对象 then
        return
    end
    -- if data.分裂攻击 then
    --     自己:动作_法术攻击()
    --     自己:添加动画("1832")
    --     自己:置帧率(1 / 30)
    --     自己:置帧事件(function(dh, a, b)
    --         if a / b >= 0.7 then --帧数》70% 播放掉血
    --             coroutine.xpcall(co)
    --             return false
    --         end
    --     end)
    --     coroutine.yield()
    -- end
    -- local 触发闪现
    -- ::闪现连击::
    -- if 触发闪现 then
    --     自己.移动速度 = 1000
    --     自己:动作_闪现移动(自己:取闪现攻击坐标(对象))
    -- else
        local wd = 战场层:取对象(自己.位置)
        自己.移动速度 = 10000
        自己:动作_快速移动(自己:取攻击坐标(对象))
    -- end
    -- 触发闪现 = nil
    self._定时 = 引擎:定时(
        10,
        function()
            if not 自己.是否移动 and not 自己.是否特殊移动 and not 自己.是否闪现 then
                coroutine.xpcall(co)
                return
            end
            return 10
        end
    )
    coroutine.yield()
    ::连击::
    local sj = math.random(3)
    自己:动作_物理攻击(nil,"attackc"..sj.."-1")
    自己:置帧率(1 / 50)
    self.目标 = {}
    for i, v in pairs(t.目标) do
        local tg = 战场层:取对象(v.位置)
        self.目标[i] = tg
    end
    自己:置帧事件(function(dh, a, b)
        if a / b >= 0.7 then --帧数》70% 播放掉血
            coroutine.xpcall(
                function()
                    tco = coroutine.running()
                    for i, v in pairs(self.目标) do
                        v:播放战斗(t.目标[i])
                    end
                end
            )
            return false
        end
    end)
    self._定时 = 引擎:定时(
        10,
        function()
            --等待目标结束
            if (not tco or coroutine.status(tco) == 'dead') and (自己.模型 == 'guard' or 自己.模型 == 'die') then
                coroutine.xpcall(co)
                return
            end
            return 10
        end
    )
    coroutine.yield()
    if data[1] then
        if data[1].动作 == '水中探月法术' then --连击
            t = table.remove(data, 1)
            对象, 保护 = 战场层:取对象(t.原始目标)
            if not 对象 then
                return
            end
            -- if 原始位置 ~= t.位置 or t.闪现攻击 then
            --     原始位置 = t.位置
            --     触发闪现 = true
            --     goto 闪现连击
            -- end
            goto 连击
        end
    end
    if not 自己.是否死亡 then --跑回位置
        self._定时 = 引擎:定时(
            10,
            function()
                if 自己.模型 == 'guard' then
                    coroutine.xpcall(co)
                    return
                end
                return 10
            end
        )
        coroutine.yield()
        自己.移动速度 = 1000
        自己:动作_快速移动(自己.战斗坐标, co) --co挂起
        自己:置方向(自己.战斗方向)
    end
end

function 数据:更新(dt)

end

function 数据:显示(x, y)

end

return 数据
