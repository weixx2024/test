local 选择区服 = 登录层:创建控件('选择区服')
function 选择区服:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self:置精灵(__res:getspr('gires/0x4EA1F7CF.tcp'))
    -- self.区名 = __res.F14:置颜色(0, 0, 0):取精灵('推荐')
    -- self.服名 = __res.F14:置颜色(0, 0, 0):取精灵('大雁塔')
    self.状态 = __res:getspr('gires/login/green.tcp')
end

function 选择区服:显示(x, y)
    if self.区名 then
        self.区名:显示(x + 195, y + 431)
        self.服名:显示(x + 268, y + 428)
        self.状态:显示(x + 262, y + 447)
    end
end

function 选择区服:可见事件(v)
    if v then
        推荐:清空()
        天界:清空()
        人界:清空()
        地界:清空()
        修罗:清空()
        local t = __rpc:获取区服()

        if type(t) == 'table' then
            for i, v in ipairs(t) do
                local 网络 = _ENV[v.区名]
                if 网络 then
                    网络:添加(v, v.服名 == __res.配置.默认选区)
                end
                if v.推荐 then
                    推荐:添加(v)
                end
            end
            选择区服.标签控件.推荐:置选中(true)
        end
    end
end

local 标签控件 = 选择区服:创建标签('标签控件', 0, 0, 640, 480)
do
    for k, v in pairs {
        { name = '推荐', x = 34, y = 75, tcp = 'gires/login/group1.tca' },
        { name = '天界', x = 27, y = 182, tcp = 'gires/login/group2.tca' },
        { name = '人界', x = 27, y = 237, tcp = 'gires/login/group3.tca' },
        { name = '地界', x = 27, y = 291, tcp = 'gires/login/group4.tca' },
        { name = '修罗', x = 27, y = 346, tcp = 'gires/login/group5.tca' }
    } do
        local 按钮 = 标签控件:创建单选按钮(v.name, v.x, v.y, v.name)

        function 按钮:初始化()
            self:设置按钮精灵2(v.tcp)
        end

        local 区域 = 标签控件:创建区域(按钮, 0, 0, 640, 480)
        local 网格 = 区域:创建网格('网格', 180, 85, 430, 300)
        function 网格:初始化()
            self:创建格子(77, 32, 6, 10, 8, 5)
        end

        function 网格:清空()
            self:删除格子()
            self:创建格子(77, 32, 6, 10, 8, 5)
            self.n = 0
        end

        function 网格:子显示(x, y, i)
            if self[i].state then
                self[i].state:显示(x + 4, y + 25)
            end
        end

        function 网格:添加(t, 默认)
            if not t.服名 then
                return
            end
            self.n = self.n + 1
            local 格子 = self[self.n]

            local 文字按钮 = 格子:创建文字按钮3(t.服名, 10, 6, t.服名)

            格子.state = __res:getspr('gires/login/green.tcp')

            function 文字按钮:左键弹起()
                选择区服.地址 = t.地址
                选择区服.端口 = t.端口
                选择区服.区名 = __res.F14:置颜色(0, 0, 0):取精灵(t.区名)
                选择区服.服名 = __res.F14:置颜色(0, 0, 0):取精灵(t.服名)
                选择区服.状态 = __res:getspr('gires/login/green.tcp')
                __res.配置.默认选区 = t.服名
            end

            格子:置可见(true, true)
            if 默认 then
                文字按钮:左键弹起()
            end
        end

        _ENV[v.name] = 网格
    end
end

local 进入按钮 = 选择区服:创建小按钮('进入按钮', 371, 427, '进入')
function 进入按钮:左键弹起()
    if 选择区服.地址 then
        __res:保存配置()
        __rpc.地址 = 选择区服.地址
        __rpc.端口 = 选择区服.端口
        if 引擎.标题 then
            引擎.标题 = string.format(引擎.标题 .. "-%s", __res.配置.默认选区)
        end
        __rpc:开始连接(
            function()
                登录层:切换界面(登录层.游戏登录)
            end
        )
    else
        登录层:打开提示('#K请选择一个服务器')
    end
end

function 进入按钮:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
        self:左键弹起()
    elseif 键码 == SDL.KEY_ESCAPE then
        登录层:切换界面(登录层.游戏开始)
    end
end

local 返回按钮 = 选择区服:创建小按钮('返回按钮', 547, 427, '返回')
function 返回按钮:左键弹起()
    登录层:切换界面(登录层.游戏开始)
end

return 选择区服
