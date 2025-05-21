local 数据 = {}

function 数据:初始化()
end

function 数据:播放战斗(data, 自己)
    local t = table.remove(data, 1)
    local co, tco, pco = (coroutine.running())
    local 目标 = t.目标[t.位置]
    local 对象, 保护 = 战场层:取对象(目标.位置)
    if not 对象 then
        return
    end
    ::追加::
    if t.追加 then
        自己:动作_法术攻击()
        自己:添加动画(2543) --资金找到追的素材 自己改吧
        自己:置帧率(1 / 30)
        自己:置帧事件(function(dh, a, b)
            if a / b >= 0.7 then --帧数》70% 播放掉血
                coroutine.xpcall(co)
                return false
            end
        end)
        coroutine.yield()
    end
    local 原始位置 = t.位置
    if 目标.保护 then --移动保护到目标
        保护 = 战场层:取对象(目标.保护.位置)
        if 保护 then
            保护.移动速度 = 500
            保护:动作_快速移动(自己:取攻击坐标(对象, 25))
        end
    end
    self.目标 = {}
    for i, v in pairs(t.目标) do
        if not v.位置 and next(v) then
            local tg = 战场层:取对象(i)
            self.目标[i] = tg
        end
    end
    local 触发闪现 = nil
    local 连击次数 = 0
    ::闪现连击::
    if 触发闪现 then
        自己.移动速度 = 1000
        自己:动作_闪现移动(自己:取闪现攻击坐标(对象))
    elseif not t.天降流火 then
        自己.移动速度 = 1000
        自己:动作_快速移动(自己:取攻击坐标(对象))
    end
    self._定时 = 引擎:定时(
        10,
        function()
            --移动到目标
            if 保护 then
                if 保护.是否移动 then
                    return 10
                else
                    保护:置方向(保护.战斗方向)
                end
            end
            if not 自己.是否移动 then
                coroutine.xpcall(co)
                return
            end
            return 10
        end
    )
    coroutine.yield()
    ::连击::
    local 天降流火 = t.天降流火
    if 天降流火 then
        if 天降流火 == 2 then
            自己:动作_物理攻击(nil,'attackc1-2')
            自己:置帧率(1 / 15)
        else
            自己:动作_物理攻击(nil,'attackc1-1')
            自己:置帧率(1 / 15)
        end
    else
        自己:动作_物理攻击()

        if data[1] and data[1].动作 == '附法' then
            自己:置帧率(1 / 50)
        elseif 连击次数 == 0 then
            自己:置帧率(1 / 15)
        else
            自己:置帧率(1 / 30)
        end
    end

    if 保护 then
        coroutine.xpcall(
            function()
                pco = coroutine.running()
                保护:播放战斗(目标.保护, 自己)
            end
        )
    end
  
    自己:置帧事件(function(dh, a, b)
        if a / b >= 0.7 then --帧数》70% 播放掉血
            coroutine.xpcall(
                function()
                    tco = coroutine.running()
                    for i, v in pairs(t.目标) do
                        local obj = 战场层:取对象(v.位置)
                        if obj then
                            obj:播放战斗(v, 自己)
                        end
                    end
                    if t.特殊附法 then
                        coroutine.xpcall(
                            function()
                                自己:播放战斗({ t.特殊附法 },自己)
                            end
                        )
                    end
                    if t.无特效附法 then
                        coroutine.xpcall(
                            function()
                                自己:播放战斗({ t.无特效附法 },自己)
                            end
                        )
                    end
                    if t.附法 then
                        coroutine.xpcall(
                            function()
                                自己:播放战斗({ t.附法 }, 自己)
                            end
                        )
                    end
                end
                
            )
            coroutine.xpcall(
                function()
                    for i, v in pairs(self.目标) do
                        v:播放战斗(t.目标[i], v)
                    end
                end
            )
            return false
        end
    end)

    self._定时 = 引擎:定时(
        10,
        function()
            if 保护 then --等待保护结束
                if coroutine.status(pco) ~= 'dead' then
                    return 10
                end
            end
            --等待目标结束
            if (not tco or coroutine.status(tco) == 'dead') and (自己.模型 == 'guard' or 自己.模型 == 'die' or
                    自己.是否死亡) then
                coroutine.xpcall(co)
                return
            end
            return 10
        end
    )
    coroutine.yield()
    if data[1] then
        if data[1].动作 == '物攻' and not data[1].追加 then --连击
            t = table.remove(data, 1)
            目标 = t.目标[t.位置]
            保护 = nil
            if 目标.保护 then
                保护 = 战场层:取对象(目标.保护.位置)
            end
            if 原始位置 ~= t.位置 or t.闪现攻击 then
                对象, 保护 = 战场层:取对象(t.位置)
                原始位置 = t.位置
                触发闪现 = true
                goto 闪现连击
            end
            连击次数 = 连击次数 + 1
            if 天降流火 and not t.天降流火 then -- 上一次触发了 本次没触发 --要移动过去
                goto 闪现连击
            elseif not 天降流火 and t.天降流火 then -- 上次没触发 这次触发了 --回来
                自己.移动速度 = 1000
                自己:动作_快速移动(自己.战斗坐标, co) -- co挂起
                self._定时 = 引擎:定时(
                    10,
                    function()
                        if not 自己.是否移动 then
                            coroutine.xpcall(co)
                            return
                        end
                        return 10
                    end
                )
                coroutine.yield()
                自己:置方向(自己.战斗方向)
            end
            goto 连击
        end
    end
    if 保护 then --等待回位
        --co
        if not 自己.是否死亡 then
            自己.移动速度 = 1000
            自己:动作_快速移动(自己.战斗坐标)
        end

        if not 保护.是否死亡 then
            保护:动作_快速移动(保护.战斗坐标)
        end

        self._定时 = 引擎:定时(
            10,
            function()
                if not 保护.是否死亡 and 保护.是否移动 then
                    return 10
                else
                    保护:置方向(保护.战斗方向)
                end

                if not 自己.是否死亡 and 自己.是否移动 then
                    return 10
                else
                    自己:置方向(自己.战斗方向)
                end

                coroutine.xpcall(co)
            end
        )
        coroutine.yield()
        if data[1] and data[1].动作 == '物攻' and data[1].追加 then
            t = table.remove(data, 1)
            目标 = t.目标[t.位置]
            保护 = nil
            对象, 保护 = 战场层:取对象(目标.位置)
            if not 对象 then
                return
            end
            if 目标.保护 then
                保护 = 战场层:取对象(目标.保护.位置)
            end
            goto 追加
        end
    elseif not 自己.是否死亡 then --跑回位置
        self._定时 = 引擎:定时(
            10,
            function()
                
                if 自己.模型 == 'guard' or 自己.是否死亡 then
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
        if data[1] and data[1].动作 == '物攻' and data[1].追加 then
            t = table.remove(data, 1)
            目标 = t.目标[t.位置]
            保护 = nil
            对象, 保护 = 战场层:取对象(目标.位置)
            if not 对象 then
                return
            end
            if 目标.保护 then
                保护 = 战场层:取对象(目标.保护.位置)
            end
            goto 追加
        end
    end
end

function 数据:显示(x, y)
end

return 数据
