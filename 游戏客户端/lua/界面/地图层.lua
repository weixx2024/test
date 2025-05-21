function 地图层:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)

    self.屏幕 = __rol and __rol.xy:复制() or require('GGE.坐标')(600, 300)
    self.飞行表 = {}
    self.点击 = __res:getani('gires/scene/walkpoint.tca')
end

function 地图层:更新(dt, x, y)
    if self.移动中 then
        local p = __rol.xy
        local r = self.屏幕:取距离(p)
        if self.移动中 == 1 then
            local 速度 = 50
            if __rol.神行符 then
                速度 = 150
            end
            if r < dt * 速度 then
                self.移动中 = false
            elseif r < 100 then
                self.屏幕:移动(dt * 速度, p)
            else
                self.移动中 = 2
            end
        else
            local 速度 = 180
            if __rol.神行符 then
                速度 = 280
            end
            if r < 50 then
                self.移动中 = 1
            else
                self.屏幕:移动(dt * 速度, p)
            end
        end
    elseif __rol and __rol.是否移动 then
        self.移动中 = 1
    end
    if self.地图 then
        self.地图:更新(dt, self.屏幕)
        self.xy = self.地图.xy
    end

    -- table.sort(
    --     self.飞行表,
    --     function(a, b)
    --         return a:取排序点() < b:取排序点()
    --     end
    -- )
    -- for i, v in ipairs(self.飞行表) do
    --     v:更新(dt)
    -- end

    if self.转场 and gge.platform == 'Windows' then
        self.转场 = self.转场:更新(dt)
    end

    if self.点击 then
        self.点击:更新(dt)
    end
end

function 地图层:显示(x, y)
    if self.地图 then
        self.地图:显示(self.xy)
    end
    if self.点击 then
        if self.点击.是否播放 then
            self.点击:显示(self.点击.xy - self.xy)
        end
    end
    if self.地图 then
        self.地图:显示对象()
    end

    -- for i, v in ipairs(self.飞行表) do
    --     v:显示(self.xy)
    -- end
    if self.转场 and gge.platform == 'Windows' then
        self.转场:显示()
    end
end

function 地图层:切换地图(id)
    窗口层:关闭对话()
    self.屏幕 = __rol and __rol.xy:复制() or self.屏幕
    self.地图 = require('地图')(id)
    self.转场 = require('辅助/精灵_转场')()
    __rol.地图 = id
    _G.__map = self.地图
    __map:添加(__rol)

    if 界面层.任务栏.目标 then
        地图层._定时_跳转切图 = 引擎:定时(
            2000,
            function(ms)
                界面层.任务栏.任务列表:文本回调左键弹起(界面层.任务栏.目标)
                界面层.任务栏.延迟传送 = nil
                return 0
            end
        )
    end
end

function 地图层:进入战斗()
    self:置可见(false)
end

function 地图层:退出战斗()
    self:置可见(true)
    self.转场 = require('辅助/精灵_转场')()
end

function 地图层:移动主角(x, y, 走)
    if __rol and (not __rol.是否组队 or __rol.是否队长) and not __rol.是否摆摊 and not __rol.是否定身 and not __rol.冰冻 then
        if self.xy then -- 防止刚登陆 坐标未初始化 移动报错
            local xy = require('GGE.坐标')(x, y) + self.xy
            if #self.地图:寻路(__rol.xy, xy) > 0 then
                __rol:路径移动(self.地图, 走)
                if __隐藏玩家 == 1 then
                    _G.__隐藏玩家 = nil
                end
            end
        end
    end
end

function 地图层:自动移动()
    if not self.点击.持续 and (not __rol.是否组队 or __rol.是否队长) and not __rol.是否摆摊 then
        self.点击.持续 = 120
        self._定时移动 = 引擎:定时(
            1000,
            function(ms)
                if self.点击.持续 then
                    self.点击.持续 = self.点击.持续 - ms
                    if self.点击.持续 <= 0 then
                        self.点击.持续 = 120
                        local x, y = 引擎:取鼠标坐标()
                        self:移动主角(x, y)
                        self.点击:播放()
                        self.点击.xy = require('GGE.坐标')(self.xy.x + x, self.xy.y + y)
                    end
                    return ms
                end
            end
        )
    end
end

function 地图层:手机自动遇怪()
    if not self.遇怪 then
        __自动遇敌 = true
        self.遇怪 = true
        self:自动遇怪()
        窗口层:提示窗口('#Y开启自动遇怪...')
    else
        __自动遇敌 = false
        self.遇怪 = nil
        __rol:停止移动()
        if self._定时遇怪 then
            self._定时遇怪:删除()
        end
        窗口层:提示窗口('#Y关闭自动遇怪...')
    end
end

function 地图层:自动遇怪()
    if self.遇怪 and (not __rol.是否组队 or __rol.是否队长) and not __rol.是否摆摊 then
        self._定时遇怪 = 引擎:定时(
            5000,
            function(ms)
                if self.遇怪 and not __rol.是否战斗 and not __rol.是否移动 then --
                    local x, y = self.地图:随机点()
                    local xy = require('GGE.坐标')(x * 20, self.地图.高度 - y * 20)
                    local 路径 = self.地图:寻路(__rol.xy, xy)
                    __rol:路径移动(self.地图)
                end
                return ms
            end
        )
    end
