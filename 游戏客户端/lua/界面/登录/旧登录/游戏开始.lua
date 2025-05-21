local 游戏开始 = 登录层:创建控件('游戏开始')
function 游戏开始:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self.背景 = __res:getspr('gires/0x8DC6191E.tga')
    self.近景 = __res:getspr('gires/0xB605B45C.tcp')
end

function 游戏开始:显示(x, y)
    self.背景:显示(0, 0)
    self.近景:显示(195, 95)
end

for i, v in ipairs {
    { name = '进入游戏', zy = '0x002F81BA.tcp', x = 241, y = 123 },
    { name = '注册帐号', zy = '0x072DD907.tcp', x = 241, y = 167 },
    { name = '修改密码', zy = '0x499A35BB.tcp', x = 241, y = 208 },
    { name = '游戏主页', 禁止 = true, zy = '0x81A30AF5.tcp', x = 241, y = 250 },
    { name = '制作团队', 禁止 = true, zy = '0xFA4B00C5.tcp', x = 241, y = 292 },
    { name = '退出游戏', zy = '0xD139A8FE.tcp', x = 241, y = 334 }
    --{name = '网易', zy = '0x15E719BF.tcp', x = 236, y = 374},
    --{name = '天下', zy = '0x11D5D83B.tcp', x = 336, y = 374}
} do
    local 按钮 = 游戏开始:创建按钮(v.name, v.x, v.y)
    function 按钮:初始化()
        if v.name == '点卡服务' then
            self:置正常精灵(__res:getspr('ui/zhfw1.png'))
            self:置按下精灵(__res:getspr('ui/zhfw3.png'))
            self:置经过精灵(__res:getspr('ui/zhfw2.png'))
        else
            self:设置按钮精灵('gires/%s', v.zy)
        end
        if v.禁止 then
            local tcp = __res:get('gires/%s', v.zy)
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
