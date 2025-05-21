local 助战 = 窗口层:创建我的窗口('助战', 0, 0, 510, 310)

function 助战:初始化()
    self:置精灵(
        self:取老红木窗口(
            self.宽度,
            self.高度,
            '助战',
            function()
                self:取拉伸图像_宽高('gires4/jdmh/yjan/tmk2.tcp', 80, 170):显示(35, 65)
                self:取拉伸图像_宽高('gires4/jdmh/yjan/tmk2.tcp', 80, 170):显示(125, 65)
                self:取拉伸图像_宽高('gires4/jdmh/yjan/tmk2.tcp', 80, 170):显示(215, 65)
                self:取拉伸图像_宽高('gires4/jdmh/yjan/tmk2.tcp', 80, 170):显示(305, 65)
                self:取拉伸图像_宽高('gires4/jdmh/yjan/tmk2.tcp', 80, 170):显示(395, 65)
            end
        )
    )
    self.动画 = {}
    self.角色列表 = {}
    self:置坐标((引擎.宽度 - self.宽度) // 2, (引擎.高度 - self.高度) // 2)
end

function 助战:显示(x, y)
    if next(self.动画) ~= nil then
        for k, v in pairs(self.动画) do
            v:显示(x + 80 + (k - 1) * 90, y + 170)
        end
    end
end

function 助战:更新(dt)
    if next(self.动画) ~= nil then
        for k, v in pairs(self.动画) do
            v:更新(dt)
        end
    end
end

助战:创建关闭按钮(0, 1)

local 切换按钮组 = {}
for i = 1, 5, 1 do
    local 切换按钮 = 助战:创建小按钮('切换按钮' .. i, 50 + (i - 1) * 90, 35, '切换')
    切换按钮:置禁止(true)

    function 切换按钮:左键弹起()
        local 助战 = 助战.角色列表[i]

        if 助战 == nil or __rol.nid == 助战.nid then
            return
        end

        __rol:停止移动()
        coroutine.xpcall(
            function()
                __rpc:助战_切换角色(__rol.id, __rol.nid, 助战.id, 助战.nid)
            end
        )
    end

    切换按钮组[i] = 切换按钮
end

local 召唤按钮组 = {}
for i = 1, 5, 1 do
    local 召唤按钮 = 助战:创建小按钮('召唤按钮' .. i, 50 + (i - 1) * 90, 244, '召唤')
    召唤按钮:置禁止(true)

    function 召唤按钮:左键弹起()
        local 助战 = 助战.角色列表[i]
        if not 助战 or __rol.nid == 助战.nid then
            return
        end
        __rpc:助战_进入游戏(i, __rol.id, __rol.nid, 助战.id)
        窗口层:刷新助战()
    end

    召唤按钮组[i] = 召唤按钮
end

local 下线按钮组 = {}
for i = 1, 5, 1 do
    local 下线按钮 = 助战:创建小按钮('下线按钮' .. i, 50 + (i - 1) * 90, 274, '下线')
    下线按钮:置禁止(true)

    function 下线按钮:左键弹起()
        local 助战 = 助战.角色列表[i]
        if not 助战 or __rol.nid == 助战.nid then
            return
        end
        __rpc:角色_助战下线(助战.nid)
        窗口层:刷新助战()
    end

    下线按钮组[i] = 下线按钮
end

local 名称文本组 = {}
for i = 1, 5, 1 do
    local 名称文本 = 助战:创建文本('名称文本' .. i, 40 + (i - 1) * 90, 190, 80, 20)
    名称文本:置文字(__res.F14)

    名称文本组[i] = 名称文本
end

local 等级文本组 = {}
for i = 1, 5, 1 do
    local 等级文本 = 助战:创建文本('等级文本' .. i, 40 + (i - 1) * 90, 210, 80, 20)
    等级文本:置文字(__res.F14)

    等级文本组[i] = 等级文本
end

function 窗口层:刷新助战()
    助战.动画 = {}
    助战.角色列表 = {}
    助战.角色列表 = __rpc:助战_角色列表()
    for i, v in pairs(助战.角色列表) do
        if i > 5 then
            return
        end
        if v.在线 then
            切换按钮组[i]:置禁止(false)
            下线按钮组[i]:置禁止(false)
            召唤按钮组[i]:置禁止(true)
        else
            召唤按钮组[i]:置禁止(false)
            切换按钮组[i]:置禁止(true)
            下线按钮组[i]:置禁止(true)
        end
        名称文本组[i]:置文本(v.名称)
        等级文本组[i]:置文本(v.转生 .. '转' .. v.等级 .. '级')
        table.insert(助战.动画, require('对象/基类/动作') { 外形 = v.外形, 方向 = 5, 模型 = 'stand' })
    end
end

function 窗口层:打开助战()
    助战:置可见(not 助战.是否可见)
    if not 助战.是否可见 then
        return
    end
    助战.动画 = {}
    助战.角色列表 = {}
    助战.角色列表 = __rpc:助战_角色列表()
    for i, v in pairs(助战.角色列表) do
        if i > 5 then
            return
        end
        if v.在线 then
            切换按钮组[i]:置禁止(false)
            下线按钮组[i]:置禁止(false)
            召唤按钮组[i]:置禁止(true)
        else
            召唤按钮组[i]:置禁止(false)
            切换按钮组[i]:置禁止(true)
            下线按钮组[i]:置禁止(true)
        end
        名称文本组[i]:置文本(v.名称)
        等级文本组[i]:置文本(v.转生 .. '转' .. v.等级 .. '级')
        table.insert(助战.动画, require('对象/基类/动作') { 外形 = v.外形, 方向 = 5, 模型 = 'stand' })
    end

    助战:置坐标((引擎.宽度 - 助战.宽度) // 2, (引擎.高度 - 助战.高度) // 2)
end

function 窗口层:切换助战(i)
    if not 助战.角色列表 then
        return
    end
    if next(助战.角色列表) == nil then
        return
    end
    if not 助战.角色列表[i] then
        return
    end
    local 助战 = 助战.角色列表[i]
    if __rol.nid == 助战.nid then
        return
    end
    __rol:停止移动()
    coroutine.xpcall(
        function()
            if __rpc:助战_切换角色(__rol.id, __rol.nid, 助战.id, 助战.nid) then
                窗口层:刷新助战()
                return true
            end
        end
    )
end

return 助战
