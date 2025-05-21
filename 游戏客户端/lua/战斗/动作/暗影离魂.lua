-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-28 04:41:04
-- @Last Modified time  : 2024-08-23 13:53:10

local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co, tco, pco = (coroutine.running())
    local 目标 = t.目标
    local 位置 = t.位置
    local 触发闪现
    local list = {}
    for i, v in ipairs(位置) do
        local mb = 目标[v.位置]
        local 对象 = 战场层:取对象(mb.位置)
        list[#list + 1] = 自己:取暗影离魂攻击坐标(对象)
    end
    自己.移动速度 = 1000
    自己:动作_暗影离魂移动(list)
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
    -- 自己:置帧率(1 / 10)
    local tab = {}
    for i, v in ipairs(位置) do
        tab[i] = i
    end
    ::连击::
    自己:动作_暗影离魂攻击(tab)
    自己:置帧率(1 / 50)
    local function 已播放(wz)
        for i, v in pairs(位置) do
            if v.位置 == wz then
                return true
            end
        end
    end
    for n, v in pairs(tab) do
        自己:置特殊帧事件(function(dh, a, b)
            if a / b >= 0.7 then --帧数》70% 播放掉血
                coroutine.xpcall(
                    function()
                        tco = coroutine.running()
                        local num = 位置[n].位置
                        local mb = 目标[num]
                        local obj = 战场层:取对象(mb.位置)
                        if obj and #mb > 0 then
                            while mb[1] do
                                obj:播放战斗({ mb[1] }, 自己)
                                local 动作 = mb[1].动作
                                table.remove(mb, 1)
                                if 动作 == "物伤" then
                                    break
                                end
                            end
                        end
                    end
                )
                -- if n==1 then
                -- for i, x in pairs(t.目标) do
                --     if not 已播放(x.位置) then
                --         local obj = 战场层:取对象(x.位置)
                --         if obj then
                --             obj:播放战斗({x[1]}, 自己)
                --             table.remove(x,1)
                --         end
                --     end
                -- end
                local num = 位置[n].位置
                if t.附法 and t.附法.目标[num] then
                    local obj = 战场层:取对象(位置[n].位置)
                    if obj then
                        local s = table.remove(t.附法.目标[num], 1)
                        obj:播放战斗({ { id = t.附法.id, nid = t.附法.nid, 动作 = t.附法.动作, 目标 = { [num] = { s, 位置 = num } } } }, 自己)
                    end
                end
                -- end
                return false
            end
        end
        , n
        )
    end




    --你知不知道 官服  暗影离婚 这个技能  会不会触发  反哺之私    有技能就会    那加多少？  暗影 比如秒3  他怎么给 玩家加法  主体加
    self._定时 = 引擎:定时(
        10,
        function()
            if (not tco or coroutine.status(tco) == 'dead') and (自己.模型 == 'guard' or 自己.模型 == 'die') then
                coroutine.xpcall(co)
                return
            end
            return 10
        end
    )
    coroutine.yield()
    tab = {}
    local 触发连击
    for i, v in ipairs(位置) do
        if v.连击次数 and v.连击次数 >= 1 then
            local mb = 目标[v.位置]
            local 对象 = 战场层:取对象(mb.位置)
            if not 对象.是否死亡 then
                tab[i] = v.连击次数
                v.连击次数 = v.连击次数 - 1
                触发连击 = true
            else
                v.连击次数 = nil
            end
        end
    end
    if 触发连击 then
        goto 连击
    end
    自己:置帧率(1 / 30)
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
    -- print(自己.是否死亡)
end

function 数据:显示(x, y)
end

return 数据
