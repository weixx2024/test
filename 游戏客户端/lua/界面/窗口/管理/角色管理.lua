local _ENV = require('界面/窗口/管理/管理_1')
角色管理区域 = 标签控件:创建区域(角色管理按钮, 0, 0, 580, 300)

do
    function 角色管理区域:初始化()
        self:置精灵(
            生成精灵(
                485,
                300,
                function()
                    local sf = self:取拉伸图像_宽高('gires/main/border.bmp', 130, 20)
                    for i, v in ipairs {
                        "登录IP",
                        "封  禁",
                        "禁  言",
                        "禁交易",
                        "创  建",
                        "名  称",
                        "等  级",
                        "转  生",
                        "银  子",
                        "V I P",
                        "称  谓",
                    } do
                        __res.JMZ:取图像(v):显示(5, 2 + i * 25)
                        sf:显示(70, i * 25)
                    end
                end
            )
        )
    end

    do  -- 按钮 文本
        for i, v in ipairs { "登录地址", "封禁", "禁言", "禁交易", "创建时间" } do
            local 文本 = 角色管理区域:创建文本(v .. '文本', 72, 4 + i * 25, 130, 14)
        end
        for i, v in ipairs { "名称", "等级", "转生", "银子", "VIP", "称谓" } do
            local 文本 = 角色管理区域:创建文本输入(v .. '文本', 72, 127 + i * 25, 130, 14)
            文本:置颜色(255, 255, 255, 255)
            local 按钮 = 角色管理区域:创建小按钮(v .. "按钮", 205, 122 + i * 25, v ~= "称谓" and "修改" or "修复")
            function 按钮:左键弹起()
                if _选中角色 then
                    if v == "等级" then
                        local leve = tonumber(文本:取文本())
                        if not leve then
                            窗口层:提示窗口('#Y请输入数值')
                            return
                        end
                        local r = __rpc:角色_GM_修改等级(_选中角色, leve)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                        文本:置文本(leve)
                    elseif v == "转生" then
                        local leve = tonumber(文本:取文本())
                        if not leve then
                            窗口层:提示窗口('#Y请输入数值')
                            return
                        end
                        local r = __rpc:角色_GM_修改转生(_选中角色, leve)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                        文本:置文本(leve)
                    elseif v == "银子" then
                        local leve = tonumber(文本:取文本())
                        if not leve then
                            窗口层:提示窗口('#Y请输入数值')
                            return
                        end
                        local r = __rpc:角色_GM_修改银子(_选中角色, leve)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                        文本:置文本(leve)
                    elseif v == "VIP" then
                        local leve = tonumber(文本:取文本())
                        if not leve then
                            窗口层:提示窗口('#Y请输入数值')
                            return
                        end
                        local r = __rpc:角色_GM_修改VIP等级(_选中角色, leve)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                        文本:置文本(leve)
                    elseif v == "名称" then
                        local name = 文本:取文本()
                        if name == "" then
                            窗口层:提示窗口('#Y请输入名称')
                            return
                        end
                        local r = __rpc:角色_GM_修改名称(_选中角色, name)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                        文本:置文本(name)
                    elseif v == "称谓" then
                        local cw = tonumber(文本:取文本())
                        if not cw then
                            窗口层:提示窗口('#Y请输入1-14')
                            return
                        end
                        local r = __rpc:角色_GM_修复称谓(_选中角色, cw)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                        文本:置文本(cw)
                    end
                else
                    窗口层:提示窗口('#Y请先选择要操作的角色')
                end
            end
        end

        local l = 0
        local h = 0
        for i, v in ipairs { "踢出战斗", "回出生地", "强制下线" } do
            l = l + 1
            if l > 3 then
                l = 1
                h = h + 1
            end
            local 按钮 = 角色管理区域:创建中按钮(v .. "按钮", 300 + h * 100, 120 + l * 30, v)

            function 按钮:左键弹起()
                if _选中角色 then
                    if v == "踢出战斗" then
                        local r = __rpc:角色_GM_踢出战斗(_选中角色)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                    elseif v == "回出生地" then
                        local r = __rpc:角色_GM_回出生地(_选中角色)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                    elseif v == "强制下线" then
                        local r = __rpc:角色_GM_强制下线(_选中角色)
                        if type(r) == "string" then
                            窗口层:提示窗口(r)
                            return
                        end
                    end
                else
                    窗口层:提示窗口('#Y请先选择要操作的角色')
                end
            end
        end
    end
end

function 角色管理区域:刷新信息(t)
    for i, v in ipairs { "登录地址", "封禁", "禁言", "禁交易", "创建时间", "名称", "等级", "转生",
        "银子", "VIP" } do
        self[v .. "文本"]:置文本("")
        if t[v] then
            if v == "创建时间" then
                self[v .. "文本"]:置文本(os.date('%Y-%m-%d %H:%M', t[v]))
            elseif v == "封禁" or v == "禁言" or v == "禁交易" then
                self[v .. "文本"]:置文本(t[v] == 0 and "关闭" or "开启")
            else
                self[v .. "文本"]:置文本(t[v])
            end
        end
    end
end

function 角色管理区域:可见事件(v)
    if v then
        if not _选中角色 then
        else
            local t = __rpc:角色_取管理数据(_选中角色)
            if type(t) == "table" then
                角色管理区域:刷新信息(t)
            end
        end
    end
end
