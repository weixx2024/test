local _ENV = require('界面/窗口/管理/管理_1')
服务器管理区域 = 标签控件:创建区域(服务器管理按钮, 0, 0, 580, 300)


do

    function 服务器管理区域:初始化()
        self:置精灵(
            生成精灵(
                580,
                300,
                function()
                    __res.JMZ:取图像("公告"):显示(10, 3)
                    __res.JMZ:取图像("账号"):显示(15, 125)
                    __res.JMZ:取图像("封禁"):显示(150, 125)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 480, 20):显示(45, 3)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20):显示(5, 90)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 185, 155):显示(2, 140)
                end
            )
        )
    end

    local 公告输入 = 服务器管理区域:创建文本输入('公告输入', 48, 5, 480, 14)
    公告输入:置颜色(255, 255, 255, 255)

    local 发送按钮 = 服务器管理区域:创建小按钮("发送按钮", 530, 0, "发送")
    function 发送按钮:左键弹起()
        local txt = 公告输入:取文本()
        if txt == "" then
            窗口层:提示窗口('#Y请输入公告内容')
            return
        end
        __rpc:角色_GM_发送公告(txt)

    end

    for k, v in pairs { "保存数据", "关闭服务器", "重置日常", "重置双倍", "查询人数" } do --, "查询IP"
        local 按钮 = 服务器管理区域:创建中按钮(v .. "按钮", 20 + k * 100 - 100, 50, v)
        function 按钮:左键弹起()
            if v == "保存数据" then
                __rpc:角色_GM_保存数据()
            elseif v == "关闭服务器" then
                __rpc:角色_GM_关闭服务器()
            elseif v == "重置日常" then
                __rpc:角色_GM_重置日常()
            elseif v == "重置双倍" then
                __rpc:角色_GM_重置双倍()
            elseif v == "查询人数" then
                __rpc:角色_GM_查询人数()
            elseif v == "查询IP" then
                __rpc:角色_GM_查询IP账号()
            end
        end
    end



    local 账号列表 = 服务器管理区域:创建多列列表('账号列表', 5, 145, 180, 150)

    function 账号列表:初始化()
        self:添加列(0, 1, 155, 20) --账号
        self:添加列(155, 1, 20, 20) --封禁

    end

    function 账号列表:添加账号(t)
        local r = self:添加(t.账号, t.封禁 == 0 and "关" or "开")
        r.数据 = t
    end

    local IP输入 = 服务器管理区域:创建文本输入('IP输入', 8, 92, 130, 14)
    IP输入:置颜色(255, 255, 255, 255)
    local IP按钮 = 服务器管理区域:创建小按钮("IP按钮", 150, 88, "查询")
    function IP按钮:左键弹起()
        local t = __rpc:角色_GM_查询IP账号(IP输入:取文本())
        账号列表:清空()
        if type(t) == "table" then
            for i, v in ipairs(t) do
                账号列表:添加账号(v)
            end
        end
    end

    local IP按钮2 = 服务器管理区域:创建小按钮("IP按钮2", 150 + 50, 88, "全封")
    function IP按钮2:左键弹起()
        local t = __rpc:角色_GM_封禁IP2(IP输入:取文本())
        账号列表:清空()
        if type(t) == "table" then
            for i, v in ipairs(t) do
                账号列表:添加账号(v)
            end
        end
    end

    local 查询邀请 = 服务器管理区域:创建小按钮("查询邀请", 150 + 50, 120, "邀请")
    function 查询邀请:左键弹起()
        __rpc:角色_GM_查询邀请数据(IP输入:取文本()) --还是直接提示数量 是
    end


    for k, v in pairs { "开启帮战报名", "开启帮战进场", "开启帮战", "关闭帮战" } do --, "查询IP"
        local 按钮 = 服务器管理区域:创建中按钮(v .. "按钮", 270 + 215, 88 + k * 50 - 50, v)
        function 按钮:左键弹起()
            if v == "开启帮战报名" then
                __rpc:角色_GM_开启帮战报名()
            elseif v == "开启帮战进场" then
                __rpc:角色_GM_开启帮战进场()
            elseif v == "开启帮战" then
                __rpc:角色_GM_开启帮战()
            elseif v == "关闭帮战" then
                __rpc:角色_GM_关闭帮战()
            end
        end
    end

    for k, v in pairs { "开启水陆报名", "开启水陆进场", "开启水陆", "关闭水陆" } do --, "查询IP"
        local 按钮 = 服务器管理区域:创建中按钮(v .. "按钮", 270 + 115, 88 + k * 50 - 50, v)
        function 按钮:左键弹起()
            if v == "开启水陆报名" then
                __rpc:角色_GM_开启水陆报名()
            elseif v == "开启水陆进场" then
                __rpc:角色_GM_开启水陆进场()
            elseif v == "开启水陆" then
                __rpc:角色_GM_开启水陆()
            elseif v == "关闭水陆" then
                __rpc:角色_GM_关闭水陆()
            end
        end
    end
    for k, v in pairs { "开启大闹进场", "开启大闹", "结束大闹" } do --, "查询IP"
        local 按钮 = 服务器管理区域:创建中按钮(v .. "按钮", 270 + 15, 88 + k * 50 - 50, v)
        function 按钮:左键弹起()
            if v == "开启大闹进场" then
                __rpc:角色_GM_开启大闹进场()
            elseif v == "开启大闹" then
                __rpc:角色_GM_开启大闹()
            elseif v == "结束大闹" then
                __rpc:角色_GM_关闭大闹()

            end
        end
    end

end
