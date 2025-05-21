local 游戏登录 = 登录层:创建控件('游戏登录')
function 游戏登录:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self.背景 = __res:getspr('gires/0x8DC6191E.tga')
    self.近景 = __res:getspr('gires/0x51F941C4.tcp')
end

function 游戏登录:更新(dt, x, y)
end

function 游戏登录:显示(x, y)
    self.背景:显示(0, 0)
    self.近景:显示(100, 160)
end

local 记住账号 = 游戏登录:创建多选按钮('记住账号', 508, 208)
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

local 记住密码 = 游戏登录:创建多选按钮('记住密码', 508, 245)
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

local 账号输入 = 游戏登录:创建文本输入('账号输入', 245, 207, 250, 18)
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

local 密码输入 = 游戏登录:创建文本输入('密码输入', 245, 245, 250, 18)
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

local 登录按钮 = 游戏登录:创建按钮('登录按钮', 188, 278)
function 登录按钮:初始化()
    self:设置按钮精灵('gires/0xEF61B5B8.tcp')
    --self:置坐标(引擎.宽度2 - 53, 引擎.高度2 + 35)
end

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

local 列表控件 = GUI:创建弹出控件('列表控件')
do
    function 列表控件:初始化()
        self:置精灵(require('SDL.精灵')(0, 0, 0, 255, 155):置颜色(0, 0, 0, 200))
    end

    local 账号列表 = 列表控件:创建列表('账号列表', 5, 5, 233, 140)
    function 账号列表:初始化()
        --self.行间距 = 3


    end

    function 账号列表:左键弹起()
        账号输入:置文本(self:取文本(self.选中行))
        列表控件:置可见(false)
        密码输入:清空()
    end

    local 下拉按钮 = 游戏登录:创建按钮('下拉按钮', 480, 207, 15, 15)
    function 下拉按钮:初始化()
        self:置正常精灵(__res:getspr('ui/zcxl1.png'):置拉伸(15, 15))
        self:置按下精灵(__res:getspr('ui/zcxl2.png'):置拉伸(15, 15))
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

local 取消按钮 = 游戏登录:创建按钮('取消按钮', 304, 278)
function 取消按钮:初始化()
    self:设置按钮精灵('gires/0xCB250B45.tcp')
end

function 取消按钮:左键弹起(msg)
    __res:界面音效('sound/addon/open.wav')
    登录层:切换界面(登录层.游戏开始)
end

local 离开按钮 = 游戏登录:创建按钮('离开按钮', 412, 278)
function 离开按钮:初始化()
    self:设置按钮精灵('gires/0xEBD05656.tcp')
end

function 离开按钮:左键弹起(msg)
    引擎:关闭()
end

return 游戏登录