end

function 地图层:消息事件(msg) --消息事件是协程
    if not msg.鼠标 then
        return
    end
    if __rol and not __rol.是否战斗 then
        for i, v in pairs(__map.对象) do
            if v.消息事件 then
                v:消息事件(msg, x, y)
            end
        end

        for i, v in ipairs(msg.鼠标) do
            local x, y = v.x, v.y
            if x < 0 then
                break
            end
            if v.button == SDL.BUTTON_LEFT then --左键
                if v.type == SDL.MOUSE_DOWN then
                    if 鼠标层.是否正常 then
                        self.按下 = os.time()
                    else
                        -- if gge.platform ~= 'Windows' then
                        --     鼠标层:正常形状()
                        -- end
                    end
                elseif v.type == SDL.MOUSE_UP and self.按下 then
                    self.按下 = false
                    local m = 鼠标层.附加
                    if ggetype(m) == '物品' then
                        if m.来源 == '物品' then
                            m:丢弃()
                        end
                    elseif ggetype(m) == '技能' then
                        if m.来源 == '快捷键' then
                            m:丢弃()
                        end
                    elseif 引擎:取功能键状态(SDL.KMOD_CTRL) then
                    else
                        self.点击:播放()
                        if self.xy then
                            self.点击.xy = require('GGE.坐标')(self.xy.x + x, self.xy.y + y) -- todo
                        end
                        if gge.platform ~= 'Windows' then
                            self:移动主角(x, y)
                        else
                            self:移动主角(x, y, true)
                        end
                        self.遇怪 = nil
                        self.点击.持续 = nil
                        if self._定时遇怪 then
                            self._定时遇怪:删除()
                        end
                        return
                    end
                end
            elseif v.button == SDL.BUTTON_RIGHT then
                if v.type == SDL.MOUSE_DOWN then
                    if 鼠标层.是否正常 then
                        self.按下 = os.time()
                        self.点击.持续 = nil
                        self.遇怪 = nil
                        self._定时长按 = 引擎:定时(
                            2000,
                            function()
                                local X, Y = 引擎:取鼠标坐标()
                                if 引擎:取鼠标状态() == SDL.BUTTON_RMASK and X == x and Y == y then
                                    self:自动移动()
                                end
                            end
                        )
                    end
                elseif v.type == SDL.MOUSE_UP then
                    self.点击:播放()
                    self.点击.xy = require('GGE.坐标')(self.xy.x + x, self.xy.y + y)
                    self:移动主角(x, y)
                    self.遇怪 = nil
                    if self._定时遇怪 then
                        self._定时遇怪:删除()
                    end
                end
            elseif v.type == SDL.MOUSE_MOTION then

            end
        end
    end
end

function 地图层:键盘按下(key, mod)
    if __rol and not __rol.是否战斗 then
        if mod & SDL.KMOD_ALT ~= 0 then
            if key == SDL.KEY_1 then
                窗口层:打开小地图当前()
            elseif key == SDL.KEY_2 then
                窗口层:打开世界地图()
            elseif key == SDL.KEY_3 then
            elseif key == SDL.KEY_4 then
                _G.__隐藏名称 = not __隐藏名称
            elseif key == SDL.KEY_5 then
                if not _G.__隐藏玩家 then
                    _G.__隐藏玩家 = 1
                    窗口层:提示窗口('#Y你选择了#G暂时屏蔽#Y所有玩家，再次按#Ralt+5#Y可以#G永久屏蔽#Y所有玩家。')
                    return
                end
                _G.__隐藏玩家 = _G.__隐藏玩家 + 1
                if _G.__隐藏玩家 == 2 then
                    窗口层:提示窗口('#Y你选择了#G永久屏蔽#Y所有玩家，再次按#Ralt+5#Y可以消除屏蔽状态。')
                else
                    _G.__隐藏玩家 = nil
                    窗口层:提示窗口('#Y你取消了屏蔽状态，再次按#Ralt+5#Y可以#G暂时屏蔽#Y所有玩家。')
                end
            elseif key == SDL.KEY_6 then
                if _G.__隐藏玩家 then
                    _G.__隐藏玩家 = nil
                    窗口层:提示窗口('#Y你取消了#G屏蔽玩家#Y的状态，再次按#Ralt+6#Y可以进入屏蔽状态。。')
                else
                    _G.__隐藏玩家 = 2
                    窗口层:提示窗口('#Y你选择了#G永久屏蔽#Y所有玩家，再次按#Ralt+6#Y可以消除屏蔽状态。')
                end
            elseif key == SDL.KEY_Z then
                -- local r = __rpc:角色_取VIP等级()
                -- if not r or r < 3 then
                --     return
                -- end

                if not self.遇怪 then
                    __自动遇敌 = true
                    self.遇怪 = true
                    self:自动遇怪()
                    窗口层:提示窗口('#Y开启自动遇怪...')
                else
                    __自动遇敌 = false
                    self.遇怪 = nil
                    __rol:停止移动()
                    if self._定时遇怪 then
                        self._定时遇怪:删除()
                    end
                    窗口层:提示窗口('#Y关闭自动遇怪...')
                end
            end
        end
    end
end

return 地图层
