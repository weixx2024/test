local 角色选择 = 登录层:创建控件('角色选择')
local 间距 = 150

function 角色选择:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self:置精灵(__res:getspr('gires2/login/selectplayer.tcp'))
end

function 角色选择:置动画模型(id)
    self.动画 = require('对象/基类/动作') { 外形 = id, 模型 = 'stand' }
end

function 角色选择:更新(dt)
    if self.动画 then
        self.动画:更新(dt)
    end
end

function 角色选择:显示(x, y)
    if self.头像 then
        self.头像:显示(206, 78)
    end
end

function 角色选择:置数据(list, 开放创建, 开放游戏, 账号)
    self.list = list
    self.开放创建 = 开放创建
    self.开放游戏 = 开放游戏
    self.账号 = 账号
    self.头像 = nil
    for i = 1, 6 do
        角色选择['角色' .. i]:置文本(i, list[i])
    end
    _选中角色 = tonumber(gge.arg[2]) or 1
    if #self.list > 0 then
        _选中角色 = 1
        角色选择.头像 = __res:getspr('photo/facelarge/%d.tga', self.list[1].头像)
        角色选择.种族文本:置文本('#c261701' .. self.list[1].种族)
        角色选择.性别文本:置文本('#c261701' .. self.list[1].性别)
        角色选择.等级文本:置文本('#c261701' .. (self.list[1].等级 or 0))
        角色选择['角色1']:置选中(true)
        创建按钮:置禁止(#self.list >= 6)
    end
end

for k, v in pairs {
    { name = '种族', x = 147, y = 149, w = 40 },
    { name = '性别', x = 147, y = 122, w = 40 },
    { name = '等级', x = 147, y = 95, w = 40 },
    { name = '角色', x = 129, y = 200, w = 80 }
} do
    local 文本 = 角色选择:创建文本(v.name .. '文本', v.x, v.y, v.w, 16)
    if v.name == '等级' then
        文本:置文字(__res.F15B)
    else
        文本:置文字(__res.F15)
    end
end
local _种族 = { "人", "魔", "仙", "鬼" }

local _性别 = { "男", "女" }

for i = 1, 6 do
    local 按钮 = 角色选择:创建单选按钮('角色' .. i, 129, 199 + i * 25 - 25, 135, 16)
    function 按钮:置文本(i, t)
        if t then
            self.t = t
            local txt = t.名称
            __res.F14:置颜色(255, 255, 255, 255)
            self:置正常精灵(__res.F14:取精灵(txt))
            self:置按下精灵(__res.F14:取精灵(txt):置中心(-1, -1))
            self:置选中正常精灵(__res.F14:取精灵('(√)' .. txt))
            self:置选中按下精灵(__res.F14:取精灵('(√)' .. txt):置中心(-1, -1))
            self.序号 = i
        end
        self:置可见(t ~= nil)
    end

    按钮.检查透明 = 按钮.检查点
    function 按钮:左键单击()
        if self.t then
            _选中角色 = self.序号
            角色选择.头像 = __res:getspr('photo/facelarge/%d.tga', self.t.头像)
            角色选择.种族文本:置文本('#cffffff' .. (_种族[self.t.种族] or "人"))
            角色选择.性别文本:置文本('#cffffff' .. (_性别[self.t.性别] or "男"))
            角色选择.等级文本:置文本('#cffffff' .. (self.t.等级 or 0))
        end
    end
end

创建按钮 = 角色选择:创建按钮('_创建按钮', 41, 398)
function 创建按钮:初始化()
    self:设置按钮精灵('gires2/login/create.tca')
end

function 创建按钮:左键弹起()
    if #角色选择.list < 6 then
        登录层:切换界面(登录层.角色创建)
    else
        --登录层:打开提示('#R无法创建更多角色！')
    end
end

local 进入按钮 = 角色选择:创建按钮('进入按钮', 243, 398)
function 进入按钮:初始化()
    self:设置按钮精灵('gires2/login/login.tca')
end

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

local 取消按钮 = 角色选择:创建按钮('取消按钮', 143, 398)
function 取消按钮:初始化()
    self:设置按钮精灵('gires2/login/cancel.tca')
end

function 取消按钮:左键弹起()
    __res:界面音效('sound/addon/open.wav')
    登录层:切换界面(登录层.游戏登录)
end

return 角色选择
