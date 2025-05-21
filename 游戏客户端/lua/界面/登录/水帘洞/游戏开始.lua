local 游戏开始 = 登录层:创建控件('游戏开始')
function 游戏开始:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self.瀑布 = __res:getani('gires2/login/fall.tcp'):播放(true)
    self.溪水 = __res:getani('gires2/login/water.tcp'):播放(true)
    self.光影 = __res:getani('gires2/login/dim.tcp'):播放(true)
    self.黄光影 = __res:getani('gires2/login/light.tcp'):播放(true)
    self.前景 = __res:getspr('gires2/login/background.tcp')
    self.金箍棒 = __res:getspr('gires2/login/stick.tcp')
    self.logo = __res:getspr('gires2/login/logo.tcp')
    self.line1 = __res:getspr('gires2/login/line1.tcp')
    self.line2 = __res:getspr('gires2/login/line2.tcp')
end

function 游戏开始:更新(dt, x, y)
    self.瀑布:更新(dt)
    self.溪水:更新(dt)
    self.光影:更新(dt)
    self.黄光影:更新(dt)
end

function 游戏开始:显示(x, y)
    self.瀑布:显示(342, 203)
    self.前景:显示(0, 0)
    self.溪水:显示(426, 401)
    self.光影:显示(342 + 20, 203 - 20)
    self.金箍棒:显示(51, 215)
    self.黄光影:显示(144, 43)
    self.logo:显示(22, 17)
    self.line1:显示(0, 0)
    self.line2:显示(0, 440)
end

for i, v in ipairs {
    { name = '进入游戏', zy = 'btn_login.tcp' },
    { name = '注册帐号', zy = 'btn_register.tcp' },
    { name = '修改密码', zy = 'btn_full.tcp' },
    { name = '游戏主页', 禁止 = true, zy = 'btn_home.tcp' },
    { name = '制作团队', 禁止 = true, zy = 'btn_work.tcp' },
    { name = '退出游戏', zy = 'btn_exit.tcp' }
} do
    local 按钮 = 游戏开始:创建按钮(v.name, 475, 85 + i * 50 - 50)
    function 按钮:初始化()
        self:设置按钮精灵('gires2/login/%s', v.zy)

        if v.禁止 then
            local tcp = __res:get('gires2/login/%s', v.zy)
            self:置禁止精灵(tcp:取精灵(1))
            self:置禁止(true)
        end
    end

    function 按钮:左键弹起()
        if v.name == '进入游戏' then
            if __rpc:取状态() == '已经启动' then
                __res:界面音效('sound/addon/close.wav')
                登录层:切换界面(登录层.系统公告)
            else
                __rpc:开始连接(
                    function()
                        __res:界面音效('sound/addon/close.wav')
                        登录层:切换界面(登录层.系统公告)
                    end
                )
            end
        elseif v.name == '注册帐号' then
            登录层:打开注册窗口()
        elseif v.name == '修改密码' then
            登录层:打开修改密码窗口()
        elseif v.name == '退出游戏' then
            引擎:关闭()
        end
    end

    function 按钮:键盘弹起(键码, 功能)
        if v.name == '进入游戏' and 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
            self:左键弹起()
        end
    end
end

return 游戏开始
