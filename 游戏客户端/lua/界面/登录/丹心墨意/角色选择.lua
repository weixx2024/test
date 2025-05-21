local 角色选择 = 登录层:创建控件('角色选择')

function 角色选择:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self:置精灵(__res:getspr('ui2/01.png'):置拉伸(640, 480))
    self.名字底图 = __res:getspr('gires/common/login/选择角色/水墨底条.tcp')
    self.七色祥云 = __res:get('addon/fly/shape/0505.tcp'):取动画(6):播放(true)
end

function 角色选择:置动画模型(id)
    self.动画 = require('对象/基类/动作') { 外形 = id, 模型 = 'stand', 方向 = 5 }
end

function 角色选择:更新(dt)
    self.七色祥云:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
end

function 角色选择:显示(x, y)
    self.名字底图:显示(250, 310)
    self.七色祥云:显示(310, 200)
    self.动画:显示(320, 220)
end

local 文本 = 角色选择:创建文本('等级文本', 300, 318, 180, 30):置文字(__res.F15)

function 角色选择:置数据(list, 开放创建, 开放游戏, 账号)
    self.list = list
    self.开放创建 = 开放创建
    self.开放游戏 = 开放游戏
    self.账号 = 账号
    for i = 1, 6 do
        角色选择['角色' .. i]:置文本(i, list[i])
    end
    _选中角色 = tonumber(gge.arg[2]) or 1
    if #self.list > 0 then
        _选中角色 = 1
        角色选择.等级文本:置文本('#cffffff' .. ((self.list[1].转生 .. '转' .. self.list[1].等级 .. '级') or '0转0级'))
        角色选择:置动画模型(self.list[1].外形)
        角色选择['角色1']:置选中(true)
        创建按钮:置禁止(#self.list >= 6)
    end
end

for i = 1, 6 do
    local 按钮 = 角色选择:创建单选按钮('角色' .. i, 30, 40 + (i - 1) * 35, 180, 30)
    function 按钮:置文本(i, t)
        if t then
            self.t = t
            local txt = t.名称
            __res.F14:置颜色(255, 255, 255, 255)
            local t = __res.F14:取图像('(√)' .. txt)
            t:置中心(-(160 - t.宽度) // 2, -(16 - t.高度) // 2)

            self:置正常精灵(__res.F14:取精灵(txt))
            self:置按下精灵(__res.F14:取精灵(txt):置中心(-1, -1))
            self:置选中正常精灵(self:取拉伸精灵_宽高帧('gires/common/login/选择角色/水墨底条.tcp', 1, 180, 30, t))
            self:置选中按下精灵(self:取拉伸精灵_宽高帧('gires/common/login/选择角色/水墨底条.tcp', 1, 180, 30, t):置中心(-1, -1))
            self.序号 = i
        end
        self:置可见(t ~= nil)
    end

    按钮.检查透明 = 按钮.检查点
    function 按钮:左键单击()
        if self.t then
            _选中角色 = self.序号
            角色选择:置动画模型(self.t.外形)
            角色选择.等级文本:置文本('#cffffff' .. ((self.t.转生 .. '转' .. self.t.等级 .. '级') or '0转0级'))
        end
    end
end

创建按钮 = 角色选择:创建素材文本按钮('创建按钮', 500, 140, 'gires/common/login/选择角色/新建角色.tcp', ' ', 35, 140, 255, 255, 255)
function 创建按钮:左键弹起()
    if #角色选择.list < 6 then
        登录层:切换界面(登录层.角色创建)
    else
        --登录层:打开提示('#R无法创建更多角色！')
    end
end

local 进入按钮 = 角色选择:创建素材文本按钮('登录按钮', 270, 390, 'gires/common/login/选择服务器/按钮_进入.tcp', ' ', 123, 48, 255, 255, 255)
do
    local function 默认设置()
        if not __设置.聊天频道 then
            __设置.聊天频道 = {}
        end
        for i = 1, 3 do
            if not __设置.聊天频道[i] then
                __设置.聊天频道[i] = { ['66'] = true, ['67'] = true, ['115'] = true, ['65'] = true, ['114'] = true, ['69'] = true }
            end
        end

        -- __设置.音乐音量 = nil
        -- __设置.音效音量 = nil
        if __设置.音乐音量 == nil then
            __设置.音乐音量 = 128 | 100
        end

        if __设置.音效音量 == nil then
            __设置.音效音量 = 128 | 100
        end

        if __设置.音乐音量 & 128 == 128 then
            __res:置音乐音量(__设置.音乐音量 & 127)
        else
            __res:置音乐音量(0)
        end
        if __设置.音效音量 & 128 == 128 then
            __res:置音效音量(__设置.音效音量 & 127)
        else
            __res:置音效音量(0)
        end
    end

    function RPC:进入游戏(data, set)
        _G.__设置 = set
        默认设置()
        if gge.platform == 'Windows' then
            引擎:置宽高(800, 600)
        else
            引擎:置宽高(800, 600)
            引擎:置逻辑宽高(引擎.逻辑宽度, 引擎.逻辑高度)
        end
        if 登录提示 then
            登录提示:置可见(false)
        end

        窗口层:置可见(true)


        GUI:取默认输入():置焦点(true)
        local co = coroutine.running()
        local function 切换地图回调()
            登录层:置可见(false)

            _G.__rol = require('主角')(data)
            if gge.platform == 'Windows' then
                if gge.arg[1] == "tab" then
                    引擎:置标题('%s（ID：%s）', __rol.名称, __rol.id)
                else
                    引擎:置标题('%s - %s（ID：%s）', 引擎.标题, __rol.名称, 10000 + __rol.id)
                end
            end
            界面层:置可见(true, true)
            地图层:置可见(true, true)
            界面层:置队伍()
            界面层:置人物状态(data)
            界面层:置召唤状态(data.召唤)
            界面层:置BUFF(data.BUFF)
            地图层:切换地图(data.地图)
            界面层:置坐标(data.x, data.y)
            coroutine.resume(co)
        end

        if gge.platform == 'Windows' then
            引擎.宽高事件回调 = function()
                引擎:置坐标()
                引擎.切换地图回调 = 切换地图回调
            end
        else
            引擎.切换地图回调 = 切换地图回调
        end
        coroutine.yield()
        collectgarbage()
        return true
    end

    function 进入按钮:左键弹起()
        if not _选中角色 then
            return
        end
        登录提示 = 登录层:打开提示('#K正在连接#b...')
        登录提示.确定按钮:置可见(false)
        local r = __rpc:登录_进入游戏(_选中角色)
        登录提示.确定按钮:置可见(true)
        ::try::
        if r == false then
            登录提示:置可见(false)
            if 登录层:打开选择('#K当前角色正在电脑端或其它移动端登录,点击确认将顶号,取消回到登录界面.') then
                r = __rpc:登录_强制进入游戏(_选中角色)
                goto try
            end
        elseif type(r) == 'string' then
            登录层:打开提示('#R' .. r)
        else
            __res:界面音效('sound/addon/close.wav')
        end
        界面层:哈哈比比()
    end

    function 进入按钮:键盘弹起(键码, 功能)
        if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
            进入按钮:左键弹起()
        end
    end
end

local 取消按钮 = 角色选择:创建素材文本按钮('取消按钮', 50, 420, 'gires/common/login/选择服务器/按钮_返回.tcp', ' ', 86, 32, 255, 255, 255)
function 取消按钮:左键弹起()
    __res:界面音效('sound/addon/open.wav')
    登录层:切换界面(登录层.游戏登录)
end

return 角色选择
