local 状态栏 = 界面层:创建控件('状态栏')
function 状态栏:初始化()
    self:置宽高(引擎.宽度, 200)
end

--===================================================================================
local 召唤控件 = 状态栏:创建控件('召唤控件', -239, 0, 110, 40)
do
    function 召唤控件:初始化()
        self:置精灵(
            生成精灵(
                110,
                38,
                function()
                    self:取拉伸图像_宽高('gires4/jdmh/yjan/lbkdt.tcp', 110, 38):置颜色(0
                        , 0, 0, 255):显示(0, 0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 72, 38):显示(38, 0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 38, 38):显示(0, 0)
                    __res:getsf('gires/0x211F1DC0.tcp'):显示(41, 3):显示(41, 14):显示(41, 25)
                    --:显示(49, 17):显示(49, 31)
                end
            )
        )
    end

    召唤头像 = 召唤控件:创建按钮('召唤头像', 3, 3)



    local _转换 = {
        [2310] = 2302,  -- 修复九戒头像问题
        [2383] = 2029, 
        [4553] = 2097, 
        [6620] = 2209, 

    }
    do
        function 召唤头像:置头像(id)
            if not id then
                self:置正常精灵(__res:getspr('gires/main/pet.tca'))
                self:置按下精灵(__res:getspr('gires/main/pet.tca'):置中心(-1, -1))
            else
                if _转换[id] then
                    id = _转换[id]
                end
                self:置正常精灵(__res:getspr('gires3/button/zhstx/%s.tcp', id):置拉伸(32, 32))
                --这种 就是缺素材，头像素材 新增的召唤兽记得把头像加进去
                self:置按下精灵(__res:getspr('gires3/button/zhstx/%s.tcp', id):置拉伸(32, 32):置中心(-
                    1, -1))
            end
        end

        召唤头像.检查透明 = 召唤头像.检查点

        function 召唤头像:获得鼠标(x, y)
            if _召唤数据 then
                self:置提示('%s  忠诚：%s', _召唤数据.名称, _召唤数据.忠诚)
            end
        end

        function 召唤头像:左键弹起()
            窗口层:打开召唤()
        end

        function 召唤头像:键盘弹起(键码, 功能)
            if 功能 & SDL.KMOD_ALT ~= 0 and 键码 == SDL.KEY_O then
                self:左键弹起()
            end
        end
    end
    --===================================================================================
    召唤绿条 = 召唤控件:创建进度('召唤绿条', 41, 3, 66, 10)
    do
        function 召唤绿条:初始化()
            self:置精灵(__res:getspr('gires/0xB9D07413.tcp'))
        end

        function 召唤绿条:获得鼠标(x, y)
            if _召唤数据 then
                self:置提示('EXP(经验):%s/%s', _召唤数据.经验, _召唤数据.最大经验)
            end
        end

        function 界面层:置召唤经验(a, b)
            if type(a) == 'number' then
                b = b or _召唤数据.最大经验
                _召唤数据.经验 = a
                _召唤数据.最大经验 = b
                召唤绿条:置位置(a / b * 100)
            end
        end

        function RPC:置召唤经验(a, b)
            界面层:置召唤经验(a, b)
        end
    end
    --===================================================================================
    召唤红条 = 召唤控件:创建进度('召唤红条', 41, 14, 66, 10)
    do
        function 召唤红条:初始化()
            self:置精灵(__res:getspr('gires4/jdmh/qt/xtl/sx.tcp'))
        end

        function 召唤红条:获得鼠标(x, y)
            if _召唤数据 then
                self:置提示('HP(气血):%s/%s', _召唤数据.气血, _召唤数据.最大气血)
            end
        end

        function 召唤红条:右键弹起(x, y)
            界面层:置召唤气血(__rpc:角色_恢复召唤气血())
            self:获得鼠标(x, y)
        end

        function 界面层:置召唤气血(a, b)
            if type(a) == 'number' then
                if _召唤数据 then
                    b = b or _召唤数据.最大气血
                    _召唤数据.气血 = a
                    _召唤数据.最大气血 = b
                    召唤红条:置位置(a / b * 100)
                end
            end
        end

        function RPC:置召唤气血(a, b)
            界面层:置召唤气血(a, b)
        end
    end
    --===================================================================================
    召唤蓝条 = 召唤控件:创建进度('召唤蓝条', 41, 25, 66, 10)
    do
        function 召唤蓝条:初始化()
            self:置精灵(__res:getspr('gires4/jdmh/qt/xtl/sf.tcp'))
        end

        function 召唤蓝条:获得鼠标(x, y)
            if _召唤数据 then
                self:置提示('MP(法力):%s/%s', _召唤数据.魔法, _召唤数据.最大魔法)
            end
        end

        function 召唤蓝条:右键弹起(x, y)
            界面层:置召唤魔法(__rpc:角色_恢复召唤魔法())
            self:获得鼠标(x, y)
        end

        function 界面层:置召唤魔法(a, b)
            if type(a) == 'number' then
                if _召唤数据 then
                    b = b or _召唤数据.最大魔法
                    _召唤数据.魔法 = a
                    _召唤数据.最大魔法 = b
                    召唤蓝条:置位置(a / b * 100)
                end
            end
        end

        function RPC:置召唤魔法(a, b)
            界面层:置召唤魔法(a, b)
        end
    end

    --===================================================================================


    function 界面层:置召唤状态(t)
        _召唤数据 = t
        if type(t) == 'table' then
            if t.气血 and t.最大气血 then
                召唤红条:置位置(t.气血 / t.最大气血 * 100)
            end
            if t.魔法 and t.最大魔法 then
                召唤蓝条:置位置(t.魔法 / t.最大魔法 * 100)
            end
            if t.经验 and t.最大经验 then
                召唤绿条:置位置(t.经验 / t.最大经验 * 100)
            end
            召唤头像:置头像(t.原形 or t.外形)
        else
            召唤红条:置位置(0)
            召唤蓝条:置位置(0)
            召唤绿条:置位置(0)
            召唤头像:置头像()
        end
    end

    function RPC:界面信息_召唤(t)
        界面层:置召唤状态(t)
    end


