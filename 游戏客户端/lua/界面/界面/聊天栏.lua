local 聊天控件 = 界面层:创建控件('聊天控件')
local _记录 = {}
function 聊天控件:初始化()
    self:置宽高(引擎.宽度, 引擎.高度 - 25)

    -- self.内容区域:置坐标(0, -140)
end

local 内容区域 = 聊天控件:创建控件('内容区域', 0, -140, 350, 140)
do
    do
        function 内容区域:初始化()
            self:置精灵(require('SDL.精灵')(0, 0, 0, 350, 140):置颜色(0, 0, 0, 150), true) --替换新宽高
        end

        function 内容区域:检查消息()
            return false
        end

        function 内容区域:修改高度(v)
            if self.高度 + v < 50 or self.高度 + v > 引擎.高度 - 100 then
                return
            end
            self:置精灵(require('SDL.精灵')(0, 0, 0, 350, self.高度 + v):置颜色(0, 0, 0, 150), true) --替换新宽高
            self.聊天列表:置高度(self.高度 - 10)
            local x, y = self:取坐标()
            self:置坐标(x, y - v)
        end
    end

    local 聊天列表 = 内容区域:创建列表('聊天列表', 5, 5, 340, 115)
    do
        function 聊天列表:初始化()
            self.选中精灵 = nil
            self.焦点精灵 = nil
            self.行间距 = 2
            -- self:置宽高(内容区域.宽度 - 10, 内容区域.高度 - 10)
            self:自动滚动(true)
        end

        function 聊天列表:检查消息()
            return false
        end

        -- function 聊天列表:鼠标滚轮(v)
        --     self:自动滚动(v)
        --     内容区域.滚动按钮:置选中(not v)
        -- end
        function 聊天列表:重置内容()
            聊天列表:清空()
            for i = 1, 50 do
                table.remove(_记录, 1)
            end
            for index, value in ipairs(_记录) do
                聊天列表:添加内容(value, 1)
            end
        end

        function 聊天列表:添加内容(t, s)
            if not s then
                table.insert(_记录, t)
                if #_记录 >= 100 then
                    聊天列表:重置内容()
                    return
                end
            end

            local r = self:添加(t):置精灵()
            local 文本 = r:创建我的文本('文本', 0, 0, self.宽度, 500)
            文本.获得回调 = 聊天列表.文本获得回调
            文本.回调左键弹起 = 聊天列表.文本回调左键弹起 --todo
            文本.回调右键弹起 = 聊天列表.文本回调右键弹起
            local _, h = 文本:置文本(t)
            文本:置高度(h)
            r:置高度(h)
            r:置可见(true, true)
        end

        function 聊天列表:文本获得回调(x, y, v)
            鼠标层:手指形状()
        end

        function 聊天列表:文本回调右键弹起(v)
            local nid = v:match('0|(.*)')
            if nid then
                聊天列表:文本右键返回(
                    nid,
                    self:弹出右键 {
                        '加为好友',
                        --   '临时好友',
                        '屏蔽发言',
                        '查看装备'
                    }
                )
            end
        end

        function 聊天列表:文本回调左键弹起(nid)
            if nid:match('0|(.*)') == nil then
                local t, d = __rpc:角色_查看对象(nid)
                if t == 1 then --物品
                    local r = require('界面/数据/物品')(d)
                    窗口层:打开物品提示(r)
                elseif t == 2 then --召唤
                    窗口层:打开召唤兽查看(d)
                end
            end
        end

        function 聊天列表:文本右键返回(nid, v)
            if v == "加为好友" then
                coroutine.xpcall(function()
                    local r = __rpc:角色_添加好友(nid)
                end)
            end
        end
    end

    for i, v in ipairs {
        { name = '左键按钮', 提示 = '#Y切换聊天窗口', zy = 'gires/button/chatwin.tca' },
        { name = '上键按钮', 提示 = '#Y上滚', zy = 'gires/button/up.tca' },
        { name = '下键按钮', 提示 = '#Y下滚', zy = 'gires/button/down.tca' },
        { name = '移动按钮', 提示 = '#Y移动', zy = 'gires/drag.tca' },
        { name = '加号', 提示 = '#Y加大', zy = 'gires/button/add.tca' },
        { name = '最小化按钮', 提示 = '#Y缩小', zy = 'gires/button/sub.tca' },
        { name = '频道选择按钮', 提示 = '#Y频道选择', zy = 'gires/button/cup.tca' },
        --{name = '静音按钮', 提示 = '#Y静音', zy = 'gires/0x28F0D9DA.tcp'},
        --{name = '屏蔽按钮', 提示 = '#Y屏蔽(左)/屏蔽菜单(右)', zy = 'gires/0x46FA19C4.tcp'},
        { name = '滚动按钮', 提示 = '#Y滚动开关', zy = 'gires/button/autoscroll.tca' },
        { name = '历史按钮', 提示 = '#Y聊天记录', zy = 'gires/button/chatquery.tca' }
        -- {name="搜加按钮",zy="gires/0x.tcp"},
    } do
        local 按钮
        if v.name == '滚动按钮' then
            按钮 = 内容区域:创建多选按钮(v.name, 5 + (i - 1) * 20, -20)
            function 按钮:初始化()
                self:设置按钮精灵(v.zy)
                self:设置按钮精灵3('gires/button/autoscroll2.tca')
                按钮:置提示(v.提示)
            end
        elseif v.name == '频道选择按钮' then
            按钮 = 内容区域:创建按钮(v.name, 5 + (i - 1) * 20, -20)
            function 按钮:初始化()
                self:置正常精灵(__res:getspr('ui/xz1.png'))
                self:置经过精灵(__res:getspr('ui/xz2.png'))
                按钮:置提示(v.提示)
            end

            function 按钮:获得鼠标()
                鼠标层:手指形状()
            end
        else
            按钮 = 内容区域:创建按钮(v.name, 5 + (i - 1) * 20, -20)
            function 按钮:初始化()
                self:设置按钮精灵(v.zy)
                按钮:置提示(v.提示)
            end
        end

        function 按钮:左键弹起()
            if v.name == '左键按钮' then
                if gge.platform == 'Windows' and not 聊天窗口 then
                    聊天控件:置可见(false, false)
                    聊天窗口 = require('窗口/聊天')
                    聊天窗口.关闭 = function(_, list)
                        聊天控件:置可见(true, true)
                        聊天窗口 = nil
                        聊天列表:清空()
                        for i, v in ipairs(list) do
                            聊天列表:添加内容(v)
                        end
                        __rpc:角色_设置('聊天窗口', false)
                    end
                    聊天窗口:打开(聊天列表)
                    __rpc:角色_设置('聊天窗口', __设置.聊天窗口 or 250)
                end
            elseif v.name == '上键按钮' then
                聊天列表:向上滚动()
                聊天列表:自动滚动(false)
                内容区域.滚动按钮:置选中(true)
            elseif v.name == '下键按钮' then
                if gge.platform == 'Windows' then
                    if not 聊天列表:向下滚动() then
                        聊天列表:自动滚动(true)
                        内容区域.滚动按钮:置选中(false)
                    end
                else
                    内容区域:置可见(false, false)
                    聊天控件.展开按钮:置可见(true, true)
                    聊天控件.挂机按钮:置可见(true, true)
                end
            elseif v.name == '历史按钮' then
                窗口层:打开聊天记录(聊天列表)
            elseif v.name == '频道选择按钮' then
                if not __设置.聊天频道 then
                    __设置.聊天频道 = {}
                end
                local r = GUI.窗口层:打开选择频道(__设置.聊天频道[1])

                __设置.聊天频道[1] = r
                __rpc:角色_设置('聊天频道', __设置.聊天频道)
            elseif v.name == '加号' then
                内容区域:修改高度(50)
                内容区域.绝对坐标 = true
            elseif v.name == '最小化按钮' then
                内容区域:修改高度(-50)
                内容区域.绝对坐标 = true
            end
        end

        function 按钮:选中事件(b)
            聊天列表:自动滚动(not b)
            if not b then
                聊天列表:滚动到底()
            end
        end

        if v.name == '移动按钮' then
            if gge.platform == 'Windows' then
                function 按钮:左键按下(x, y)
                    内容区域.绝对坐标 = true
                    local mx, my = 引擎:取鼠标坐标()
                    self.px, self.py = mx - x, my - y
                end

                function 按钮:左键按住(x, y)
                    local qx, qy = 内容区域:取坐标()
                    local px, py = x - qx, y - qy

                    x, y = 引擎:取鼠标坐标()
                    内容区域:置坐标(x - px - self.px, y - py - self.py)
                end

                按钮.检查透明 = 按钮.检查点
            end
        end
    end
    --==================================================================================================
    local _敏感频道 = { "#66", "#65", "#69" }

    local 设置频道 = { ['66'] = true, ['67'] = true, ['115'] = true, ['65'] = true, ['114'] = true, ['69'] = true }

    function 界面层:添加聊天(s, ...)
        if select('#', ...) > 0 then
            s = s:format(...)
        end

        local tp = tostring(s):match('#(%d*)')

        -- local 敏感 = false

        -- for _, v in pairs(_敏感频道) do
        --     if string.find(s, v) then
        --         敏感 = true
        --     end
        -- end
        -- if 敏感 then
        --     s = require("数据/敏感词库")(s)
        -- end

        if not 设置频道[tp] or __设置.聊天频道[1] and __设置.聊天频道[1][tp] then
            if 聊天窗口 then
                聊天窗口:添加内容(s)
            else
                聊天列表:添加内容(s)
            end
        end
    end

    function 界面层:哈哈比比()
        聊天控件.挂机按钮:置可见(false, false)
        聊天控件.展开按钮:置可见(false, false)
    end

    function RPC:界面信息_聊天(s, ...)
        if type(s) == 'string' then
            界面层:添加聊天(s, ...)
        end
    end

    function 界面层:打开聊天窗口()
        if __设置 and __设置.聊天窗口 then
            内容区域.左键按钮:左键弹起()
        end
    end

    function 界面层:关闭聊天窗口()
        if 聊天窗口 then
            聊天控件:置可见(true, true)
            聊天窗口.窗口:关闭()
            聊天窗口 = nil
            聊天列表:清空()
            return
        end
    end
