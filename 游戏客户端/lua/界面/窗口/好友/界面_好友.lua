local py = 0
if gge.platform ~= 'Windows' then
    py = 130
end
local 好友 = 窗口层:创建我的窗口('好友', -105, 50, 100, 520 - py)
do
    function 好友:初始化()
        self:置精灵(
            生成精灵(
                100,
                520 - py,
                function()
                    -- self:取拉伸图像_宽高('gires4/jdmh/yjan/lbkdt.tcp', 100, 520):置颜色(0, 0, 0, 150):显示(0, 0)
                    self:取拉伸图像_宽高('gires4/jdmh/yjan/lbkdt.tcp', 100, 35):置颜色(0, 0, 0, 255):显示(0,
                        0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 100, 487 - py):显示(0, 0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 100, 35):显示(0, 0):显示(0, 485 - py)
                    __res.F18B:置颜色(214, 195, 0)
                    __res.F18B:取图像('好友列表'):显示(10, 10)
                    __res.F18B:置颜色(255, 255, 255)
                end
            )
        )
    end

    for k, v in pairs {
        { name = '添加按钮', zy = '0xB6843921.tcp' },
        { name = '搜索按钮', zy = '0x391694AB.tcp' },
        { name = '上翻按钮', zy = '0xF769EEF2.tcp' },
        { name = '下翻按钮', zy = '0x03539D9C.tcp' }
    } do
        local 按钮 = 好友:创建按钮(v.name, 7 + k * 22 - 22, -27)
        do
            function 按钮:初始化()
                self:设置按钮精灵('gires/%s', v.zy)
            end

            function 按钮:左键弹起()
                if v.name == "搜索按钮" then
                    窗口层:打开在线查询()
                elseif v.name == "添加按钮" then
                    鼠标层:好友形状()
                end
            end
        end
    end
end

-- 好友:创建关闭按钮()

-- ===================================================================
local 好友列表 = 好友:创建列表('好友列表', 3, 35, 94, 450 - py)
do
    function 好友列表:初始化()
        self:置文字(self:取文字():置颜色(255, 255, 255, 255):置大小(16))
        -- for i = 1, 50 do
        --     self:添加好友(i, '好友' .. i)
        -- end
        -- self:置项目颜色(1, 187, 165, 75)
    end

    function 好友列表:添加好友(i, t)
        local r = self:添加(t.名称)
        r:取精灵():置中心(0, -2)
        r:置高度(20)
        r.数据 = t
        if t.状态 ~= "离线" then
            self:置项目颜色(i, 117, 213, 87)
        end
    end

    function 好友列表:左键弹起(x, y, i, t)
        窗口层:打开聊天窗口(t.数据, true)
    end
end


function 窗口层:刷新好友列表()
    if not 好友.是否可见 then
        return
    end
    好友列表:清空()
    local t = __rpc:角色_获取好友列表()
    local t2 = 时间排序(t)
    local list = {} -- 时间排序(t)
    for i, v in ipairs(t2) do
        if v.状态 ~= "离线" then
            table.insert(list, v)
        end
    end

    for i, v in ipairs(t2) do
        if v.状态 ~= "在线" then
            table.insert(list, v)
        end
    end

    for i, v in ipairs(list) do
        好友列表:添加好友(i, v)
    end
end

function 窗口层:打开好友()
    好友:置可见(not 好友.是否可见)
    if not 好友.是否可见 then
        return
    end

    窗口层:刷新好友列表()
end

function RPC:刷新好友列表()
    窗口层:刷新好友列表()
end

return 好友