end
--===================================================================================
local 人物控件 = 状态栏:创建控件('人物控件', -129, 0, 129, 50)
do
    function 人物控件:初始化()
        self:置精灵(
            生成精灵(
                129,
                46,
                function()
                    self:取拉伸图像_宽高('gires4/jdmh/yjan/lbkdt.tcp', 134, 46):置颜色(0
                        , 0, 0, 255):显示(0, 0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 89, 46):显示(46, 0)
                    self:取拉伸图像_宽高('gires/main/border.bmp', 46, 46):显示(0, 0)
                    __res:getsf('gires/0xB316A568.tcp'):显示(49, 3):显示(49, 17):显示(49, 31)
                end
            )
        )
    end

    人物头像 = 人物控件:创建按钮('人物头像', 3, 3)
    do
        function 人物头像:置头像(id)
            id = id or 1
            local spr = __res:getspr('photo/facesmall/%s.tga', id)
            if spr then
                self:置正常精灵(spr)
                self:置按下精灵(spr:复制():置中心(-1, -1))
            end
        end

        人物头像.检查透明 = 人物头像.检查点

        function 人物头像:左键弹起()
            窗口层:打开人物()
        end

        function 人物头像:键盘弹起(键码, 功能)
            if 功能 & SDL.KMOD_ALT ~= 0 and 键码 == SDL.KEY_W and not 战场层.是否可见 then
                self:左键弹起()
            end
        end

        function RPC:置人物头像(id)
            人物头像:置头像(id)
        end
    end
    --===================================================================================
    人物绿条 = 人物控件:创建进度('人物绿条', 49, 3, 80, 12)
    do
        function 人物绿条:初始化()
            self:置精灵(__res:getspr('gires/0x316EC1E4.tcp'))
        end

        function 人物绿条:获得鼠标(x, y)
            self:置提示('EXP(经验):%s/%s', 人物绿条.经验, 人物绿条.最大经验)
        end

        function 界面层:置人物经验(a, b)
            if type(a) == 'number' then
                b = b or 人物绿条.最大经验
                人物绿条.经验 = a
                人物绿条.最大经验 = b
                人物绿条:置位置(a / b * 100)
            end
        end

        function RPC:置人物经验(a, b)
            界面层:置人物经验(a, b)
        end
    end

    --===================================================================================
    人物红条 = 人物控件:创建进度('人物红条', 49, 17, 80, 12)
    do
        function 人物红条:初始化()
            self:置精灵(__res:getspr('gires/0xE8847FA1.tcp'))
        end

        function 人物红条:获得鼠标(x, y)
            self:置提示('HP(气血):%s/%s', 人物红条.气血, 人物红条.最大气血)
        end

        function 人物红条:右键弹起(x, y)
            界面层:置人物气血(__rpc:角色_恢复气血())
            self:获得鼠标(x, y)
        end

        function 界面层:置人物气血(a, b)
            if type(a) == 'number' then
                b = b or 人物红条.最大气血
                人物红条.气血 = a
                人物红条.最大气血 = b
                人物红条:置位置(a / b * 100)
            end
        end

        function RPC:置人物气血(a, b)
            界面层:置人物气血(a, b)
        end
    end

    --===================================================================================
    人物蓝条 = 人物控件:创建进度('人物蓝条', 49, 31, 80, 12)
    do
        function 人物蓝条:初始化()
            self:置精灵(__res:getspr('gires/0xF9E27E6E.tcp'))
        end

        function 人物蓝条:获得鼠标(x, y)
            self:置提示('MP(法力):%s/%s', 人物蓝条.魔法, 人物蓝条.最大魔法)
        end

        function 人物蓝条:右键弹起(x, y)
            界面层:置人物魔法(__rpc:角色_恢复法力())
            self:获得鼠标(x, y)
        end

        function 界面层:置人物魔法(a, b)
            if type(a) == 'number' then
                b = b or 人物蓝条.最大魔法
                人物蓝条.魔法 = a
                人物蓝条.最大魔法 = b
                人物蓝条:置位置(a / b * 100)
            end
        end

        function RPC:置人物魔法(a, b)
            界面层:置人物魔法(a, b)
        end
    end

    --===================================================================================

    function 界面层:置人物状态(t)
        if type(t) ~= 'table' then
            return
        end

        if t.气血 and t.最大气血 then
            界面层:置人物气血(t.气血, t.最大气血)
        end

        if t.魔法 and t.最大魔法 then
            界面层:置人物魔法(t.魔法, t.最大魔法)
        end

        if t.经验 and t.最大经验 then
            界面层:置人物经验(t.经验, t.最大经验)
        end

        if t.头像 then
            人物头像:置头像(t.头像)
        end
    end

    function RPC:界面人物(t)
        if type(t) == 'table' then
            界面层:置人物状态(t)
        end
    end
