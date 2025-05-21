local _ENV = require('界面/窗口/管理/管理_1')
召唤管理区域 = 标签控件:创建区域(召唤管理按钮, 0, 0, 580, 300)


do
    function 召唤管理区域:初始化()
        self:置精灵(
            生成精灵(
                580,
                300,
                function()
                    __res.JMZ:取图像("召唤兽名称"):显示(10, 2)
                    __res.JMZ:取图像("等级"):显示(210, 2)
                    __res.JMZ:取图像("宝宝"):显示(305, 2)
                    __res.JMZ:取图像("能否交易"):显示(375, 2)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 100, 20):显示(100, 0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 50, 20):显示(245, 0)

                end
            )
        )
    end

    local _能否交易 = true
    local 绑定按钮 = 召唤管理区域:创建多选按钮('绑定按钮', 450, 3)
    function 绑定按钮:初始化()
        local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
        self:置正常精灵(tcp:取精灵(1))
        self:置选中正常精灵(tcp:取精灵(2))
        --    self:置提示('绑定按钮')
        self:置选中(_能否交易)
    end

    function 绑定按钮:选中事件(b)
        _能否交易 = b
    end

    local _宝宝 = true
    local 宝宝按钮 = 召唤管理区域:创建多选按钮('宝宝按钮', 345, 3)
    function 宝宝按钮:初始化()
        local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
        self:置正常精灵(tcp:取精灵(1))
        self:置选中正常精灵(tcp:取精灵(2))
        --    self:置提示('绑定按钮')
        self:置选中(_宝宝)
    end

    function 宝宝按钮:选中事件(b)
        _宝宝 = b
    end

    local 名称输入 = 召唤管理区域:创建文本输入('名称输入', 100 + 3, 2, 100, 14)
    名称输入:置颜色(255, 255, 255, 255)
    local 等级输入 = 召唤管理区域:创建数字输入('等级输入', 245 + 3, 2, 50, 14)
    等级输入:置颜色(255, 255, 255, 255)

    local 发放按钮 = 召唤管理区域:创建小按钮("发放按钮", 375 + 75 + 45, 0, "发放")
    function 发放按钮:左键弹起()
        if _选中角色 then
            local t = {}
            t.名称 = 名称输入:取文本()
            if t.名称 == "" then
                窗口层:提示窗口('#Y请先输入召唤兽名称')
                return
            end
            t.等级 = tonumber(等级输入) or 0
            t.宝宝 = _宝宝
            t.禁止交易 = not _能否交易
            local r = __rpc:角色_GM_发放召唤兽(_当前账号, _选中角色, t)
            if type(r) == "string" then
                窗口层:提示窗口(r)
                return
            end
        else
            窗口层:提示窗口('#Y请先选中操作角色')

        end


    end






end