end

local 展开按钮 = 聊天控件:创建按钮("展开按钮", 5, -20)
function 展开按钮:初始化()
    self:设置按钮精灵('gires/button/up.tca')
    self:置可见(false, false)
    --  按钮:置提示(v.提示)
end

local 挂机按钮 = 聊天控件:创建小按钮('挂机按钮', 30, -26, '挂机')
function 挂机按钮:初始化()
    self:置文本('挂机')
    self:置可见(false, false)
end

function 挂机按钮:左键弹起()
    local r = __rpc:角色_取VIP等级()
    if not r or r < 3 then
        return
    end
    地图层:手机自动遇怪()
end

function 展开按钮:左键弹起()
    if gge.platform ~= 'Windows' then
        内容区域:置可见(true, true)
        self:置可见(false, false)
        挂机按钮:置可见(false, false)
    end
end

-- ==================================================================================================
-- ==================================================================================================
-- ==================================================================================================
local 输入区域 = 界面层:创建控件('输入区域', 0, -25, 640, 25)
do
    function 输入区域:初始化(i)
        self:置精灵(
            生成精灵(
                引擎.宽度,
                25,
                function()
                    self:取拉伸图像_宽高('gires/main/border.bmp', 41, 25):显示(0, 0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 引擎.宽度 - 72, 25):显示(41, 0)
                end
            )
        )
        self:置坐标(0, -25)
        self:置宽高(引擎.宽度, 25)
        -- local spr = self:取拉伸精灵_宽度('gires/main/border.tcp', 引擎.宽度)
        -- self:置精灵(spr)
        -- self:置坐标(0, -25)
        -- self:置宽高(spr.宽度, 25)
    end

    local 输入框 = 输入区域:创建文本输入('输入框', 45, 5, 350, 16)
    do
        GUI:置默认输入(输入框)
        function 输入框:初始化()
            self.频道ID = 1
            self.历史 = {}
            self.历史位置 = 1
            self.颜色 = ''
            self:置颜色(255, 255, 255, 255)
            self:置限制字数(200)
            -- self:置宽高(引擎.宽度 == 640 and 215 or 370, 16)
            输入框:置焦点(true)
        end

        function 输入框:输入对象(v)
            local 名称 = string.format('[%s]', v.原名 or v.名称)
            v.标识 = self:添加对象(名称, v)
        end

        function 输入框:发消息()
            local str = self.颜色 .. self:取文本()
            if str ~= '' then
                for i, v in ipairs(self:取对象()) do
                    str = str:gsub(v.标识, string.format('#G#m(%s)[%s]#m#n', v.nid, v.原名 or v.名称), 1)
                end
                str = require("数据/敏感词库")(str)
                table.insert(self.历史, str)
                if #self.历史 > 10 then
                    table.remove(self.历史, 1)
                end
                self.历史位置 = #self.历史 + 1

                self:清空()

                local r
                if self.频道ID == 7 then --私聊
                    if self.私聊ID then
                        r = __rpc:界面聊天(str, self.频道ID, self.私聊ID)
                    end
                else
                    r = __rpc:界面聊天(str, self.频道ID)
                end
                if type(r) == 'string' then
                    窗口层:提示窗口(r)
                end
            end
        end

        function 输入框:键盘弹起(键码, 功能)
            if 键码 == SDL.KEY_ENTER or 键码 == SDL.KEY_KP_ENTER then
                self:发消息()
            elseif 键码 == SDL.KEY_UP then
                self.历史位置 = self.历史位置 - 1
                if self.历史[self.历史位置] then
                    self:置文本(self.历史[self.历史位置])
                else
                    self.历史位置 = self.历史位置 + 1
                end
            elseif 键码 == SDL.KEY_DOWN then
                self.历史位置 = self.历史位置 + 1
                if self.历史[self.历史位置] then
                    self:置文本(self.历史[self.历史位置])
                else
                    self.历史位置 = self.历史位置 - 1
                end
            end
        end
    end
    function 界面层:发消息()
        输入框:发消息()
    end

    function 界面层:输入对象(v)
        输入框:输入对象(v)
    end

    -- function 界面层:私聊(t)
    --     输入框.私聊ID = t.id
    --     界面层:添加聊天('#616 #R私聊对象变为：%s（%s）', t.名称, t.id)
    --     --PK开关：#G%s
    --     界面层:添加聊天('姓名：%s#rＩＤ：%s#r称谓：%s#r性别：%s#r种族：%s', t.名称, t.id, t.称谓, _性别[t.性别], _种族[t.种族])
    -- end

    local 频道控件 = GUI:创建弹出控件('频道控件')
    do
        function 频道控件:初始化()
            self:置精灵(self:取拉伸精灵_宽高('gires/main/border.bmp', 40, 115))
        end

        local 列表 = 频道控件:创建列表('右键列表', 5, 5, 40, 170)
        function 列表:初始化()
            列表:取文字():置颜色(255, 255, 255, 255)
            列表.焦点精灵:置颜色(73, 133, 133, 255)
            列表.选中精灵 = nil
            列表.行间距 = 3
            for i, v in ipairs { '当前', '队伍', '帮派', '世界', 'ＧＭ', '传音' } do
                列表:添加(v)
            end
        end

        function 列表:左键弹起(x, y, i)
            频道控件:置可见(false, false)
            输入区域.频道按钮:初始化(self:取文本(i))
            输入框.频道ID = i
        end
    end

    local 频道按钮 = 输入区域:创建按钮('频道按钮', 0, 0)
    do
        local list = {
            当前 = 'gires/button/currentchannel.tca',
            队伍 = 'gires/button/teamchannel.tca',
            帮派 = 'gires/button/orgchannel.tca',
            世界 = 'gires/button/worldchannel.tca',
            ＧＭ = 'gires/button/gmchannel.tca',
            传音 = 'ui/cy.png'
        }
        function 频道按钮:初始化(v)
            v = v or '当前'
            __res.F16B:置颜色(225, 228, 140)
            self:置正常精灵(__res:getspr(list[v]))
            self:置按下精灵(__res:getspr(list[v]):置中心(-1, -1))
        end

        频道按钮.检查透明 = 频道按钮.检查点
        function 频道按钮:左键弹起(x, y)
            频道控件:置可见(true, true)
            频道控件:置坐标(x + 3, y - 频道控件.高度 - 5)
        end
    end
end