end

local BUFF网格 = 状态栏:创建网格('BUFF网格', -115, 50, 115, 115)
function BUFF网格:初始化()
    self:创建格子(22, 22, 1, 1, 5, 5)
    self.di = __res:getspr('gires3/button/buff-di.tcp')
    self.list = {}
    self.记录格子 = 0
end

function BUFF网格:子显示(x, y, i)
    if self.数据[i] then
        self.di:显示(x, y)
        self.数据[i]:显示(x + 1, y + 1)
    end
end

function BUFF网格:左键弹起(x, y, i)
    if self.数据[i] then
        return true
    end
end

function BUFF网格:置数据(list)
    self.list = list
    self.数据 = {}
    for h = 0, 20, 5 do
        local i = h
        for l = 5, 1, -1 do
            i = i + 1
            if list[i] then
                local 图标
                if list[i].图标 then
                    图标 = __res:getspr('item/item120/%04d.png', list[i].图标 or 1)
                elseif list[i].名称 then
                    local 物品库 = require("数据/物品库")
                    local t = 物品库[list[i].名称]
                    if t then
                        图标 = __res:getspr('item/item120/%04d.png', t.id)
                    end
                    if list[i].名称 == '祝福券' then
                        图标 = __res:getspr('item/item120/%04d.png', 7242)
                    end
                end
                if 图标 then
                    图标.nid = list[i].nid
                    self.数据[h + l] = 图标:置拉伸(20, 20, true)
                end
            end
        end
    end
end

function BUFF网格:获得鼠标(x, y, i)
    if self.记录格子 ~= i then
        self:清空描述(self.记录格子)
    end
    if self.数据[i] then
        if self.数据[i].描述 then
            鼠标层:坐标提示(x, y + 40, self.数据[i].描述)
            return
        end
        self.数据[i].描述 = __rpc:角色_获取任务详情(self.数据[i].nid)
        if type(r) == 'string' then
            鼠标层:坐标提示(x, y + 40, self.数据[i].描述)
        end
    end
    self.记录格子 = i
end

function BUFF网格:清空描述(i)
    if self.数据 and self.数据[i] then
        self.数据[i].描述 = nil
    end
end

--BUFF网格:注册事件
function 界面层:置BUFF(list)
    if type(list) ~= 'table' then
        return
    end
    BUFF网格:置数据(list)
end

function RPC:置BUFF(t)
    界面层:置BUFF(list)
end

function RPC:添加BUFF(t)
    if type(t) ~= 'table' then
        return
    end
    table.insert(BUFF网格.list, t)
    BUFF网格:置数据(BUFF网格.list)
end

function RPC:删除BUFF(nid)
    for i, v in ipairs(BUFF网格.list) do
        if v.nid == nid then
            table.remove(BUFF网格.list, i)
            break
        end
    end
    BUFF网格:置数据(BUFF网格.list)
end

return 状态栏
