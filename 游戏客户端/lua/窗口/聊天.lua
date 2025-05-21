local SDL = require 'SDL'
local GUI = require '界面'

local _ENV = setmetatable({}, { __index = _G })

引擎:注册事件(
    _ENV,
    {
        窗口事件 = function(_, 消息, ...)
            local t = select(select('#', ...), ...)

            if 窗口 then
                if 消息 == SDL.WINDOWEVENT_MOVED then -- 窗口移动
                    local x, y = 窗口:取坐标()
                    if x < t.data1 then
                        窗口:置坐标(t.data1 - 窗口.宽度 - 2, t.data2)
                    else
                        窗口:置坐标(t.data1 + 引擎.宽度 + 2, t.data2)
                    end
                elseif 消息 == SDL.WINDOWEVENT_SIZE_CHANGED then -- 窗口大小
                end
            end
        end
    }
)

local 背景 = { __res:getsf('gires/chatbg.bmp'):平铺(800, 引擎.高度):到精灵() }
for i = 1, 8 do
    table.insert(背景, __res:getsf('gires/chatbg%d.bmp', i):平铺(800, 引擎.高度):到精灵())
end
for i = 1, 5 do
    table.insert(背景, __res:getspr('gires/qjdt/%d.tcp', i))
end
for i, v in ipairs(背景) do
    v.id = i
    v.next = 背景[i + 1]
    if not v.next then
        v.next = 背景[1]
    end
end

