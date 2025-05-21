local 选择区服 = 登录层:创建控件('选择区服')

function 选择区服:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self:置精灵(__res:getspr('gires2/0xB7F391E9.tcp'))
    self.状态 = __res:getspr('gires/login/green.tcp')
    self.天界背景 = __res:getspr('gires2/0xBFBE1987.tcp')
    self.地界背景 = __res:getspr('gires2/0xC2C6E7CC.tcp')
    self.人界背景 = __res:getspr('gires2/0x53683A80.tcp')
    self.修罗背景 = __res:getspr('gires2/0xF591D605.tcp')
    self.推荐背景 = __res:getspr('gires2/0xB5FE7FCD.tcp')
    self.区服背景 = __res:getspr('ui2/qfbj.tcp')
    self.网络状态 = __res:getspr('gires2/0xDD3838ED.tcp')
    self.默认服务器 = __res:getspr('ui2/moren.png')
    self.大区列表 = { 天界 = self.天界背景, 地界 = self.地界背景, 人界 = self.人界背景, 修罗 = self.修罗背景, 推荐 = self.推荐背景 }
end

function 选择区服:显示(x, y)
    local 大区 = { '推荐', '天界', '地界', '人界', '修罗' }
    for i = 1, #大区 do
        if 选择区服.标签控件[大区[i]].是否选中 then
            if self.大区列表[大区[i]] then
                self.大区列表[大区[i]]:显示(x + 44, y + 20)
            end
        end
    end
    self.区服背景:显示(x + 66, y + 76)
    self.默认服务器:显示(x + 85, y + 437)
    self.网络状态:显示(x + 380, y + 434)
    if self.区名 then
        self.区名:显示(233, 444)
        self.服名:显示(300 + ((70 - self.服名.宽度) / 2), 441)
        self.状态:显示(301, 461)
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
        { name = '推荐', x = 82, y = 19, tcp = 'gires2/0xE962BC78.tca' }, --0x23AEEF99
        { name = '天界', x = 180, y = 19, tcp = 'gires2/0x9008211B.tca' }, --0x584A2A28
        { name = '人界', x = 278, y = 19, tcp = 'gires2/0xD7272512.tca' }, --0x5A5152FB
        { name = '地界', x = 376, y = 19, tcp = 'gires2/0x0D21DE0F.tca' }, --0x25BF89D3
        { name = '修罗', x = 474, y = 19, tcp = 'gires2/0xD796CD42.tca' } --0x1420EBF1
    } do
        local 按钮 = 标签控件:创建单选按钮(v.name, v.x, v.y, v.name)
        function 按钮:初始化()
            self:设置按钮精灵2(v.tcp)
        end

        local 区域 = 标签控件:创建区域(按钮, 0, 0, 640, 480)
        local 网格 = 区域:创建网格('网格', 70, 79, 488, 324)
        function 网格:初始化()
            self:创建格子(77, 32, 6, 10, 6, 9)
        end

        function 网格:清空()
            self:删除格子()
            self:创建格子(77, 32, 6, 10, 6, 9)
            self.n = 0
        end

        function 网格:子显示(x, y, i)
            if self[i].state then
                self[i].state:显示(x + 4, y + 25)
            end
        end

        function 网格:添加(t, 默认)
            local 状态 = {}
            状态['良好'] = 'red.tcp' --  紫红色 0x75277CF6
            状态['极佳'] = 'green.tcp' --绿色 green
            状态['爆满'] = 'red.tcp' -- 红色 red
            状态['维护'] = 'yellow.tcp' --  蓝色 0x2B8AFB85
            状态['繁忙'] = 'yellow.tcp' --深黄色 yellow
            if not t.服名 then
                return
            end
            self.n = self.n + 1
            local 格子 = self[self.n]
            local 文字按钮 = {}
            local len = string.len(t.服名)
            if len == 9 then
                文字按钮 = 格子:创建文字按钮3(t.服名, 14, 5, t.服名)
            else
                文字按钮 = 格子:创建文字按钮3(t.服名, 11, 5, t.服名)
            end
            格子.state = __res:getspr('gires/login/' .. 状态[t.状态])
            function 文字按钮:左键弹起()
                选择区服.地址 = t.地址
                选择区服.端口 = t.端口
                选择区服.区名 = __res.F18:置颜色(255, 255, 255):取精灵(t.区名)
                选择区服.服名 = __res.F14:置颜色(0, 0, 0):取精灵(t.服名)
                选择区服.状态 = __res:getspr('gires/login/' .. 状态[t.状态])
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

do
    local 进入按钮 = 选择区服:创建小按钮('进入按钮', 413, 434, '进入')
    function 进入按钮:初始化()
        self:设置按钮精灵('gires2/0xC3E7E556.tcp')
    end

    function 进入按钮:左键弹起()
        if 选择区服.地址 then
            __res:保存配置()
            __rpc.地址 = 选择区服.地址
            __rpc.端口 = 选择区服.端口
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

    local 返回按钮 = 选择区服:创建按钮('返回按钮', 528, 434, '返回')
    function 返回按钮:初始化()
        self:设置按钮精灵('gires2/0x9DC16102.tcp')
    end

    function 返回按钮:左键弹起()
        登录层:切换界面(登录层.游戏开始)
    end
end

return 选择区服
