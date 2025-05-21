local _ENV = require('界面/窗口/管理/管理_1')
账号管理区域 = 标签控件:创建区域(账号管理按钮, 0, 0, 580, 300)
do
    function 账号管理区域:初始化()
        self:置精灵(
            生成精灵(
                485,
                300,
                function()
                    self:取拉伸图像_宽高('gires/main/border.bmp', 248, 158):显示(5, 25)
                    __res.JMZ:取图像('角色列表'):显示(95, 2)
                    __res.JMZ:取图像('账号信息'):显示(95, 190)
                    __res.JMZ:取图像('账  号'):显示(5, 210)
                    __res.JMZ:取图像('密  码'):显示(5, 235)
                    __res.JMZ:取图像('安全码'):显示(5, 260)
                    local sf = self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20)
                    for i, v in ipairs { "累计", "I  P", "点数", "首充", "标签", "管理", "封禁", "仙玉", } do
                        __res.JMZ:取图像(v):显示(280, 2 + i * 25 - 25)
                        sf:显示(325, i * 25 - 25)
                    end
                    sf:显示(60, 210):显示(60, 235):显示(60, 260)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20):显示(288, 210)
                end
            )
        )
    end

    local 角色列表 = 账号管理区域:创建多列列表('角色列表', 8, 28, 240, 150)

    function 角色列表:初始化()
        self.行高度 = 25
        self:取文字():置大小(20)
        self:添加列(0, 3, 105, 20)  -- 名称
        self:添加列(105, 3, 65, 20) -- 等级
        self:添加列(170, 3, 20, 20) -- 种族
        self:添加列(190, 3, 50, 20) -- 性别
    end

    function 角色列表:添加角色(i, t)
        local r = self:添加(t.名称, t.转生 .. "转" .. t.等级, _性别[t.性别], _种族[t.种族])
        r.角色id = t.id
        r.nid = t.nid
    end

    function 角色列表:左键弹起(x, y, i, t)
        _选中角色 = t.nid
    end

    for k, v in ipairs { "修改账号", "修改密码", "修改安全码" } do
        local 输入 = 账号管理区域:创建文本输入(v .. '输入', 63, 212 + k * 25 - 25, 120, 14)
        输入:置颜色(255, 255, 255, 255)
        local 按钮 = 账号管理区域:创建小按钮(v .. "按钮", 205, 180 + k * 25, "修改")
        function 按钮:左键弹起(x, y, i, t)
            if _当前账号 then
                if v == "修改账号" then
                    local r = 账号管理区域.修改账号输入:取文本()
                    if r == "" or r == _当前账号 then
                        窗口层:提示窗口('#Y请输入修改账号内容')
                        return
                    end
                    local n = __rpc:角色_GM_修改账号(_当前账号, r)

                    if type(n) == "string" then
                        窗口层:提示窗口(n)
                        return
                    end
                    _当前账号 = r
                    窗口层:置账号(r)
                    账号管理区域.修改账号输入:置文本(r)
                elseif v == "修改密码" then
                    local r = 账号管理区域.修改密码输入:取文本()
                    if r == "" then
                        窗口层:提示窗口('#Y请输入修改密码内容')
                        return
                    end
                    if #r ~= 32 then
                        r = GGF.MD5(r)
                    end
                    local n = __rpc:角色_GM_修改密码(_当前账号, r)

                    if type(n) == "string" then
                        窗口层:提示窗口(n)
                        return
                    end
                    账号管理区域.修改密码输入:置文本(r)
                elseif v == "修改安全码" then
                    local r = 账号管理区域.修改安全码输入:取文本()
                    if r == "" then
                        窗口层:提示窗口('#Y请输入修改安全码内容')
                        return
                    end
                    local n = __rpc:角色_GM_修改安全码(_当前账号, r)

                    if type(n) == "string" then
                        窗口层:提示窗口(n)
                        return
                    end
                    账号管理区域.修改安全码输入:置文本(r)
                end
            end
        end
    end
    local _管理权限 = { "普通权限", "中级权限", "高级权限", "至尊权限" }
    for i, v in ipairs { "I  P", "点数", "首充", "标签", "管理", "封禁", "仙玉", } do
        local 输入 = 账号管理区域:创建文本输入(v .. '输入', 328, 2 + i * 25, 130, 14)
        输入:置颜色(255, 255, 255, 255)

        local name = "修改"
        local name2 = "刷新"
        if v == "封禁" or v == "I  P" then
            name = "封禁"
            name2 = "解封"
        end


        local 按钮 = 账号管理区域:创建小按钮(v .. "按钮", 465, i * 25 - 3, name)
        local 刷新按钮 = 账号管理区域:创建小按钮(v .. "刷新按钮", 465 + 60, i * 25 - 3, name2)


        function 按钮:左键弹起()
            if _当前账号 then
                if v == "管理" then
                    local n = tonumber(输入:取文本())
                    if not n then
                        窗口层:提示窗口('#Y请输入数值0-4')
                        return
                    end
                    if n < 0 or n > 4 then
                        窗口层:提示窗口('#Y请输入数值0-4')
                        return
                    end
                    local r = __rpc:角色_GM_修改权限(_当前账号, n)
                    if type(r) == "string" then
                        窗口层:提示窗口(r)
                        return
                    end
                    -- 账号管理区域.管理输入:置文本(_管理权限[n] or "无")
                    输入:置文本(_管理权限[n] or "无")
                elseif v == "I  P" then
                    if _账号数据 then
                        local r = __rpc:角色_GM_封禁IP(_账号数据.IP, 1)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                    end



                elseif v == "点数" then
                    local n = tonumber(输入:取文本())
                    if not n then
                        窗口层:提示窗口('#Y请输入数值')
                        return
                    end
                    local r = __rpc:角色_GM_修改点数(_当前账号, n)
                    if type(r) == "string" then
                        窗口层:提示窗口(r)
                        return
                    end
                    输入:置文本(n)
                elseif v == "首充" then
                    local r = 输入:取文本()
                    if r == "" then
                        窗口层:提示窗口('#Y请输入要修改的标签内容')
                        return
                    end
                    local s = __rpc:角色_GM_修改首充标签(_当前账号, r)
                    if type(s) == "string" then
                        窗口层:提示窗口(s)
                        return
                    end
                    输入:置文本(r)

                elseif v == "标签" then
                    local r = 输入:取文本()
                    if r == "" then
                        窗口层:提示窗口('#Y请输入要修改的标签内容')
                        return
                    end
                    local s = __rpc:角色_GM_修改标签(_当前账号, r)
                    if type(s) == "string" then
                        窗口层:提示窗口(s)
                        return
                    end
                    输入:置文本(r)
                elseif v == "封禁" then
                    local r = __rpc:角色_GM_封禁账号(_当前账号, 1)
                    if type(r) == "string" then
                        窗口层:提示窗口(r)
                        return
                    end
                    输入:置文本("开启")
                elseif v == "仙玉" then
                    local n = tonumber(输入:取文本())
                    if not n then
                        窗口层:提示窗口('#Y请输入数值')
                        return
                    end
                    local r = __rpc:角色_GM_修改仙玉(_当前账号, n)
                    if type(r) == "string" then
                        窗口层:提示窗口(r)
                        return
                    end
                    输入:置文本(n)
                end
            end
        end

        function 刷新按钮:左键弹起()
            if v == "封禁" then
                local r = __rpc:角色_GM_封禁账号(_当前账号, 0)
                if type(r) == "string" then
                    窗口层:提示窗口(r)
                    return
                end
                输入:置文本("关闭")

            elseif v == "I  P" then

                if _账号数据 then
                    local r = __rpc:角色_GM_封禁IP(_账号数据.IP)
                    if type(r) == "string" then
                        窗口层:提示窗口(r)
                        return
                    end
                end

            end

        end
    end
    local 发放仙玉输入 = 账号管理区域:创建数字输入('发放仙玉输入', 290, 212, 120, 14)
    发放仙玉输入:置颜色(255, 255, 255, 255)


    local 累计输入 = 账号管理区域:创建文本输入('累计输入', 328, 2, 130, 14)
    累计输入:置颜色(255, 255, 255, 255)




    local 发放按钮 = 账号管理区域:创建中按钮("发放按钮", 420, 207, "发放仙玉")
    do
        local 封禁角色按钮 = 账号管理区域:创建中按钮("封禁角色按钮", 280, 210 + 30, "封禁角色")
        local 角色禁言按钮 = 账号管理区域:创建中按钮("角色禁言按钮", 380, 210 + 30, "角色禁言")
        local 封禁交易按钮 = 账号管理区域:创建中按钮("封禁交易按钮", 480, 210 + 30, "封禁交易")
        local 解封角色按钮 = 账号管理区域:创建中按钮("解封角色按钮", 280, 240 + 30, "解封角色")
        local 解除禁言按钮 = 账号管理区域:创建中按钮("解除禁言按钮", 380, 240 + 30, "解除禁言")
        local 解除交易按钮 = 账号管理区域:创建中按钮("解除交易按钮", 480, 240 + 30, "解除交易")
        function 封禁角色按钮:左键弹起()
            if _选中角色 then
                local r = __rpc:角色_GM_封禁角色(_当前账号, _选中角色, 1)
                if type(r) == "string" then
                    窗口层:提示窗口(r)
                    return
                end
                -- 账号管理区域.管理输入:置文本(_管理权限[n] or "无")
                -- 输入:置文本(_管理权限[n] or "无")
            else
                窗口层:提示窗口('#Y请先选择要操作的角色')
            end
        end

        function 解封角色按钮:左键弹起()
            if _选中角色 then
                local r = __rpc:角色_GM_解封角色(_当前账号, _选中角色, 0)
                if type(r) == "string" then
                    窗口层:提示窗口(r)
                    return
                end
                -- 账号管理区域.管理输入:置文本(_管理权限[n] or "无")
                -- 输入:置文本(_管理权限[n] or "无")
            else
                窗口层:提示窗口('#Y请先选择要操作的角色')
            end
        end

        function 角色禁言按钮:左键弹起()
            if _选中角色 then
                local r = __rpc:角色_GM_角色禁言(_当前账号, _选中角色, 1)
                if type(r) == "string" then
                    窗口层:提示窗口(r)
                    return
                end
                -- 账号管理区域.管理输入:置文本(_管理权限[n] or "无")
                -- 输入:置文本(_管理权限[n] or "无")
            else
                窗口层:提示窗口('#Y请先选择要操作的角色')
            end
        end

        function 解除禁言按钮:左键弹起()
            if _选中角色 then
                local r = __rpc:角色_GM_解除禁言(_当前账号, _选中角色, 0)
                if type(r) == "string" then
                    窗口层:提示窗口(r)
                    return
                end
                -- 账号管理区域.管理输入:置文本(_管理权限[n] or "无")
                -- 输入:置文本(_管理权限[n] or "无")
            else
                窗口层:提示窗口('#Y请先选择要操作的角色')
            end
        end

        function 封禁交易按钮:左键弹起()
            if _选中角色 then
                local r = __rpc:角色_GM_角色封禁交易(_当前账号, _选中角色, 1)
                if type(r) == "string" then
                    窗口层:提示窗口(r)
                    return
                end
                -- 账号管理区域.管理输入:置文本(_管理权限[n] or "无")
                -- 输入:置文本(_管理权限[n] or "无")
            else
                窗口层:提示窗口('#Y请先选择要操作的角色')
            end
        end

        function 解除交易按钮:左键弹起()
            if _选中角色 then
                local r = __rpc:角色_GM_解除封禁交易(_当前账号, _选中角色, 0)
                if type(r) == "string" then
                    窗口层:提示窗口(r)
                    return
                end
                -- 账号管理区域.管理输入:置文本(_管理权限[n] or "无")
                -- 输入:置文本(_管理权限[n] or "无")
            else
                窗口层:提示窗口('#Y请先选择要操作的角色')
            end
        end
    end

    function 发放按钮:左键弹起()
        if _当前账号 then
            local n = 发放仙玉输入:取文本()
            if n == "" or n == "0" then
                窗口层:提示窗口('#Y请输入发放数值')
                return
            end
            if 窗口层:确认窗口('是否给账号#C%s#W发放#G%s#W仙玉  (请仔细#R确认发放账号与数额#W,以免造成不必要的麻烦！)'
                , _当前账号, n) then
                local r, yx = __rpc:角色_GM_仙玉充值(_当前账号, n)
                if type(r) == "string" then
                    窗口层:提示窗口(r)
                    return
                end
                发放仙玉输入:置文本(0)
                if yx then
                    账号管理区域.仙玉输入:置文本(yx)
                end
            end
        else
            窗口层:提示窗口('#Y请输入操作账号')
        end


    end

    function 账号管理区域:刷新账号信息(t)
        for i, v in ipairs { "修改账号输入", "修改密码输入", "修改安全码输入", "点数输入",
            "I  P输入",
            "首充输入", "管理输入", "标签输入", "仙玉输入", "封禁输入" } do
            self[v]:置文本("")
        end
        self.修改账号输入:置文本(t.账号)
        self.修改密码输入:置文本(t.密码)
        self.修改安全码输入:置文本(t.安全)
        self["I  P输入"]:置文本(t.IP)
        self.点数输入:置文本(t.点数)
        self.首充输入:置文本(t.首充)
        self.管理输入:置文本(_管理权限[t.管理] or "无")
        self.标签输入:置文本(t.体验)
        self.封禁输入:置文本(t.封禁 == 0 and "关闭" or "开启")
        self.仙玉输入:置文本(t.仙玉)
        累计输入:置文本(t.累充)
        发放仙玉输入:置文本(0)
        _当前账号 = t.账号
        _账号数据 = t
    end

    function 账号管理区域:刷新角色列表信息(t)
        if type(t) ~= "table" then
            return
        end
        for i, v in ipairs(t) do
            角色列表:添加角色(i, v)
        end
    end

end