function 打开(_, 主列表)
    窗口 =
        引擎:创建窗口 {
            标题 = '聊天窗口',
            宽度 = 300,
            帧率 = 30,
            鼠标 = false,
            可调整 = true,
            渲染器 = false
        }

    function 窗口:初始化()
        self:置最小宽高(250, 引擎.高度)
        self:置最大宽高(引擎.宽度, 引擎.高度)

        纹理 = 引擎:创建纹理(引擎.宽度, 引擎.高度)
        图像 = self:创建图像(引擎.宽度, 引擎.高度)
        local x, y = 引擎:取坐标()
        self:置坐标(x + 引擎.宽度 + 5, y)

        do
            界面 = require('GUI')(窗口, __res.F14)
            界面:置渲染窗口(引擎)

            local 弹出控件 = 界面:创建弹出控件('弹出控件')
            local 弹出右键
            do
                local 列表 = 弹出控件:创建列表('右键列表', 5, 5, 90, 90)
                function 列表:初始化()
                    列表:取文字():置颜色(255, 255, 255, 255)
                    列表.焦点精灵:置颜色(88, 92, 232, 200)
                    列表.选中精灵 = nil
                    列表.行间距 = 3
                end

                function 列表:左键弹起()
                    弹出控件:置可见(false)
                    coroutine.xpcall(self.co, self:取文本(self.选中行))
                end

                function 弹出右键(list)
                    if 弹出控件.是否可见 then
                        return
                    end
                    列表:清空()
                    列表.co = coroutine.running()
                    local w = 80
                    for _, v in ipairs(list) do
                        local r = 列表:添加(v)
                        if r:取精灵().宽度 > 80 then
                            w = r:取精灵().宽度
                        end
                    end
                    弹出控件:置精灵(弹出控件:取拉伸精灵_宽高('gires4/jdmh/yjan/tmk2.tcp'
                    , w + 10, #list * 18 + 7), true)
                    列表:置宽高(w, 弹出控件.高度 - 10)

                    local x, y = 引擎:取鼠标坐标()
                    弹出控件:置坐标(x, y)
                    弹出控件:置可见(true)
                    return coroutine.yield()
                end
            end

            local function 创建屏幕(n)
                local 屏幕 = 界面:创建界面('屏幕' .. n, 0, 0, 800, 引擎.高度2)
                do
                    屏幕.背景 = 背景[1]
                    function 屏幕:显示()
                        self.背景:显示(0, 0)
                    end

                    function 屏幕:获得鼠标()
                        if 鼠标 then
                            鼠标:正常形状()
                        end
                    end
                end

                do -- 聊天列表
                    local 聊天列表 = 屏幕:创建列表('聊天列表', 5, 5, 窗口.宽度 - 10, 引擎.高度2 -
                        30)

                    function 聊天列表:初始化()
                        self.选中精灵 = nil
                        self.焦点精灵 = nil
                        self.行间距 = 2
                        self.内容记录 = {}
                        self:自动滚动(true)
                    end

                    function 聊天列表:重置内容(t)
                        聊天列表:清空()
                        for i = 1, 50 do
                            table.remove(self.内容记录, 1)
                        end
                        for index, value in ipairs(self.内容记录) do
                            聊天列表:添加内容(value, 1)
                        end
                    end

                    function 聊天列表:添加内容(t, s)
                        if not s then
                            table.insert(self.内容记录, t)
                            if #self.内容记录 >= 100 then
                                聊天列表:重置内容()
                                return
                            end
                        end
                        local r = self:添加(t):置精灵()
                        local 文本 = r:创建我的文本('文本', 0, 0, self.宽度, 500)
                        文本.获得回调 = 聊天列表.文本获得回调
                        文本.回调左键弹起 = 聊天列表.文本回调左键弹起
                        文本.回调右键弹起 = 聊天列表.文本回调右键弹起
                        local _, h = 文本:置文本(t)
                        文本:置高度(h)
                        r:置高度(h)
                        r:置可见(true, true)
                    end

                    function 聊天列表:置聊天列表宽度(w)
                        for _, v in self:遍历项目() do
                            v:置宽度(w)
                            local _, h = v.文本:置宽度(w)
                            v.文本:置高度(h)
                            v:置高度(h)
                        end
                        self:置宽度(w)
                    end

                    function 聊天列表:文本回调左键弹起(nid)
                        if nid:match('0|(.*)') == nil then
                            local t, d = __rpc:角色_查看对象(nid)
                            if t == 1 then -- 物品
                                local r = require('界面/数据/物品')(d)
                                GUI.窗口层:打开物品提示(r)
                            elseif t == 2 then -- 召唤
                                GUI.窗口层:打开召唤兽查看(d)
                            end
                        end
                    end

                    function 聊天列表:文本回调右键弹起(v)
                        local nid = v:match('0|(.*)')
                        if nid then
                            主列表:文本右键返回(
                                nid,
                                弹出右键 {
                                    '加为好友',
                                    -- '临时好友',
                                    '屏蔽发言',
                                    '查看装备'
                                }
                            )
                        end
                    end

                    function 聊天列表:文本获得回调(x, y, v)
                        if 鼠标 then
                            鼠标:手指形状()
                        end
                    end

                    function 主列表:文本右键返回(nid, v)
                        if v == "加为好友" then
                            coroutine.xpcall(function()
                                local r = __rpc:角色_添加好友(nid)
                            end)
                        end
                    end

                    -- function 聊天列表:鼠标滚轮(v)
                    --     self:自动滚动(v)
                    --     屏幕.滚动按钮:置选中(not v)
                    -- end
                end

                do --按钮栏背景
                    local 底栏按钮 = 屏幕:创建按钮('底栏', 0, -28)
                    底栏按钮:置正常精灵(__res:getsf('gires/qjdt/dl.tcp'):置拉伸(800, 33):到精灵())

                    if n == 1 then
                        function 底栏按钮:获得鼠标()
                            if 鼠标 then
                                鼠标:拉伸形状()
                            end
                        end

                        function 底栏按钮:左键按住(_, _, _, y)
                            if y < 120 then
                                y = 120
                            end
                            if y > 引擎.高度 - 120 then
                                y = 引擎.高度 - 120
                            end

                            屏幕1:置高度(y)
                            屏幕1.聊天列表:置高度(y - 30)
                            屏幕1.聊天列表:自动滚动(true)

                            屏幕2:置坐标(0, y)
                            屏幕2:置高度(引擎.高度 - y)
                            屏幕2.聊天列表:置高度(引擎.高度 - y - 30)
                            屏幕2.聊天列表:自动滚动(true)
                            __设置.是否分屏 = 引擎.高度 - y
                            __rpc:角色_设置('是否分屏', 引擎.高度 - y)
                        end
                    end
                end

                for i, v in ipairs {
                    -- 按钮列表
                    { name = '左键按钮', 提示 = '#Y切换聊天窗口', zy = 'gires/0xAC7A2729.tcp' },
                    { name = '上键按钮', 提示 = '#Y上滚', zy = 'gires/0x287AF2DA.tcp' },
                    { name = '下键按钮', 提示 = '#Y下滚', zy = 'gires/0x03539D9C.tcp' },
                    { name = '频道选择按钮', 提示 = '#Y频道选择', zy = 'gires/0xF769EEF2.tcp' },
                    { name = '屏蔽按钮', 提示 = '#Y屏蔽(左)/屏蔽菜单(右)', zy = 'gires/0x46FA19C4.tcp' },
                    { name = '更换背景按钮', 提示 = '#Y屏蔽(左)/屏蔽菜单(右)',
                        zy = 'gires/0x18842C5F.tcp' },
                    { name = '滚动按钮', 提示 = '#Y滚动开关', zy = 'gires/0x67EF0AB9.tcp' },
                    { name = '历史按钮', 提示 = '#Y聊天记录', zy = 'gires/0xFF40DFF7.tcp' },
                    { name = '搜加按钮', zy = 'gires/0x391694AB.tcp' },
                    { name = '分屏按钮', zy = 'gires/0x.tcp' }
                } do
                    local 按钮
                    if v.name == '滚动按钮' then
                        按钮 = 屏幕:创建多选按钮(v.name, 2 + (i - 1) * 20, -22)
                        function 按钮:初始化()
                            self:设置按钮精灵(v.zy)
                            self:设置按钮精灵3('gires/0xEAD167C3.tcp')
                            -- 按钮:置提示(v.提示)
                        end

                        function 按钮:选中事件(b)
                            屏幕.聊天列表:自动滚动(not b)
                            if not b then
                                屏幕.聊天列表:滚动到底()
                            end
                        end
                    elseif v.name == '频道选择按钮' then
                        按钮 = 屏幕:创建按钮(v.name, 2 + (i - 1) * 20, -22)
                        function 按钮:初始化()
                            self:置正常精灵(__res:getspr('ui/xz1.png'))
                            self:置经过精灵(__res:getspr('ui/xz2.png'))
                        end

                        function 按钮:获得鼠标()
                            GUI.鼠标层:手指形状()
                        end

                        function 按钮:左键弹起()
                            if not __设置.聊天频道 then
                                __设置.聊天频道 = {}
                            end
                            local r = GUI.窗口层:打开选择频道(__设置.聊天频道[n + 1])

                            __设置.聊天频道[n + 1] = r
                            __rpc:角色_设置('聊天频道', __设置.聊天频道)
                        end
                    elseif v.name == '分屏按钮' then
                        按钮 = 屏幕:创建按钮(v.name, 2 + (i - 1) * 20, -22)
                        function 按钮:初始化()
                            self:置正常精灵(__res:getspr('ui/fenping1.png'))
                            self:置经过精灵(__res:getspr('ui/fenping2.png'))
                        end

                        function 按钮:获得鼠标()
                            GUI.鼠标层:手指形状()
                        end

                        function 按钮:左键弹起()
                            if 屏幕2.是否可见 then
                                屏幕1:置高度(引擎.高度)
                                屏幕1.聊天列表:置高度(引擎.高度 - 30)
                                屏幕2:置可见(false)
                                __设置.是否分屏 = false
                            else
                                屏幕1:置高度(引擎.高度2)
                                屏幕2:置坐标(0, 引擎.高度2)
                                屏幕2:置高度(引擎.高度2)
                                屏幕2:置可见(true)
                                __设置.是否分屏 = 引擎.高度2
                            end
                            __rpc:角色_设置('是否分屏', __设置.是否分屏)
                        end
                    else
                        按钮 = 屏幕:创建按钮(v.name, 2 + (i - 1) * 20, -22)
                        按钮:设置按钮精灵(v.zy)
                        function 按钮:左键弹起()
                            if v.name == '左键按钮' then
                                local list = {}
                                for _, v in 屏幕1.聊天列表:遍历项目文本() do
                                    table.insert(list, v)
                                end
                                for _, v in 屏幕2.聊天列表:遍历项目文本() do
                                    table.insert(list, v)
                                end
                                纹理 = nil
                                图像 = nil
                                界面 = nil
                                collectgarbage()
                                窗口:关闭()
                                窗口 = nil

                                _ENV:关闭(list)
                                GUI.界面层:哈哈比比()
                            elseif v.name == '上键按钮' then
                            elseif v.name == '下键按钮' then
                            elseif v.name == '屏蔽按钮' then
                            elseif v.name == '更换背景按钮' then
                                屏幕.背景 = 屏幕.背景.next
                                __设置.聊天背景[n] = 屏幕.背景.id
                                __rpc:角色_设置('聊天背景', __设置.聊天背景)
                            elseif v.name == '历史按钮' then
                                GUI.窗口层:打开聊天记录(屏幕.聊天列表)
                            elseif v.name == '搜加按钮' then
                            end
                        end
                    end
                end

                屏幕:置可见(true, true)
                return 屏幕
            end

            屏幕1 = 创建屏幕(1)
            屏幕2 = 创建屏幕(2)
            屏幕2:置坐标(0, 引擎.高度2)

            for _, v in 主列表:遍历项目文本() do
                屏幕2.聊天列表:添加内容(v)
            end

            if __设置 then
                if not __设置.聊天背景 then
                    __设置.聊天背景 = { 2, 2 }
                end
                屏幕1.背景 = 背景[__设置.聊天背景[1]]

                if __设置.是否分屏 then
                    屏幕1.底栏:左键按住(_, _, _, 引擎.高度 - __设置.是否分屏)
                    屏幕2.背景 = 背景[__设置.聊天背景[2]]
                else
                    屏幕1.分屏按钮:左键弹起()
                end
                if __设置.聊天窗口 then
                    窗口:置宽高(__设置.聊天窗口, 引擎.高度)
                end
            end
        end
    end

    function 窗口:更新事件(dt, x, y)
        if 界面 then
            界面:更新(dt, x, y)
        end

        -- 显示到渲染区，然后截图到图像
        if 纹理 and 纹理:渲染开始() then
            if 界面 then
                界面:显示(x, y)
            end
            if 鼠标 then
                鼠标:显示(x, y)
            end
            引擎:截图到图像(图像, 0, 0, self.宽度, self.高度)
            纹理:渲染结束()
        end
    end

    function 窗口:渲染事件(dt, x, y)
        -- self:渲染开始(0x70,0x70,0x70)
        if 图像 then
            图像:显示(0, 0)
            self:渲染结束()
        end
    end

    function 窗口:窗口事件(消息, w, h)
        if 消息 == SDL.WINDOWEVENT_MOVED then
            local x, y = 引擎:取坐标()
            if w < x then
                窗口:置坐标(x - 窗口.宽度 - 2, y)
            else
                窗口:置坐标(x + 引擎.宽度 + 2, y)
            end
        elseif 消息 == SDL.WINDOWEVENT_ENTER then
            鼠标 = GUI.鼠标层
        elseif 消息 == SDL.WINDOWEVENT_LEAVE then
            鼠标 = nil
        elseif 消息 == SDL.WINDOWEVENT_SIZE_CHANGED then
            __设置.聊天窗口 = 窗口.宽度 - 10
            __rpc:角色_设置('聊天窗口', __设置.聊天窗口)
            屏幕1.聊天列表:置聊天列表宽度(窗口.宽度 - 10)
            屏幕2.聊天列表:置聊天列表宽度(窗口.宽度 - 10)
        end
    end

    return _ENV
end

local 设置频道 = { ['66'] = true, ['67'] = true, ['115'] = true, ['65'] = true, ['114'] = true, ['69'] = true }

function 添加内容(_, s)
    local tp = tostring(s):match('#(%d*)')

    if tp == '' then -- 系统
        屏幕1.聊天列表:添加内容(s)
        return
    elseif tp == '71' or (tp == '' and not __设置.是否分屏) then
        屏幕2.聊天列表:添加内容(s)
        return
    end

    if not 设置频道[tp] or (__设置.聊天频道[2] and __设置.聊天频道[2][tp]) then
        屏幕1.聊天列表:添加内容(s)
    end
    if not 设置频道[tp] or __设置.是否分屏 and (__设置.聊天频道[3] and __设置.聊天频道[3][tp]) then
        屏幕2.聊天列表:添加内容(s)
    end
end

return _ENV
