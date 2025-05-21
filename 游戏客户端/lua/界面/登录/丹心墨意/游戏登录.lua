local 游戏登录 = 登录层:创建控件('游戏登录')
function 游戏登录:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    -- 800
    self.顶部 = __res:getspr('gires/common/login/账号密码/号密_边框.tcp'):置拉伸(640, 110)
    self.背景1 = __res:getspr('gires/common/login/账号密码/号密底_移动图_山1.tcp'):置拉伸(640, 480)
    self.背景2 = __res:getspr('gires/common/login/账号密码/号密底_移动图_山2.tcp'):置拉伸(640, 480)
    self.logo = __res:getspr('gires/common/login/账号密码/logo.tcp')
    self.普通登录 = __res:get('gires/common/login/账号密码/按钮_普通登陆.tcp'):取精灵(2)
    self.账密 = __res:getspr('gires/common/login/账号密码/号密_界面.tcp')
    self.太阳 = __res:getani('gires/common/login/账号密码/动画_太阳.tcp'):播放(true)
    self.悟空 = __res:getani('gires/common/login/账号密码/动画_新悟空.tcp'):播放(true)
    self.悟空2 = __res:getani('gires/common/login/账号密码/动画_新悟空2.tcp'):播放(true)
    self.瀑布 = __res:getani('gires/common/login/账号密码/瀑布.tcp'):播放(true)
    self.师徒 = __res:getani('gires/common/login/账号密码/动画_唐僧师徒.tcp'):播放(true)
end

function 游戏登录:更新(dt, x, y)
    self.太阳:更新(dt)
    self.悟空:更新(dt)
    self.悟空2:更新(dt)
    self.瀑布:更新(dt)
    self.师徒:更新(dt)
end

function 游戏登录:显示(x, y)
    -- self.背景1:显示(0, 0)
    self.背景2:显示(0, 0)
    self.顶部:显示(0, 0)
    self.logo:显示(200, 10)
    self.普通登录:显示(190, 140)
    self.账密:显示(105, 150)

    self.太阳:显示(430, 100)
    self.瀑布:显示(-120, -80)
    self.师徒:显示(350, 416)

    if self.悟空.当前帧 == self.悟空.帧数 then
        self.悟空:置尾帧()
        self.悟空2:显示(0, 0)
    else
        self.悟空:显示(0, 0)
    end
end

local 记住账号 = 游戏登录:创建多选按钮('记住账号', 508, 187)
function 记住账号:初始化()
    local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
    self:置正常精灵(tcp:取精灵(1))
    self:置选中正常精灵(tcp:取精灵(2))

    self:置提示('记住账号')
    self:置选中(__res.配置.记住账号 == true)
end

function 记住账号:选中事件(b)
    __res.配置.记住账号 = b
    __res:保存配置()
end

local 记住密码 = 游戏登录:创建多选按钮('记住密码', 508, 220)
function 记住密码:初始化()
    local tcp = __res:get('gires4/smsj/yjan/dxk.tcp')
    self:置正常精灵(tcp:取精灵(1))
    self:置选中正常精灵(tcp:取精灵(2))
    self:置提示('记住密码')
    self:置选中(__res.配置.记住密码 == true)
end

function 记住密码:选中事件(b)
    __res.配置.记住密码 = b
    __res:保存配置()
end

local 账号输入 = 游戏登录:创建文本输入('账号输入', 245, 187, 250, 18)
function 账号输入:初始化()
    self:置颜色(255, 255, 255, 255)
    self:置限制字数(16)
    self:置模式(self.英文模式 | self.数字模式)
    if __res and __res.配置 then
        self:置文本(__res.配置.账号)
    end
    self:置焦点(true)
end

function 账号输入:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_TAB then
        游戏登录.密码输入:置焦点(true)
        return true
    end
end

local 密码输入 = 游戏登录:创建文本输入('密码输入', 245, 220, 250, 18)
function 密码输入:初始化()
    self:置颜色(255, 255, 255, 255)
    self:置模式(self.英文模式 | self.数字模式 | self.密码模式)

    if __res and __res.配置 then
        self:置限制字数(32)
        self:置文本(__res.配置.密码)
    end
    self:置限制字数(16)
end

function 密码输入:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_BACKSPACE and #self:取文本() == 32 then
        self:清空()
        return true
    elseif 键码 == SDL.KEY_TAB then
        游戏登录.账号输入:置焦点(true)
        return true
    end
