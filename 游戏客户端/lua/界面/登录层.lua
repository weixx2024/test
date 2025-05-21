function 登录层:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
end

function 登录层:切换界面(界面)
    self.游戏开始:置可见(界面 == self.游戏开始, true)
    self.系统公告:置可见(界面 == self.系统公告, true)
    self.选择区服:置可见(界面 == self.选择区服, true)
    self.游戏登录:置可见(界面 == self.游戏登录, true)
    self.角色选择:置可见(界面 == self.角色选择, true)
    self.角色创建:置可见(界面 == self.角色创建, true)
end

-- 登录层:切换界面(登录层.角色创建)
--======================================================================================
local 登录信息 = GUI:创建模态窗口('登录信息')
do
    function 登录信息:初始化()
        self:置精灵(__res:getspr('gires/0x5CF05F63.tcp'))
    end

    function 登录信息:右键弹起()
        return false
    end

    local 文本 = 登录信息:创建文本('文本', 25, 28, 290, 90)

    function 登录层:打开信息(v, ...)
        if select('#', ...) > 0 then
            v = v:format(...)
        end
        登录信息:置可见(true)
        登录信息:置坐标((引擎.宽度 - 348) // 2, (引擎.高度 - 154) // 2)
        登录信息.文本:置文本(v)
        return 登录信息
    end
end

--======================================================================================
local 登录提示 = GUI:创建模态窗口('登录提示')
do
    function 登录提示:初始化()
        self:置精灵(__res:getspr('gires/0x5CF05F63.tcp'))
    end

    function 登录提示:消息结束(msg)
        return true
    end

    local 文本 = 登录提示:创建文本('文本', 25, 28, 290, 90)

    local 确定按钮 = 登录提示:创建按钮('确定按钮', 130, 90)
    function 确定按钮:初始化()
        self:置正常精灵(__res:getspr('ui/queding1.png'))
        self:置按下精灵(__res:getspr('ui/queding2.png'))
    end

    function 确定按钮:左键弹起()
        登录提示:置可见(false)
    end

    function 确定按钮:键盘弹起(键码, 功能)
        if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
            self:左键弹起()
            return true
        end
    end

    function 登录层:打开提示(v, ...)
        if select('#', ...) > 0 then
            v = v:format(...)
        end
        登录提示:置坐标((引擎.宽度 - 348) // 2, (引擎.高度 - 154) // 2)
        登录提示.文本:置文本(v)
        登录提示:置可见(true, true)
        return 登录提示
    end
end

--登录层:打开提示('123')
--======================================================================================

local 登录确认 = GUI:创建模态窗口('登录确认')
do
    function 登录确认:初始化()
        self:置精灵(__res:getspr('gires/0x5CF05F63.tcp'))
    end

    function 登录确认:消息结束(msg)
        return true
    end

    local 文本 = 登录确认:创建文本('文本', 25, 28, 290, 90)

    local 确定按钮 = 登录确认:创建按钮('确定按钮', 130, 90)
    function 确定按钮:初始化()
        self:置正常精灵(__res:getspr('ui/queding1.png'))
        self:置按下精灵(__res:getspr('ui/queding2.png'))
    end

    function 确定按钮:左键弹起()
        登录确认:置可见(false)
        coroutine.resume(登录确认.co, true)
    end

    function 确定按钮:键盘事件(键码, 功能)
        if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
            self:左键弹起()
            return true
        end
    end

    -- local 取消按钮 = 登录确认:创建按钮('取消按钮', 350, 115)
    -- function 取消按钮:初始化()
    --     self:设置按钮精灵('gires/common/login/通用/按钮_小.tcp')
    -- end

    -- function 取消按钮:左键弹起()
    --     登录确认:置可见(false)
    --     coroutine.resume(登录确认.co, false)
    -- end

    function 登录层:打开选择(v, ...)
        if select('#', ...) > 0 then
            v = v:format(...)
        end
        登录确认:置可见(true)
        登录确认:置坐标((引擎.宽度 - 348) // 2, (引擎.高度 - 154) // 2)
        登录确认.文本:置文本(v)
        登录确认.co = coroutine.running()
        return coroutine.yield()
    end
end
local 登录输入 = GUI:创建模态窗口('登录输入')
do
    function 登录输入:初始化()
        self:置精灵(
            生成精灵(
                360,
                160,
                function()
                    __res:getsf('gires/0x5CF05F63.tcp'):显示(0, 0)
                    __res:getsf('ui/dsr.png'):显示(90, 55)
                end
            )
        )
    end

    function 登录输入:消息结束(msg)
        return true
    end

    local 文本 = 登录输入:创建文本('文本', 100, 28, 200, 20)
    local 输入 = 登录输入:创建文本输入('输入', 93, 58, 137, 16)
    local 确定按钮 = 登录输入:创建按钮('确定按钮', 130, 90)
    function 确定按钮:初始化()
        self:置正常精灵(__res:getspr('ui/queding1.png'))
        self:置按下精灵(__res:getspr('ui/queding2.png'))
    end

    function 确定按钮:左键弹起()
        coroutine.resume(登录输入.co, 登录输入.输入:取文本())
        登录输入.co = nil
        登录输入:置可见(false)
    end

    function 确定按钮:键盘事件(键码, 功能)
        if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
            self:左键弹起()
            return true
        end
    end

    -- local 取消按钮 = 登录确认:创建按钮('取消按钮', 350, 115)
    -- function 取消按钮:初始化()
    --     self:设置按钮精灵('gires/common/login/通用/按钮_小.tcp')
    -- end

    -- function 取消按钮:左键弹起()
    --     登录确认:置可见(false)
    --     coroutine.resume(登录确认.co, false)
    -- end

    function 登录层:打开输入(v, ...)
        if select('#', ...) > 0 then
            v = v:format(...)
        end
        登录输入:置可见(true)
        登录输入:置坐标((引擎.宽度 - 348) // 2, (引擎.高度 - 154) // 2)
        登录输入.文本:置文本(v)
        登录输入.co = coroutine.running()
        return coroutine.yield()
    end
end
return 登录层:置可见(true)
