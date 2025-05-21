

local 系统公告 = 登录层:创建控件('系统公告')
function 系统公告:初始化()
    self:置宽高(引擎.宽度, 引擎.高度)
    self:置精灵(__res:getspr('gires/0x27689D65.tcp'))
end
local 公告区域 = 系统公告:创建控件('公告区域', 20, 60, 600, 400)



local 文本 = 公告区域:创建文本('公告文本', 0, 0, 600, 400)

local 上翻按钮 = 系统公告:创建按钮('上翻按钮', 548, 446)
do
    function 上翻按钮:初始化()
        self:设置按钮精灵('gires/0x287AF2DA.tcp')
    end

    function 上翻按钮:左键弹起()
        文本:向上滚动()
    end
end

local 下翻按钮 = 系统公告:创建按钮('下翻按钮', 568, 446)
do
    function 下翻按钮:初始化()
        self:设置按钮精灵('gires/0x03539D9C.tcp')
    end

    function 下翻按钮:左键弹起()
        文本:向下滚动()
        -- 文本:滚动到底()

    end
end

local 下一步按钮 = 系统公告:创建按钮('下一步按钮', 588, 446)
do
    function 下一步按钮:初始化()
        self:设置按钮精灵('gires/0x703FA361.tcp')
    end

    function 下一步按钮:左键弹起()
        登录层:切换界面(登录层.选择区服)
    end

    function 下一步按钮:键盘弹起(键码, 功能)
        if 键码 == SDL.KEY_RETURN or 键码 == SDL.KEY_KP_ENTER then
            self:左键弹起()
        elseif 键码 == SDL.KEY_ESCAPE then
            登录层:切换界面(登录层.游戏开始)
        end
    end
end

function 系统公告:可见事件(v)
    if v then
        local r = __rpc:获取公告()
        if type(r) == 'string' then
            local w, h = 文本:置文本(r)
            文本:置高度(h)
        else
            文本:置文本('#R获取公告失败')
        end
    end
end
return 系统公告