end

local 列表控件 = GUI:创建弹出控件('列表控件')
do
    function 列表控件:初始化()
        self:置精灵(require('SDL.精灵')(0, 0, 0, 255, 155):置颜色(0, 0, 0, 200))
    end

    local 账号列表 = 列表控件:创建列表('账号列表', 5, 5, 230, 120)
    function 账号列表:初始化()
        --self.行间距 = 3
    end

    function 账号列表:左键弹起()
        账号输入:置文本(self:取文本(self.选中行))
        列表控件:置可见(false)
        密码输入:清空()
    end

    local 下拉按钮 = 游戏登录:创建按钮('下拉按钮', 480, 187, 15, 15)
    function 下拉按钮:初始化()
        self:置正常精灵(__res:getspr('gires4/丹心墨意/元件按钮/下键按钮.tcp'):置拉伸(15, 15):置中心(0, 0))
        self:置按下精灵(__res:getspr('ui/zcxl2.png'):置拉伸(15, 15):置中心(-1, -1))
    end

    function 下拉按钮:左键弹起(x, y)
        账号列表:清空()
        if __res and __res.配置 and type(__res.配置.账号列表) == 'table' then
            for i, v in ipairs(__res.配置.账号列表) do
                账号列表:添加(v)
            end
        end
        列表控件:置坐标(x - 235, y + 20)
        列表控件:置可见(true)
    end
end

local 登录按钮 = 游戏登录:创建素材文本按钮('登录按钮', 188, 260, 'gires/skin/丹心墨意/元件按钮/大按钮.tcp', '登录', 114, 37, 255, 255, 255)
function 登录按钮:左键弹起(msg)
    local 账号 = 账号输入:取文本()
    local 密码 = 密码输入:取文本()

    if 账号 == '' then
        登录层:打开提示('#R#17请输入玩家账号')
        return
    elseif 密码 == '' then
        登录层:打开提示('#R#17密码为空')
        return
    end
    if __res and __res.配置 and type(__res.配置.账号列表) == 'table' then
        if 记住账号.是否选中 then
            if not __res.配置.账号列表[账号] then
                __res.配置.账号列表[账号] = true
                table.insert(__res.配置.账号列表, 1, 账号)
                if __res.配置.账号列表[6] then
                    __res.配置.账号列表[__res.配置.账号列表[6]] = nil
                    table.remove(__res.配置.账号列表, 6)
                end
            end
            __res.配置.账号 = 账号
        else
            __res.配置.账号列表 = {}
            __res.配置.账号 = ''
        end
    end

    if #密码 ~= 32 then
        密码 = GGF.MD5(密码)
    end
    if __res and __res.配置 then
        if 记住密码.是否选中 then
            __res.配置.密码 = 密码
        else
            __res.配置.密码 = ''
        end
        __res:保存配置()
    end

    local 登录提示 = 登录层:打开提示('#K正在登录中#b...')
    登录提示.确定按钮:置可见(false)

    local r, 开放创建, 开放游戏 = __rpc:登录_验证账号(账号, 密码)
    登录提示.确定按钮:置可见(true)
    if type(r) == 'table' then
        __res:界面音效('sound/addon/close.wav')
        登录提示:置可见(false)
        登录层:切换界面(登录层.角色选择)
        登录层.角色选择:置数据(r, 开放创建, 开放游戏)
    elseif type(r) == 'string' then
        登录层:打开提示('#R' .. r)
    end
end

function 登录按钮:键盘弹起(键码, 功能)
    if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
        self:左键弹起()
    elseif 键码 == SDL.KEY_ESCAPE then
        登录层:切换界面(登录层.游戏公告)
    end
end

local 取消按钮 = 游戏登录:创建素材文本按钮('取消按钮', 304, 260, 'gires/skin/丹心墨意/元件按钮/大按钮.tcp', '取消', 114, 37, 255, 255, 255)
function 取消按钮:左键弹起(msg)
    __res:界面音效('sound/addon/open.wav')
    登录层:切换界面(登录层.游戏开始)
end

local 离开按钮 = 游戏登录:创建素材文本按钮('离开按钮', 420, 260, 'gires/skin/丹心墨意/元件按钮/大按钮.tcp', '离开', 114, 37, 255, 255, 255)
function 离开按钮:左键弹起(msg)
    引擎:关闭()
end

return 游戏登录
